class CreateBidders < ActiveRecord::Migration[7.1]
  def change
    create_table :bidders do |t|
      t.bigint :telegram_id
      t.string :first_name
      t.string :last_name
      t.string :username
      t.boolean :is_bot

      t.timestamps
    end
  end
end
