class NotificationsController < ApplicationController
  def broadcast_post
    @post = Post.find(params[:post_id])
    @discussion = @post.discussion
    @problem = @post.problem
    @action = @post.activity

    if @discussion
      User.all.each do |user|
        notification = user.notification.create(:details => @discussion.title + ": check out this new discussion.",
          :discussion_id => @discussion.id)
        
          notification.send_email if user.email_notifications
      end

    elsif @problem
      User.all.each do |user|
        unless @problem.user.include?(user)
          
          notification = user.notification.create(:details => @problem.title + "was just created. Check it out!", 
            :problem_id => @problem.id)
        
          notification.send_email if user.email_notifications
        end

      end

    elsif @action
      User.all.each do |user|
        notification = user.notification.create(:details => "was just created. Would you like to participate?",
          :activity_id => @action.id)
        
          notification.send_email if user.email_notifications
      end
      
    end
  end

  def broadcast_criterion
    @criterion = Criterium.find(params[:criterion_id])
    @problem = Problem.find(@criterion.problem.id)

    @problem.user.each do |user|
      notification = user.notification.create(:details => "has a new criterion: \"" + @criterion.title + "\". Do you want to support it?",
        :problem_id => @problem.id)
      
      notification.send_email if user.email_notifications
    end
  end
end