class AddPositionToLocations < ActiveRecord::Migration[7.1]
  def change
    add_column :locations, :position, :point, null: false
  end
end
