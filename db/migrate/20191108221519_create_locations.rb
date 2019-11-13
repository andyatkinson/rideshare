class CreateLocations < ActiveRecord::Migration[6.0]
  def change
    # index: Rails adds PK index
    create_table :locations do |t|
      t.string :address, null: false # store the string form of the address [See below], index: no
      t.decimal :latitude, precision: 15, scale: 10, null: false # index: no
      t.decimal :longitude, precision: 15, scale: 10, null: false # index: no

      t.timestamps # Nullability: Rails adds null: false
    end
  end
end

# NOTE: We could also make separate fields for house number, street address, city, state etc.
# This is a simplified version
