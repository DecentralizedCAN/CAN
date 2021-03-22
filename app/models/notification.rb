class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :criterium, optional: true
  belongs_to :activity, optional: true
  belongs_to :problem, optional: true
  belongs_to :discussion, optional: true

  encrypts :details

  def send_email
    NotificationMailer.send_email(self).deliver_now if Setting.find(8).state
  end
end
