class CreateBids < ActiveRecord::Migration[7.1]
  def change
    create_table :bids do |t|
      t.belongs_to :bidder, null: false, foreign_key: true
      t.belongs_to :lot, null: false, foreign_key: true
      t.integer :amount

      t.timestamps
    end
  end
end
