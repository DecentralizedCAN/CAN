module ActivitiesHelper
  def total_minimum(action)
    total = 0

    action.roll.each do |role|
      total += role.minimum
    end

    total
  end

  def total_maximum(action)
    total = 0

    action.roll.each do |role|
      if role.maximum
        total += role.maximum 
      else
        return nil
      end
    end

    if total > total_minimum(action)
      total
    else
      nil
    end

  end

  def total_committed(action)
    total = 0

    action.roll.each do |role|
      total += [role.user.count, role.minimum].min
    end

    total
  end

  def total_complete(action)
    total = 0

    action.roll.each do |role|
      total += [Completion.where(roll_id: role.id).count, role.minimum].min
    end

    total
  end


  def commit_to_a_role(role_id)
    @roll = Roll.find(role_id)
    @user = current_user
    @activity = @roll.activity
    unless @roll.user.include?(@user) || (@roll.maximum && @roll.user.count >= @roll.maximum)
      @roll.user << @user

      new_comment('!chatlog committed to the role "' + @roll.title + '"', @activity.discussion.id)

      begin
        auto_upvote_post(@activity.post.id, @user.id)
      rescue
      end

      # Notifications
      if total_committed(@roll.activity) == total_minimum(@roll.activity)
        @roll.user.each do |user|
          notification = user.notification.create(:details => "The action \"" + @activity.title + "\" has reached minimum participation and can happen.",
            :activity_id => @activity.id)
          notification.send_email
        end
      end  
      # End notifications
    end
  end

end
