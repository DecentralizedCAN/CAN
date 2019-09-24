class ActivitiesController < ApplicationController
  before_action :set_activity, only: [:show, :edit, :update]
  before_action :check_activity, only: [:create, :suggest]
  before_action :require_login

  require 'time'
  require 'date'

  # GET /activities
  # GET /activities.json
  def index
    @user = current_user
    @activities = Activity.all.reorder('created_at DESC')
  end

  # GET /activities/1
  # GET /activities/1.json
  def show
    @user = current_user
    @roll = @activity.roll.first

    @current_time = Time.now.to_i

    @discussion = @activity.discussion
    @comment = @discussion.comment.new
    @top_liked = @discussion.comment.left_joins(:upvotes)
      .group(:id)
      .having('count(upvotes.id) > 0')
      .order("COUNT(upvotes.id) DESC LIMIT 5") #probably won't work in postgres
      # .where("upvotes.id")
    # @actdissent = Actdissent.find_by(activity_id: @activity.id)
  end

  # GET /activities/new
  def new
    @activity = Activity.new
  end

  def activate
    @solution = Solution.find(params[:solution_id])
    @activity = Activity.new(:title => @solution.title,
                            :description => @solution.description)

    respond_to do |format|
      format.html { render :new }
    end
  end

  # GET /activities/1/edit
  def edit
  end

  # POST /activities
  # POST /activities.json
  def create

    if activity_params[:expiration].to_i > 0
      expiration = activity_params[:expiration].to_i.days.from_now.to_i
    else
      expiration = nil
    end

    if activity_params[:deadline].to_i > 0
      deadline = activity_params[:deadline].to_i.days.from_now.to_i
    else
      deadline = nil
    end


    puts expiration
    puts deadline

    @activity = Activity.new(:title => activity_params[:title],
                            :description => activity_params[:description],
                            :expiration => expiration,
                            :deadline => deadline,
                            :creator => current_user.name)

    puts "---------------------------------"
    puts activity_params
    puts @activity.to_json
    puts "---------------------------------"

    if activity_params[:activation_minimum].to_i > 0 
      minimum = activity_params[:activation_minimum]
    else
      minimum = 1
    end

    if activity_params[:activation_maximum].to_i > 0 
      maximum = activity_params[:activation_maximum]
    else
      # maximum = User.count
      # maximum = Float::INFINITY
      maximum = nil
    end

    respond_to do |format|
      if @activity.save

        # create participant roll
        @roll = Roll.create(:title => "participant",
                        :description => "participant",
                        :minimum => minimum,
                        :maximum => maximum,
                        :activity_id => @activity.id)

        # create completed roll
        @roll = Roll.create(:title => "completed",
                        :description => "completed",
                        :minimum => 1,
                        :maximum => nil,
                        :activity_id => @activity.id)


        # create post and upvote
        @post = Post.create(:activity => @activity)
        @post.upvotes.create(user_id: current_user.id)

        # create discussion
        @discussion = Discussion.create(:activity => @activity, :title => "Activity", :content => "Discussion for #{@activity.title}")

        # track user activity
        current_user.update(:last_posted => Time.now)

      # if @roll.save

        # @activity.send_activity_email

        format.html { redirect_to action_path(@activity.id) }
        format.json { render :show, status: :created, location: @activity }
      else
        format.html { render :new }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
        # end
      end
    end
  end

  def suggest
    @solution = Solution.find(params[:solution_id])
    @problem = @solution.problem
    @user = current_user

    already_suggested = @solution.user.include?(@user)

    if @solution.user.count == @problem.suggestion_min-1 && !already_suggested
      @activity = Activity.new(:title => @solution.title,
                            :description => @solution.description,
                            :solution_id => @solution.id,
                            :creator => @user.name)

      respond_to do |format|
        if @activity.save

          # keep record of user activity
          @user.update(:last_posted => Time.now)

          @solution.user << @user unless already_suggested || @solution.user.count == @problem.suggestion_min

          @solution.roll.first.update(:activity_id => @activity.id)

          # create completed roll
          @roll = Roll.create(:title => "completed",
                          :description => "completed",
                          :minimum => 1,
                          :maximum => nil,
                          :activity_id => @activity.id)

          @post = Post.create(:activity => @activity)
          @post.upvotes.create(user_id: current_user.id)


          # create discussion
          @discussion = Discussion.create(:activity => @activity, :title => "Activity", :content => "Discussion for #{@activity.title}")

          # Notifications
            # if @roll.user.count == @roll.minimum && @user.email_notifications
          @solution.user.each do |user|
            notification = user.notification.create(:details => "was created from the brainstorm \"" + @problem.title + "\"",
              :activity_id => @activity.id)
            notification.send_email
          end
              # @activity.send_activated_email
            # end  
          # End notifications

          puts @post

          format.html { redirect_to action_path(@activity.id) }
          format.json { render :show, status: :created, location: @activity }
        else
          format.html { redirect_to issue_path(@problem, :anchor => "solutions") }
          format.json { render json: @activity.errors, status: :unprocessable_entity }
        end
      end

    elsif !already_suggested
      @solution.user << @user
      redirect_to issue_path(@problem, :anchor => "solutions")
    else
      redirect_to issue_path(@problem, :anchor => "solutions")
    end
  end

  def commit
    @roll = Roll.find(params[:roll_id])
  end

  def participate
    @roll = Roll.find(params[:roll_id])
    @user = current_user
    @activity = @roll.activity
    unless @roll.user.include?(@user) || (@roll.maximum && @roll.user.count >= @roll.maximum)
      @roll.user << @user

      # Notifications
      if @roll.user.count == @roll.minimum && @user.email_notifications
        @roll.user.each do |user|
          notification = user.notification.create(:details => "has reached minimum participation and will take place",
            :activity_id => @activity.id)
          notification.send_email
        end
        # @activity.send_activated_email
      end  
      # End notifications
    end
    redirect_to action_path(:activity_id => @roll.activity.id)
  end

  def cancel
    
  end

  def complete
    @activity = Activity.find(params[:activity_id])
    @roll = @activity.roll.last
    unless @roll.user.include?(current_user)
      @roll.user << current_user
      redirect_to action_path(:activity_id => @roll.activity.id)
    end
  end

  def dissent
    puts params[:actdissent][:activity_id]
    @activity = Activity.find(params[:actdissent][:activity_id])
    @user = this_user
    @activity.user.delete(@user)
    if @activity.actdissent.where(user_id: @user.id).empty?
      @dissenter = @activity.actdissent.new(:user => @user, :title => params[:actdissent][:title])
      @dissenter.save
    end
    redirect_to action_path(:activity_id => @activity.id)
  end

  def assent
    @activity = Activity.find(params[:activity_id])
    @user = this_user
    @dissenter = @activity.actdissent.find_by(user: @user)
    @dissenter.destroy
    redirect_to action_path(:activity_id => @activity.id)
  end

  # PATCH/PUT /activities/1
  # PATCH/PUT /activities/1.json
  def update
    respond_to do |format|
      if @activity.update(activity_params)
        format.html { redirect_to @activity, notice: 'Action was successfully updated.' }
        format.json { render :show, status: :ok, location: @activity }
      else
        format.html { render :edit }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /activities/1
  # DELETE /activities/1.json
  def destroy
    if current_user.admin?
      @activity = Activity.find(params[:id])
      @activity.destroy
      @activity.post.destroy if @activity.post
      respond_to do |format|
        format.html { redirect_to root_url, notice: 'Action was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_activity
      @activity = Activity.find(params[:activity_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def activity_params
      params.require(:activity).permit(:title, :description, :activation, :participants, :activation_minimum, :activation_maximum, :deadline, :expiration)
    end
end
