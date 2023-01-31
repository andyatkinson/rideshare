class AddIndexUsersLastName < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    add_index :users, :last_name, algorithm: :concurrently
  end
end
