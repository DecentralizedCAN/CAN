class Goal < ApplicationRecord
  include Hashid::Rails

	has_many :actions
	has_many :brainstorms
	has_many :discussions
	has_and_belongs_to_many :users

  encrypts :title
  blind_index :title

  validates :title, presence: true, uniqueness: { case_sensitive: true }, length: { minimum: 6, maximum: 2000 }

end