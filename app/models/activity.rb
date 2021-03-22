class Activity < ApplicationRecord
  include Hashid::Rails

	has_and_belongs_to_many :user
	has_many :roll, dependent: :destroy
	has_many :actdissent
  has_one :post, dependent: :destroy
  has_one :discussion, dependent: :destroy
  belongs_to :solution, optional: true
  belongs_to :goal, optional: true
  has_many :notification, dependent: :destroy

  validates :title, presence: true, length: { minimum: 1, maximum: 200 }
  validates :description, length: { maximum: 2000 }
  # validates :expiration, presence: true
  # validates :deadline, presence: true

  encrypts :title
  encrypts :description
  encrypts :activation
  encrypts :creator
  encrypts :deadline, type: :integer
  blind_index :deadline
  encrypts :expiration, type: :integer
  blind_index :expiration

  # Sends new activity email.
  def send_activity_email
    ActivityMailer.new_activity(self).deliver_now
  end

  # Sends activation notice email.
  def send_activated_email
    ActivityMailer.activated(self).deliver_now
  end
end
