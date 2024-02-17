class AddStartTimeToLots < ActiveRecord::Migration[7.1]
  def change
    add_column :lots, :start_time, :datetime
  end
end
