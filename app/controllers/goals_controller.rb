class GoalsController < ApplicationController

	def index
		@goals = Goal.all.reverse
	end

	def show
		@user = current_user
		@goal = @user.goals.find(params[:goal_id])
		@my_goals = @user.goals.all.reverse
		@parents = @user.links.where(child_id: @goal.id)
		@children = @user.links.where(parent_id: @goal.id)
		@new_goal = Goal.new
	end

	def new
		@goal = Goal.new
	end

	def create
		@goal = Goal.new(:title => params[:goal][:title])
		@goal.users << current_user

		if @goal.save

			if params[:goal][:parent_id]
				@link = Link.create(:child_id => @goal.id, :parent_id => params[:goal][:parent_id])
				@link.users << current_user
				
				redirect_to Goal.find(params[:goal][:parent_id])
			elsif params[:goal][:child_id]
				@link = Link.create(:parent_id => @goal.id, :child_id => params[:goal][:child_id])
				@link.users << current_user

				redirect_to Goal.find(params[:goal][:child_id])
			else
				redirect_to @goal
			end

		else
    	redirect_back fallback_location: root_path
		end
	end

	def adopt
		
	end

	def abandon

	end

	def link
		if params[:child_id] != params[:parent_id]
			@link = Link.find_by(:child_id => params[:child_id], :parent_id => params[:parent_id])

			if !@link
				@link = Link.create(:child_id => params[:child_id], :parent_id => params[:parent_id])
			end

			@link.users << current_user
		end

    redirect_back fallback_location: root_path
	end

	def unlink
		Link.find(params[:link_id]).users.delete(current_user)
  	redirect_back fallback_location: root_path
	end

	private

    # def link_params
    #   params.require(:link).permit(:parent_id, :child_id)
    # end

end