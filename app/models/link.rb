class Link < ApplicationRecord
  has_one :post, dependent: :destroy
	belongs_to :parent, class_name: 'Goal'
	belongs_to :child, class_name: 'Goal'
	has_and_belongs_to_many :user
end