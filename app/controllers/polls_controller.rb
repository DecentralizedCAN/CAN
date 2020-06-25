class PollsController < ApplicationController
  include SolutionsHelper
  
  before_action :set_poll, only: [:show, :edit, :update, :destroy]
  before_action :require_login

  # GET /polls
  # GET /polls.json
  def index
    @polls = Poll.all
  end

  # GET /polls/1
  # GET /polls/1.json
  def show
  end

  # GET /polls/new
  def new
    @poll = Poll.new
  end

  # GET /polls/1/edit
  def edit
  end

  # POST /polls
  # POST /polls.json
  def create
    @poll = Poll.new(poll_params)

    respond_to do |format|
      if @poll.save
        format.html { redirect_to @poll, notice: 'Poll was successfully created.' }
        format.json { render :show, status: :created, location: @poll }
      else
        format.html { render :new }
        format.json { render json: @poll.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /polls/1
  # PATCH/PUT /polls/1.json
  def update
    respond_to do |format|
      if @poll.update(poll_params)
        format.html { redirect_to @poll, notice: 'Poll was successfully updated.' }
        format.json { render :show, status: :ok, location: @poll }
      else
        format.html { render :edit }
        format.json { render json: @poll.errors, status: :unprocessable_entity }
      end
    end
  end

  def quiet_set
    begin
      @criterium = Criterium.find(params[:criterium_id])
      @answer = params[:answer].to_i
      @solution_id = params[:solution_id]

      @user = this_user
      @poll = @criterium.poll.where(solution_id: @solution_id).where(user_id: @user.id)

      if params[:answer] == nil
        @poll.destroy_all
      elsif @poll.count > 0

        if @poll.update(:answer => @answer)
          puts @poll.to_json
        end
      else
        @poll = @criterium.poll.new(:user_id => @user.id, :solution_id => @solution_id, 
                                    :answer => @answer)
        @poll.save
      end

      # update_all_solution_scores(@criterium.problem.id)
      UpdateSolutionScoresJob.perform_later(@criterium.problem.id)
    rescue
    end

    redirect_back fallback_location: root_path
  end

  # DELETE /polls/1
  # DELETE /polls/1.json
  def destroy
    @poll.destroy
    respond_to do |format|
      format.html { redirect_to polls_url, notice: 'Poll was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_poll
      @poll = Poll.find(params[:poll_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def poll_params
      params.require(:poll).permit(:answers, :solution_id, :user_id)
    end

    def update_all_solution_scores(problem_id)
      solutions = Problem.find(problem_id).solution.all
      solutions.each do |solution|
        solution.update(:score => solution_score(solution.id) * 100)
      end
    end
end
