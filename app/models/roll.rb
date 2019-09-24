class Roll < ApplicationRecord
  has_and_belongs_to_many :user
  belongs_to :activity, optional: true
  belongs_to :solution, optional: true

  # validates :minimum, presence: true
  # validates :maximum, presence: true
end
