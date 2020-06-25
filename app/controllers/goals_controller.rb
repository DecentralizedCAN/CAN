class GoalsController < ApplicationController
  before_action :require_login

	def index
		@goals = Goal.all.reverse
	end

	def show
		@user = current_user
		@goal = Goal.find(params[:goal_id])
		# @my_goals = @user.goals.all.reverse
		@my_goals = Goal.all.reverse
		@parents = @user.link.where(child_id: @goal.id)
		@children = @user.link.where(parent_id: @goal.id)

		@public_parents = Link.where(child_id: @goal.id)
			.joins(:user)
      .group("links.id")
      .order("COUNT(user_id) DESC")
      # .first(10)

		@public_children = Link.where(parent_id: @goal.id)
			.joins(:user)
      .group("links.id")
      .order("COUNT(user_id) DESC")
      # .first(10)

		@new_goal = Goal.new
	end

	def details
		@user = current_user
		@goal = Goal.find(params[:goal_id])
		# @my_goals = @user.goals.all.reverse
		@my_goals = Goal.all.reverse
		@parents = @user.link.where(child_id: @goal.id)
		@children = @user.link.where(parent_id: @goal.id)

		@public_parents = Link.where(child_id: @goal.id)
			.joins(:user)
      .group("links.id")
      .order("COUNT(user_id) DESC")

		@public_children = Link.where(parent_id: @goal.id)
			.joins(:user)
      .group("links.id")
      .order("COUNT(user_id) DESC")

	end

	def new
		@goal = Goal.new
	end

	def create
		@goal = Goal.new(:title => params[:goal][:title])
		# @goal.users << current_user unless @goal.users.include?(current_user)


		if @goal.save

			if params[:goal][:parent_id]
				@link = Link.new(:child_id => @goal.id, :parent_id => params[:goal][:parent_id])
				@link.save(:validate => false)
				@link.user << current_user unless @link.user.include?(current_user)
				
				# redirect_to @goal
			elsif params[:goal][:child_id]
				@link = Link.new(:parent_id => @goal.id, :child_id => params[:goal][:child_id])
				@link.save(:validate => false)
				@link.user << current_user unless @link.user.include?(current_user)

				# redirect_to @goal
			else
				# redirect_to @goal
			end

      # create post and upvote
			if params[:goal][:post_goal] && Setting.find(13).state
        @post = Post.create(:link_id => @link.id)
        @post.upvotes.create(user_id: current_user.id)				
			end

		elsif Goal.find_by(:title => params[:goal][:title]).present?

			@goal = Goal.find_by(:title => params[:goal][:title])
			# @goal.users << current_user unless @goal.users.include?(current_user)

			if Link.find_by(:child_id => @goal.id, :parent_id => params[:goal][:parent_id]).present?
				@link = Link.find_by(:child_id => @goal.id, :parent_id => params[:goal][:parent_id])
				@link.user << current_user unless @link.user.include?(current_user)
			else
				# ONLY MAKES CHILD LINK, NOT PARENT LINK, CHANGE IF USING PARENT LINKS AGAIN
				@link = Link.new(:child_id => @goal.id, :parent_id => params[:goal][:parent_id])
				@link.save(:validate => false)
				@link.user << current_user unless @link.user.include?(current_user)
			end

			# redirect_to @goal
  		redirect_back fallback_location: root_path
		else
      flash[:warning] = "Can't create goal. It may be too long."
      redirect_back fallback_location: root_path
		end
	end

	def complete_goal
		@goal = Goal.find(params[:goal_id])
		@goal.users << current_user unless @goal.users.include?(current_user)
  	redirect_back fallback_location: root_path
	end

	def uncomplete_goal
		@goal = Goal.find(params[:goal_id])
		@goal.users.delete(current_user)
  	redirect_back fallback_location: root_path
	end

	def newlink
		if params[:child_id] != params[:parent_id]
			@link = Link.find_by(:child_id => params[:child_id], :parent_id => params[:parent_id])

			if !@link
				@link = Link.new(:child_id => params[:child_id], :parent_id => params[:parent_id])
				@link.save(:validate => false)
			end

			@link.user << current_user unless @link.user.include?(current_user)
		end

    redirect_back fallback_location: root_path
	end

	def link
		@link = Link.find(params[:link_id])
		@link.user << current_user unless @link.user.include?(current_user)
		# @goal = Goal.find(@link.child_id)
		# @goal.users << current_user unless @goal.users.include?(current_user)
  	redirect_back fallback_location: root_path
	end

	def unlink
		@link = Link.find(params[:link_id])
		@link.user.delete(current_user)
  	redirect_back fallback_location: root_path
	end

	private

    # def link_params
    #   params.require(:link).permit(:parent_id, :child_id)
    # end

end