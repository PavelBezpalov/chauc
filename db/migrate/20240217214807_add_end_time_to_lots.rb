class AddEndTimeToLots < ActiveRecord::Migration[7.1]
  def change
    add_column :lots, :end_time, :datetime
  end
end
