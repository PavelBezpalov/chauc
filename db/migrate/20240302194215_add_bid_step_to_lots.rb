class AddBidStepToLots < ActiveRecord::Migration[7.1]
  def change
    add_column :lots, :bid_step, :integer, null: false, default: 50
  end
end
