class RemoveAuctionDurationFromLots < ActiveRecord::Migration[7.1]
  def change
    remove_column :lots, :auction_duration
  end
end
