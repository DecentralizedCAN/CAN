class Comment < ApplicationRecord
  belongs_to :discussion
  belongs_to :user
	has_many :upvotes, dependent: :destroy

  validates :content, presence: true, length: { minimum: 1, maximum: 1000 }

  encrypts :content
end
