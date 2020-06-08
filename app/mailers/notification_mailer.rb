class NotificationMailer < ApplicationMailer

  def send_email(notification)
    begin
      @notification = notification

    	ENV['GROUP_NAME'] != nil ? group_name = ENV['GROUP_NAME'] : group_name = "Decentralized CAN"

      if Setting.find(8).state && @notification.user.email_notifications && @notification.user.email && @notification.user.email.length > 0
  	    mail(
  	      to: @notification.user.email, 
  	      subject: "Notification from #{group_name}"
  	    )
      end
    rescue
    end
  end

end