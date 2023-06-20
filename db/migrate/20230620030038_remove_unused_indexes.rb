class RemoveUnusedIndexes < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!

  def change
    remove_index :locations, :latitude, name: "index_locations_on_latitude",
      algorithm: :concurrently

    remove_index :locations, :longitude, name: "index_locations_on_longitude",
      algorithm: :concurrently
  end
end
