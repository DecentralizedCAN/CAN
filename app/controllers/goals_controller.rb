class GoalsController < ApplicationController

	def index
		@goals = Goal.all
	end

	def show
		@goal = Goal.find(params[:goal_id])
		@my_goals = Goal.all
		@parents = Link.where(child_id: @goal.id)
		@children = Link.where(parent_id: @goal.id)
	end

	def new
		
	end

	def create
		
	end

	def adopt
		
	end

	def abandon
		
	end

end