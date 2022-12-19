class AddUniqueAddressToLocations < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!

  def change
    remove_index :locations, :address
    add_index :locations, :address, unique: true, algorithm: :concurrently
  end
end
