class StaticController < ApplicationController
	before_action :require_login, except: [:documentation]

	def home
	end

	def main_feed

		if true
			@posts = Post.left_joins(:upvotes)
			  .group(:id)
				.having('count(upvotes.id) > 0')
			  .paginate(:page => params[:page], :per_page => 12)
			  .order("COUNT(upvotes.id) / (( extract(epoch from now()) - extract(epoch from posts.created_at) / 1.002) ) DESC")
		else
			@posts = Post.paginate(:page => params[:page], :per_page => 12)
			  .order('created_at DESC')
		end

    @current_time = Time.now.to_i
    @notifications = current_user.notification.order("created_at DESC").first(6) if logged_in?

	end

	def documentation
		
	end

	def notifications
    @notifications = current_user.notification.order("created_at DESC")
    .paginate(:page => params[:page], :per_page => 20)
	end

	def destroy
		if current_user.admin?
			@post = Post.find(params[:post_id])
			@post.destroy
		end
	end

	def commitments
		@user = current_user

		# puts @user.to_json
		# redirect_to login_path if @user == nil

		@commitments = @user.rolls
		@sponsored_problems = @user.problems
		# @problems = Problem.last(5)
		# @activities = Activity.last(5)
		@proposals = @user.solution
    @current_time = Time.now.to_i
	end

	def manage
		if current_user.admin?
	    @problems = Problem.paginate(:page => params[:page], :per_page => 100).order('created_at DESC')
	    @activities = Activity.paginate(:page => params[:page], :per_page => 100).order('created_at DESC')
	    @discussions = Discussion.paginate(:page => params[:page], :per_page => 100).order('created_at DESC')
		else
			redirect_to root_url			
		end
	end

	def wakemydyno
		render "wakemydyno.txt"
	end

end