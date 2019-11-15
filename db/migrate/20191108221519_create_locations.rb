class CreateLocations < ActiveRecord::Migration[6.0]
  def change
    # index: Rails adds PK index
    create_table :locations do |t|
      t.string :address, null: false, index: true # store the string form of the address [See below], index: yes, search
      t.decimal :latitude, precision: 15, scale: 10, null: false, index: true # index: yes, search
      t.decimal :longitude, precision: 15, scale: 10, null: false, index: true # index: yes, search

      t.timestamps # Nullability: Rails adds null: false
    end
  end
end

# NOTE: We could also make separate fields for house number, street address, city, state etc.
# This is a simplified version
#
# NOTE: We expect to search on address text, or on latitude and longitude
