class Discussion < ApplicationRecord
  include Hashid::Rails

  has_one :post, dependent: :destroy
  belongs_to :problem, optional: true
  belongs_to :activity, optional: true
  belongs_to :solution, optional: true
  has_many :comment, dependent: :destroy
  has_many :notification, dependent: :destroy
  
  validates :title, presence: true, length: { minimum: 1, maximum: 2000 }

  encrypts :title
  encrypts :content
  encrypts :creator

end
