class Bid < ApplicationRecord
  belongs_to :bidder
  belongs_to :lot
end
