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
    @criterium = Criterium.new(criterium_params)
    @criterium.creator = @user.id

    if @criterium.save
      @criterium.user << @user
      
      begin
        auto_upvote_post(@criterium.problem.post.id, @user.id)
      rescue
      end
          
      # update_all_solution_scores(@criterium.problem.id)
      flash[:success] = "You created a criterion. Thanks for your contribution!"
      redirect_to issue_path(:problem_id => @criterium.problem.hashid)
    end
  end

  def sponsor
    @criterium = Criterium.find(params[:criterium_id])
    @user = current_user
    @dissenter = @criterium.cridissent.find_by(user_id: @user.id)
    @dissenter.destroy if @dissenter
    @criterium.user << @user unless @criterium.user.include?(@user)

    begin
      upvote_post(@criterium.problem.post.id, @user.id)
    rescue
    end
      
    update_all_solution_scores(@criterium.problem.id)

    auto_upvote_post(@criterium.problem.post.id, @user.id)

    redirect_back fallback_location: root_path
  end

  def unsponsor
    @criterium = Criterium.find(params[:criterium_id])
    @user = this_user
    @criterium.user.delete(@user)

    update_all_solution_scores(@criterium.problem.id)

    redirect_back fallback_location: root_path
  end

  def dissent
    @criterium = Criterium.find(params[:cridissent][:criterium_id])
    # dissent_count = @criterium.cridissent.count
    @user = this_user
    @criterium.user.delete(@user)
    if @criterium.cridissent.where(user_id: @user.id).empty?
      @dissenter = @criterium.cridissent.new(:user_id => @user.id, :title => params[:cridissent][:title])
      if @dissenter.save

        # log in chat
        if params[:cridissent][:title].length > 0
          content = ': ' + params[:cridissent][:title]
        else
          content = ''
        end

        new_comment('!chatlog objected to a criterion (' + @criterium.title + ')' + content, @criterium.problem.discussion.id)

        # send notifications
          if @criterium.cridissent.count == 1
            @criterium.user.each do |user|
              notification = user.notification.create(:details => "A criterion which you support has an objection",
                :criterium_id => @criterium.id)
              if user.email_notifications
                notification.send_email
              end
            end
            # @criterium.send_dissent_email          
          end

        update_all_solution_scores(@criterium.problem.id)

        flash[:success] = "You made an objection. Thanks for your input!"
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

    new_comment('!chatlog no longer objects to a criterion (' + @criterium.title + ')', @criterium.problem.discussion.id)

    update_all_solution_scores(@criterium.problem.id)
    
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

      flash[:success] = "Thanks for your suggestion!"
      redirect_to show_criterium_path(:criterium_id => params[:from])
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
      update_all_solution_scores(@crialt.criterium.problem.id)
      
      flash[:success] = "You accepted a alternative criteria. Thanks for working towards convergence!"
      redirect_to show_criterium_path(:criterium_id => @from.hashid)
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
    if current_user.admin?
      @criterium = Criterium.find(params[:id])
      @problem = @criterium.problem
      @criterium.destroy

      update_all_solution_scores(@criterium.problem.id)

      respond_to do |format|
        format.html { redirect_to issue_path(:problem_id => @problem.hashid), notice: 'Criterium was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_criterium
      @criterium = Criterium.find(params[:criterium_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def criterium_params
      params.require(:criterium).permit(:title, :alternatives, :problem_id, :dissenters)
    end

    def update_all_solution_scores(problem_id)
      solutions = Problem.find(problem_id).solution.all
      solutions.each do |solution|
        solution.update(:score => solution_score(solution.id) * 100)
      end
    end
end
