class Bidder < ApplicationRecord
  has_many :bids

  def self.create_or_update(from)
    from = from.symbolize_keys
    bidder = find_or_initialize_by(telegram_id: from[:id])
    bidder.attributes = from.slice(:is_bot, :first_name, :last_name, :username)
    bidder.save
  end
end
