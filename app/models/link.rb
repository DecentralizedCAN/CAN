class Link < ApplicationRecord
	belongs_to :parent, class_name: 'Goal'
	belongs_to :child, class_name: 'Goal'
  validates :goal, absence: true
  validates :activities, absence: true
	has_and_belongs_to_many :user
end