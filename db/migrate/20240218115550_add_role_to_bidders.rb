class AddRoleToBidders < ActiveRecord::Migration[7.1]
  def change
    add_column :bidders, :role, :string, null: false, default: 'user'
  end
end
