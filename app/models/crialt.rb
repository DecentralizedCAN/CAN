class Crialt < ApplicationRecord
  belongs_to :criterium

  encrypts :alternative
end
