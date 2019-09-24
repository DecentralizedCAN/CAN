class ActivityMailer < ApplicationMailer
  
  def new_activity(activity)
    @activity = activity
    
    users = User.all

    mail(
      bcc: users.map(&:email).uniq, 
      subject: "New collective action"
    )
  end

  def activated(activity)
    @activity = activity
    
    users = @activity.roll.first.user

    mail(
      bcc: users.map(&:email).uniq, 
      subject: "Collective action met necessary participation"
    )
  end

end