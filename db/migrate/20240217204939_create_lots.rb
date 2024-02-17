class CreateLots < ActiveRecord::Migration[7.1]
  def change
    create_table :lots do |t|
      t.string :name
      t.text :description
      t.integer :start_price
      t.integer :auction_duration

      t.timestamps
    end
  end
end
