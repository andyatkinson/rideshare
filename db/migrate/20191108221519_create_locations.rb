class CreateLocations < ActiveRecord::Migration[6.0]
  def change
    create_table :locations do |t|
      t.string :address
      t.decimal :latitude, precision: 15, scale: 10, null: false
      t.decimal :longitude, precision: 15, scale: 10, null: false

      t.timestamps
    end
  end
end
