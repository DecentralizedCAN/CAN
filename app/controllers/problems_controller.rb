class ProblemsController < ApplicationController
  include UpvoteHelper
  before_action :set_problem, only: [:show, :edit, :update]
  before_action :check_activity, only: [:create]
  before_action :require_login, except: [:show], if: -> { public_viewable? }
  before_action :require_login, unless: -> { public_viewable? }
  before_action :require_admin_or_anarchy, only: [:new, :create]

  # GET /problems
  # GET /problems.json
  def index
    @problems = Problem.all.reverse
  end

  # GET /problems/1
  # GET /problems/1.json

  def show
    @solutions = @problem.solution.paginate(:page => params[:page], :per_page => 12)
    .order("score DESC")

    @criteria_count = @problem.criterium
      .joins(:user)
      .group("criteria.id").count.count

    if logged_in?
      @my_criteria = current_user.criterium
        .where(problem_id: @problem.id)

      @criteria = @problem.criterium
        .joins(:user)
        .group("criteria.id")
        .order("COUNT(user_id) DESC") - @my_criteria
        # .order("COUNT(user_id) DESC").first(16) - @my_criteria

      @user = this_user
    else
      @my_criteria = []

      @criteria = @problem.criterium
        .joins(:user)
        .group("criteria.id")
        .order("COUNT(user_id) DESC").first(16)
    end

    @discussion = @problem.discussion
    @comment = @discussion.comment.new
    @top_liked = @discussion.comment.left_joins(:upvotes)
      .group(:id)
      .having('count(upvotes.id) > 0')
      .order("COUNT(upvotes.id) DESC LIMIT 5")
      # .where("upvotes.id")
    
                        # .left_joins(:user)
                        # .group(:criterium_id)
                        # .order('COUNT(user_id) DESC')
 

    # @criteria = @problem.criterium
    #                     .left_joins(:user)
    #                     .group(:criterium_id)
    #                     .having('count(user_id) > 0')
    #                     .order('COUNT(user_id) DESC')


    if !@problem.updated || Time.now - @problem.updated > 600000 #if time since last done is more than ten minutes
      # update last time for problem
      @problem.update(:updated => Time.now)
      # update solution scores

      # @problem.solution.each do |solution|
      #   score = ApplicationController.helpers.solution_score(solution.id)
      #   solution.update!(:score => score)
      # end
    end
  end

  # GET /problems/new
  def new
    @problem = Problem.new
  end

  # GET /problems/1/edit
  def edit
  end

  # POST /problems
  # POST /problems.json
  def create
    @user = this_user
    @problem = Problem.new(problem_params)
    @problem.suggestion_min = 1 if @problem.suggestion_min == nil
    @problem.creator = current_user.id

    respond_to do |format|
      if @problem.save
        @problem.user << @user

        # create post and upvote
        @post = Post.create(:problem => @problem)
        @post.upvotes.create(user_id: current_user.id)

        # create discussion
        @discussion = Discussion.create(:problem => @problem, :title => "Discussion", :content => "Discussion for #{@problem.title}", :creator => @user.id)

        # keep record of user activity
        @user.update(:last_posted => Time.now)

        # @problem.send_problem_email
        format.html { redirect_to issue_path(@problem) }
        format.json { render :show, status: :created, location: @problem }
      else
        format.html { render :new }
        format.json { render json: @problem.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /problems/1
  # PATCH/PUT /problems/1.json
  def update
    respond_to do |format|
      if @problem.update(problem_params)
        format.html { redirect_to issue_path(@problem), notice: 'Problem was successfully updated.' }
        format.json { render :show, status: :ok, location: @problem }
      else
        format.html { render :edit }
        format.json { render json: @problem.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /problems/1
  # DELETE /problems/1.json
  def destroy
    if current_user.admin?
      @problem = Problem.find(params[:id])
      @problem.destroy
      respond_to do |format|
        format.html { redirect_to root_url, notice: 'Problem was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  end

  def sponsor
    @problem = Problem.find(params[:problem_id])
    @user = current_user
    @problem.user << @user unless @problem.user.include?(@user)
    begin
      auto_upvote_post(@problem.post.id, @user.id)
    rescue
    end
    redirect_to issue_path(:problem_id => @problem.id)
  end

  def unsponsor
    @problem = Problem.find(params[:problem_id])
    @user = current_user
    @problem.user.delete(@user)
    redirect_to issue_path(:problem_id => @problem.id)
  end

  # def add_criteria
  #   @problem = Problem.find(params[:id])

  #   render :nothing => true
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_problem
      @problem = Problem.find(params[:problem_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def problem_params
      params.require(:problem).permit(:title, :description, :suggestion_min)
    end

    def public_viewable?
      Setting.find(6).state
    end

    # def this_user
    #   return User.find(session[:user_id])
    # end
end
