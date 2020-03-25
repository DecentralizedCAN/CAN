class SolutionsController < ApplicationController
  include SolutionsHelper

  before_action :set_solution, only: [:show, :edit, :update, :destroy, :poll]
  before_action :check_activity, only: [:create]
  before_action :require_login

  # GET /solutions
  # GET /solutions.json
  def index
    @solutions = Solution.all
  end

  # GET /solutions/1
  # GET /solutions/1.json
  def show
    @user = this_user if logged_in?
    @problem = @solution.problem

    @polls = @solution.poll
    @criteria = @problem.criterium
      .joins(:user)
      .group("criteria.id")
      .order("COUNT(user_id) DESC")

    @discussion = @solution.discussion
    @comment = @discussion.comment.new
    @top_liked = @discussion.comment.left_joins(:upvotes)
      .group(:id)
      .having('count(upvotes.id) > 0')
      .order("COUNT(upvotes.id) DESC LIMIT 5")

    @solution.update(:score => solution_score(@solution.id) * 100)



    # @polls = @problem.criterium.left_joins(:poll).where("polls.solution_id = #{@solution.id}")

    # puts @criteria.first.user.to_json
  end

  # GET /solutions/new
  def new
    @user = this_user
    @solution = Solution.new(:problem_id => params[:problem_id])
    @problem = Problem.find(params[:problem_id])
  end

  # GET /solutions/1/edit
  def edit
  end

  # POST /solutions
  # POST /solutions.json
  def create
    @solution = Solution.new(:title => solution_params[:title],
                            :description => solution_params[:description],
                            :problem_id => solution_params[:problem_id],
                            :creator => current_user.id)

    if solution_params[:activation_minimum].to_i > 0 
      minimum = solution_params[:activation_minimum]
    else
      minimum = 1
    end

    if solution_params[:activation_maximum].to_i > 0 
      maximum = solution_params[:activation_maximum]
    else
      # maximum = User.count
      maximum = nil
    end

    respond_to do |format|
      if @solution.save
        # @solution.send_solution_email

        # @roll = Roll.create(:title => "participant",
        #                 :description => "participant",
        #                 :minimum => minimum,
        #                 :maximum => maximum,
        #                 :solution_id => @solution.id)

        @roles = JSON.parse(solution_params[:role_json])

        @roles.each do |role|

          minimum = role['minimum'].to_i
          minimum = 1 unless role['minimum'].to_i > 0          

          maximum = role['maximum'].to_i
          maximum = nil unless role['maximum'].to_i >= minimum

          Roll.create(:title => role['title'],
                      :description => role['description'],
                      :minimum => minimum,
                      :maximum => maximum,
                      :solution_id => @solution.id)

        end

        # create discussion
        @discussion = Discussion.create(:solution => @solution, :title => "Discussion", :content => "Discussion for #{@solution.title}")

        # keep record of user activity
        current_user.update(:last_posted => Time.now)

        format.html { redirect_to solution_path(:problem_id => @solution.problem_id, :solution_id => @solution.id) }
        format.json { render :show, status: :created, location: @solution }
      else
        @problem = @solution.problem
        format.html { render :new }
        format.json { render json: @solution.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /solutions/1
  # PATCH/PUT /solutions/1.json
  def update
    respond_to do |format|
      if @solution.update(solution_params)
        format.html { redirect_to @solution }
        format.json { render :show, status: :ok, location: @solution }
      else
        format.html { render :edit }
        format.json { render json: @solution.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /solutions/1
  # DELETE /solutions/1.json
  def destroy
    if current_user.admin?
      @problem = @solution.problem
      @solution.destroy
      respond_to do |format|
        format.html { redirect_to issue_path(@problem), notice: 'Solution was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  end


  def poll
    @criterium = Criterium.find(params[:criterium_id])
    @answer = params[:answer].to_i

    @user = this_user
    @poll = @criterium.poll.where(solution_id: @solution.id).where(user_id: @user.id)
    # score = @criterium.acp(@user.id) * @answer.to_f

    if @poll.count > 0
      # @poll.update(:answer => score)
      if @poll.update(:answer => @answer)
        puts @poll.to_json
      end
    else
      @poll = @criterium.poll.new(:user_id => @user.id, :solution_id => @solution.id, 
                                  :answer => @answer)

      @poll.save
    end

    redirect_to solution_path(:solution_id => @solution.id, :problem_id => @solution.problem_id, :anchor => @criterium.hash)
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_solution
      @solution = Solution.find(params[:solution_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def solution_params
      params.require(:solution).permit(:title, :description, :problem_id, :role_json)
    end
end
