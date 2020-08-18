class CriteriaController < ApplicationController
  include UpvoteHelper
  include SolutionsHelper
  include CommentsHelper

  before_action :set_criterium, only: [:show, :dissent_form, :edit, :update]
  before_action :require_login

  # GET /criteria
  # GET /criteria.json
  def index
    @criteria = Criterium.all
  end

  # GET /criteria/1
  # GET /criteria/1.json
  def show
    @user = current_user
  end

  def full
    @problem = Problem.find(params[:problem_id])

    @active_criteria = @problem.criterium
      .joins(:user)
      .group("criteria.id")

    @inactive_criteria = @problem.criterium - @active_criteria

    @criteria_count = @active_criteria.count.count

    @my_criteria = current_user.criterium
      .where(problem_id: @problem.id)

    @criteria = @problem.criterium
      .joins(:user)
      .group("criteria.id")
      .order("COUNT(user_id) DESC") - @my_criteria

  end

  def dissent_form
    
  end

  # GET /criteria/new
  def new
    @criterium = Criterium.new(:problem_id => params[:problem_id])
  end

  def add
    @criterium = Criterium.new(:problem_id => params[:problem_id], :title => params[:title])
    @criterium.save
  end

  # GET /criteria/1/edit
  def edit
  end

  # POST /criteria
  # POST /criteria.json
  def create
    @user = current_user
    @criterium = Criterium.new(criterium_params.except(:alt_id))
    @criterium.creator = @user.id

    if @criterium.save
      @criterium.user << @user unless (@criterium.problem.facilitator_id && @criterium.problem.facilitator_id != current_user.id) || criterium_params[:alt_id].length > 0

      if @criterium.problem.facilitator_id
        facilitator = User.find(@criterium.problem.facilitator_id)
        unless facilitator.id == @user.id
          notification = facilitator.notification.create(:details => "Someone has suggested a new criterion",
            :criterium_id => @criterium.id)
          if facilitator.email_notifications
            notification.send_email
          end
        end
      end
      
      # update_all_solution_scores(@criterium.problem.id)

      begin
        auto_upvote_post(@criterium.problem.post.id, @user.id)
      rescue
      end

      if @criterium.problem.facilitator_id && @criterium.problem.facilitator_id == current_user.id
      elsif @criterium.problem.facilitator_id
        flash[:success] = "You suggested a criterion. Please wait for the facilitator to review it. Thanks for your contribution!"
      else
        flash[:success] = "You created a criterion. Thanks for your contribution!"
      end

      # If this is an alt
      if criterium_params[:alt_id].length > 0
        @from = Criterium.find(criterium_params[:alt_id])
        @alternative = Crialt.new(:criterium_id => @from.id, :alternative => @criterium.id, :transferred_user_count => 0)
        if Crialt.where(criterium_id: @from.id).where(alternative: @criterium.id).count > 0
          redirect_to show_criterium_path(:criterium_id => @from.id)
        elsif @alternative.save
          new_comment('!chatlog suggested "' + Criterium.find(@alternative.alternative).title + '" as an alternative to "' + @from.title + '"', @from.problem.discussion.id)
          flash[:success] = "You suggested an alternative criterion. Thanks for your suggestion!"
        
          # send notifications
          if @from.crialt.count == 1
            @from.user.each do |user|
              notification = user.notification.create(:details => "Someone suggested an alternative to a criterion",
                :criterium_id => @from.id)
              if user.email_notifications
                notification.send_email
              end
            end     
          end
        end
      end
      
      redirect_to issue_path(:problem_id => @criterium.problem.hashid)

    else
      flash[:warning] = "Can't save criterion. It may be too long."
      redirect_back fallback_location: root_path
    end
  end

  def sponsor
    @criterium = Criterium.find(params[:criterium_id])
    @user = current_user
    @dissenter = @criterium.cridissent.find_by(user_id: @user.id)

    unless @criterium.problem.facilitator_id && @criterium.problem.facilitator_id == @user.id
      @dissenter.destroy if @dissenter
    end

    @criterium.user << @user unless @criterium.user.include?(@user)

    begin
      upvote_post(@criterium.problem.post.id, @user.id)
    rescue
    end
      
    # update_all_solution_scores(@criterium.problem.id)
    UpdateSolutionScoresJob.perform_later(@criterium.problem.id)

    auto_upvote_post(@criterium.problem.post.id, @user.id)

    redirect_back fallback_location: root_path
  end

  def unsponsor
    @criterium = Criterium.find(params[:criterium_id])
    @user = this_user
    @criterium.user.delete(@user)

    # update_all_solution_scores(@criterium.problem.id)
    UpdateSolutionScoresJob.perform_later(@criterium.problem.id)

    redirect_back fallback_location: root_path
  end

  def dissent
    @criterium = Criterium.find(params[:cridissent][:criterium_id])
    # dissent_count = @criterium.cridissent.count
    @user = this_user
    @criterium.user.delete(@user) unless @criterium.problem.facilitator_id && @criterium.problem.facilitator_id == @user.id
    
    if @criterium.cridissent.where(user_id: @user.id).empty?
      @dissenter = @criterium.cridissent.new(:user_id => @user.id, :title => params[:cridissent][:title])
      if @dissenter.save

        # log in chat
        if params[:cridissent][:title].length > 0
          content = ': "' + params[:cridissent][:title] + '"'
        else
          content = ''
        end

        new_comment('!chatlog Added a concern to a criterion (' + @criterium.title + ')' + content, @criterium.problem.discussion.id)

        # send notifications
          if @criterium.cridissent.count == 1
            @criterium.user.each do |user|
              notification = user.notification.create(:details => "Someone has a concern about a criterion",
                :criterium_id => @criterium.id)
              if user.email_notifications
                notification.send_email
              end
            end
            # @criterium.send_dissent_email          
          end

        begin
          auto_upvote_post(@criterium.problem.post.id, @user.id)
        rescue
        end

        # update_all_solution_scores(@criterium.problem.id)
        UpdateSolutionScoresJob.perform_later(@criterium.problem.id)

        flash[:success] = "You added a concern. Thanks for your input!"
        # redirect_to show_criterium_path(:criterium_id => @criterium.hashid)
        redirect_back fallback_location: show_criterium_path(:criterium_id => @criterium.hashid)
      end
    end
  end

  def assent
    @criterium = Criterium.find(params[:criterium_id])
    @user = this_user
    @dissenter = @criterium.cridissent.find_by(user_id: @user.id)
    @dissenter.destroy

    new_comment('!chatlog Removed their concern about a criterion (' + @criterium.title + ')', @criterium.problem.discussion.id)

    # update_all_solution_scores(@criterium.problem.id)
    UpdateSolutionScoresJob.perform_later(@criterium.problem.id)
    
    # redirect_to show_criterium_path(:criterium_id => @criterium.hashid)
    redirect_back fallback_location: show_criterium_path(:criterium_id => @criterium.hashid)
  end

  def alt
    @criterium = Criterium.find(params[:from])
    @alternative = Crialt.new(:criterium_id => params[:from], :alternative => params[:to], :transferred_user_count => 0)
    
    if Crialt.where(criterium_id: params[:from]).where(alternative: params[:to]).count > 0
      redirect_to show_criterium_path(:criterium_id => params[:from])
    elsif @alternative.save

      new_comment('!chatlog suggested "' + Criterium.find(@alternative.alternative).title + '" as an alternative to "' + @criterium.title + '"', @criterium.problem.discussion.id)

      # send notifications
      if @criterium.crialt.count == 1
        @criterium.user.each do |user|
          notification = user.notification.create(:details => "Someone suggested an alternative to a criterion",
            :criterium_id => @criterium.id)
          if user.email_notifications
            notification.send_email
          end
        end     
      end

      flash[:success] = "Thanks for your suggestion!"
      # redirect_to show_criterium_path(:criterium_id => params[:from])
      redirect_back fallback_location: root_path
    end
  end

  def accept_alt
    @crialt = Crialt.find(params[:crialt])
    @user = current_user
    @from = @crialt.criterium
    @to = Criterium.find(@crialt.alternative)
  
    if @from.user.include?(@user)
      @from.user.delete(@user)
      if !@to.user.include?(@user)
        @to.user << @user 
        @crialt.transferred_user_count += 1
      end
    end

    if @crialt.save
      # update_all_solution_scores(@crialt.criterium.problem.id)
      UpdateSolutionScoresJob.perform_later(@crialt.criterium.problem.id)
      
      if @crialt.criterium.problem.facilitator_id
        flash[:success] = "You accepted an alternative criteria."
      else
        flash[:success] = "You accepted an alternative criteria. Thanks for working towards convergence!"
      end
      # redirect_to show_criterium_path(:criterium_id => @from.hashid)
      redirect_back fallback_location: root_path
    end
  end

  # PATCH/PUT /criteria/1
  # PATCH/PUT /criteria/1.json
  def update
    respond_to do |format|
      if @criterium.update(criterium_params)
        format.html { redirect_to @criterium, notice: 'Criterium was successfully updated.' }
        format.json { render :show, status: :ok, location: @criterium }
      else
        format.html { render :edit }
        format.json { render json: @criterium.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /criteria/1
  # DELETE /criteria/1.json
  def destroy
    @criterium = Criterium.find(params[:id])
    @problem = @criterium.problem
    if current_user.admin? || (@problem.facilitator_id && @problem.facilitator_id == current_user.id)
      @criterium.destroy

      # update_all_solution_scores(@criterium.problem.id)
      UpdateSolutionScoresJob.perform_later(@criterium.problem.id)

      flash[:success] = 'Criterion was deleted.'

      redirect_back fallback_location: root_path

      # respond_to do |format|
      #   format.html { redirect_to issue_path(:problem_id => @problem.hashid), notice: 'Criterium was successfully destroyed.' }
      #   format.json { head :no_content }
      # end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_criterium
      @criterium = Criterium.find(params[:criterium_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def criterium_params
      params.require(:criterium).permit(:title, :alternatives, :problem_id, :dissenters, :alt_id)
    end

    # def update_all_solution_scores(problem_id)
    #   solutions = Problem.find(problem_id).solution.all
    #   solutions.each do |solution|
    #     solution.update(:score => solution_score(solution.id) * 100)
    #   end
    # end
end
