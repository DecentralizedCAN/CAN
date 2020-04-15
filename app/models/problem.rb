class Problem < ApplicationRecord
  include Hashid::Rails

	has_and_belongs_to_many :user
	has_many :criterium, dependent: :destroy
	has_many :solution, dependent: :destroy
	has_one :post, dependent: :destroy
  has_one :discussion, dependent: :destroy
  has_many :notification, dependent: :destroy
  
  validates :title, presence: true, length: { minimum: 1, maximum: 2000 }
  validates :description, presence: true, length: { minimum: 1, maximum: 2000 }
  belongs_to :goal, optional: true
  # validates :suggestion_min, presence: true

  encrypts :title
  encrypts :description
  encrypts :suggestion_min, type: :integer
  encrypts :creator

  # Sends new problem email.
  def send_problem_email
    ProblemMailer.new_problem(self).deliver_now
  end
end
