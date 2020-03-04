class Link < ApplicationRecord
  belongs_to :goal, class_name: 'Goal'
  belongs_to :activities, class_name: 'Activity'
  has_and_belongs_to_many :user
end