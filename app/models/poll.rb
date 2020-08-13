class Poll < ApplicationRecord
  belongs_to :solution
  belongs_to :user
  belongs_to :criterium
end
