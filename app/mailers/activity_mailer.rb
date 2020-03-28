class ActivityMailer < ApplicationMailer
  
  def new_activity(activity)
    if Setting.find(8).state
      @activity = activity
      
      users = User.all

      mail(
        bcc: users.map(&:email).uniq, 
        subject: "New action"
      )
    end
  end

  def activated(activity)
    if Setting.find(8).state
      @activity = activity
      
      users = @activity.roll.first.user

      mail(
        bcc: users.map(&:email).uniq, 
        subject: "Action met necessary participation"
      )
    end
  end

end