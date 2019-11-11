class CreateLocations < ActiveRecord::Migration[6.0]
  def change
    create_table :locations do |t|
      t.string :address, null: false # store the string form of the address [See below]
      t.decimal :latitude, precision: 15, scale: 10, null: false
      t.decimal :longitude, precision: 15, scale: 10, null: false

      t.timestamps
    end
  end
end

# NOTE: We could also make separate fields for house number, street address, city, state etc.
# This is a simplified version
