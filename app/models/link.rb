class Link < ApplicationRecord
	belongs_to :parent, class_name: 'Goal'
	belongs_to :child, class_name: 'Goal'
  belongs_to :goal, optional: true
  belongs_to :activity, optional: true
	has_and_belongs_to_many :user
end