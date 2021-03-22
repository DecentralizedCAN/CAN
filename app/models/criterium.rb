class Criterium < ApplicationRecord
  include Hashid::Rails

  belongs_to :problem
  has_and_belongs_to_many :user
  has_many :cridissent, dependent: :destroy
  has_many :crialt, dependent: :destroy
  has_many :poll, dependent: :destroy
  has_many :notification, dependent: :destroy
  
  validates :title, presence: true, length: { minimum: 1, maximum: 500 }

  encrypts :title
  encrypts :alternatives
  encrypts :creator

end
