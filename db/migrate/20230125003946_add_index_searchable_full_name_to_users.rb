class AddIndexSearchableFullNameToUsers < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!

  def change
    add_index :users, :searchable_full_name,
      using: :gin, # GIN index
      algorithm: :concurrently
  end
end
