class Lot < ApplicationRecord
  has_many :bids
  has_many :photos
end
