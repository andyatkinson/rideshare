class AddUniqueIndexFastSearchResults < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!

  def change
    add_index :fast_search_results, :driver_id,
      unique: true,
      algorithm: :concurrently
  end
end
