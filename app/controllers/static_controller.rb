class StaticController < ApplicationController
	before_action :require_login, except: [:documentation, :main_feed, :welcome, :home], if: -> { public_viewable? }
	before_action :require_login, unless: -> { public_viewable? }

	def choice
	end

	def welcome
	end

	def about
		
	end

	def home
		if logged_in?
			@user = current_user
			@commitments = @user.rolls
			@sponsored_problems = @user.problems.order("created_at DESC")
			@proposals = @user.solutions.order("created_at DESC")
			@current_time = Time.now.to_i
	    @notifications = current_user.notification.order("created_at DESC").where(:read => nil).first(6) if logged_in?
		else
			# redirect_to documentation_path
		end
	end

	def main_feed
		@public_viewable = public_viewable?
		# unless current_user.admin?
		# 	redirect_to root_url
		# end

		# require 'net/smtp'

		# message = 'MESSAGE_END
		# From: Private Person <me@fromdomain.com>
		# To: A Test User <test@todomain.com>
		# Subject: SMTP e-mail test

		# This is a test e-mail message.'

		# Net::SMTP.start('localhost') do |smtp|
		#   smtp.send_message message, 'me@fromdomain.com', 'test@todomain.com'
		# end

		if params[:sort] != "recent"
			(!params[:group] || params[:group] == '0') ? group_id = nil : group_id = params[:group]
			@posts = Post.left_joins(:upvotes)
			  .where(:group_id => group_id)
			  .group(:id)
				.having('count(upvotes.id) > 0')
			  .paginate(:page => params[:page], :per_page => 12)
			  .order("COUNT(upvotes.id) / (( extract(epoch from now()) - extract(epoch from posts.created_at) / 1.002) ) DESC")
		else
			(!params[:group] || params[:group] == '0') ? group_id = nil : group_id = params[:group]
			@posts = Post.left_joins(:upvotes)
			  .where(:group_id => group_id)
			  .group(:id)
			  .having('count(upvotes.id) > 0')
			  .paginate(:page => params[:page], :per_page => 12)
			  .order('created_at DESC')
		end

		# User.first.notification.create(:details => "test", :activity_id => 1)

    @current_time = Time.now.to_i
    @notifications = current_user.notification.order("created_at DESC").where(:read => nil).first(6) if logged_in?

	end

	def documentation
		
	end

	def notifications
    @notifications = current_user.notification.order("created_at DESC")
    .paginate(:page => params[:page], :per_page => 20)
	end

	def notification_redirect
		@notification = Notification.find(params[:notification_id])
		@notification.read = true
		@notification.save

		if @notification.activity
			redirect_to action_path(@notification.activity.hashid)
		elsif @notification.problem
			redirect_to issue_path(:problem_id => @notification.problem.hashid)
		elsif @notification.criterium
			# redirect_to show_criterium_path(:criterium_id => @notification.criterium.hashid)
			# redirect_to issue_path(:problem_id => @notification.criterium.problem.hashid)
			if current_user.admin?
				redirect_to full_criterium_path(:problem_id => @notification.criterium.problem.hashid, :view => "suggested"), data: { turbolinks: false }
			else
				redirect_to full_criterium_path(:problem_id => @notification.criterium.problem.hashid), data: { turbolinks: false }
			end
		elsif @notification.discussion
			if @notification.discussion.activity
				redirect_to action_path(@notification.discussion.activity.hashid)
			elsif @notification.discussion.problem
				redirect_to issue_path(:problem_id => @notification.discussion.problem.hashid, :discussion => "open")
			else
				redirect_to discussion_path(@notification.discussion.hashid)				
			end
		end
	end

	def clear_notification
		@n = Notification.find(params[:notification_id])
		@n.read = true
		@n.save
		redirect_back fallback_location: root_path  
	end

	def clear_notifications
		current_user.notification.where(:read => nil).each do |notification|
			notification.read = true
			notification.save
		end

		redirect_back fallback_location: root_path
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

	private
    def public_viewable?
      Setting.find(6).state
    end

end