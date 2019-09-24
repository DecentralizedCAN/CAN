class UpvotesController < ApplicationController
  before_action :require_login
	before_action :find_post
	before_action :find_upvote, only: [:destroy]

 #  def create
	#   if already_upvoted?
	#     flash[:notice] = "You already upvoted"
	#   else
	#     @post.upvotes.create(user_id: current_user.id)
	#   end
	#   # redirect_to root_url
 #  end

	# def destroy
	#   if !(already_upvoted?)
	#     flash[:notice] = "Not upvoted"
	#   else
	#     @upvote.destroy
	#   end
	#   # redirect_to root_url
	# end

	def upvote
	  if already_upvoted?
	    flash[:notice] = "You already upvoted this"
	  else
	    @post.upvotes.create(user_id: current_user.id)
	  end
	end

	def unupvote
	  if !(already_upvoted?)
	    flash[:notice] = "Not upvoted"
	  else
			@upvote = @post.upvotes.find_by(:user_id => current_user.id)
	    @upvote.destroy
	  end
	end

	def like
	  if already_liked?
	    flash[:notice] = "You already liked this"
	  else
	    @comment.upvotes.create(user_id: current_user.id)
	  end
	end

	def unlike
	  if !(already_liked?)
	    flash[:notice] = "Not liked"
	  else
			@like = @comment.upvotes.find_by(:user_id => current_user.id)
	    @like.destroy
	  end
	end

  private
  def find_post
  	if params[:post_id]
  		@post = Post.find(params[:post_id])
		elsif params[:comment_id]
  		@comment = Comment.find(params[:comment_id])
		end
  end

	def find_upvote
		@upvote = @post.upvotes.find(params[:like_id])
	end

	def already_upvoted?
	  Upvote.where(user_id: current_user.id, post_id:
	  params[:post_id]).exists?
	end

	def already_liked?
	  Upvote.where(user_id: current_user.id, comment_id:
	  params[:comment_id]).exists?
	end
end