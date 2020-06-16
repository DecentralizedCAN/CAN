class Solution < ApplicationRecord
  include Hashid::Rails

  belongs_to :problem
  has_and_belongs_to_many :user
  has_many :poll, dependent: :destroy
  has_many :roll, dependent: :destroy
  has_one :activity
  has_one :discussion, dependent: :destroy

  validates :title, presence: true, length: { minimum: 1, maximum: 2000 }
  validates :description, length: { maximum: 2000 }

  encrypts :title
  encrypts :description
  encrypts :creator

  # Sends new activity email.
  def send_solution_email
    SolutionMailer.new_solution(self).deliver_now
  end
end
