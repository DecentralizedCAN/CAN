class Link < ApplicationRecord
	belongs_to :parent, class_name: 'Goal', optional: true
	belongs_to :child, class_name: 'Goal', optional: true
	has_and_belongs_to_many :user
end