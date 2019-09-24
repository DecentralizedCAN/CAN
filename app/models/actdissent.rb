class Actdissent < ApplicationRecord
  belongs_to :user
  belongs_to :activity
end