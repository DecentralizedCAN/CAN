class Post < ApplicationRecord
	belongs_to :problem, optional: true
	belongs_to :activity, optional: true
	belongs_to :discussion, optional: true
	has_many :upvotes, dependent: :destroy
end