class CreatePhotos < ActiveRecord::Migration[7.1]
  def change
    create_table :photos do |t|
      t.belongs_to :lot, null: false, foreign_key: true
      t.text :image_data

      t.timestamps
    end
  end
end
