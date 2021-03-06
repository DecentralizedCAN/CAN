class ActivityMailer < ApplicationMailer
  
  def new_activity(activity)
    if Setting.find(8).state
      @activity = activity
      
      users = User.all

      mail(
        bcc: users.map(&:email).uniq, 
        subject: "New collective action"
      )
    end
  end

  def activated(activity)
    if Setting.find(8).state
      @activity = activity
      
      users = @activity.roll.first.user

      mail(
        bcc: users.map(&:email).uniq, 
        subject: "Collective action met necessary participation"
      )
    end
  end

end