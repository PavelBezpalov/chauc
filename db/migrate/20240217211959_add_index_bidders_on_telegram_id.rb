class AddIndexBiddersOnTelegramId < ActiveRecord::Migration[7.1]
  def change
    add_index :bidders, :telegram_id
  end
end
