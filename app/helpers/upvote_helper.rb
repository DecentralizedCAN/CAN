module UpvoteHelper
  def upvote_post(post_id, user_id)
    if !Upvote.where(user_id: user_id, post_id: post_id).exists?
      Post.find(post_id).upvotes.create(user_id: current_user.id)
    end
  end
end