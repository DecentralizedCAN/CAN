class Cridissent < ApplicationRecord
  belongs_to :user
  belongs_to :criterium

  encrypts :title
end
