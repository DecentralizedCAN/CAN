class Group < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_and_belongs_to_many :user

  validates :name, presence: true, length: { minimum: 1, maximum: 20 }
  validates :description, required: false
end
