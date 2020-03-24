module UpvoteHelper
  def auto_upvote_post(post_id, user_id)
    if !Upvote.where(user_id: user_id, post_id: post_id).exists?
      Post.find(post_id).upvotes.create(user_id: current_user.id)
    end

    if Post.find(post_id).problem
      @problem = Post.find(post_id).problem
      @problem.user << current_user unless @problem.user.include?(current_user)
    end
  end
end