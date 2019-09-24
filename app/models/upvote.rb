class Upvote < ApplicationRecord
  belongs_to :post, optional: true
  belongs_to :comment, optional: true
  belongs_to :user
end
