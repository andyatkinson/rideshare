class DropLocationsLatitudeLongitude < ActiveRecord::Migration[7.1]
  def change
    # migrated these to a single point type column=>"position"
    safety_assured do
      remove_column :locations, :latitude
      remove_column :locations, :longitude
    end
  end
end
