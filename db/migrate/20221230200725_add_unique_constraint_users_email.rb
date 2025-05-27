class AddUniqueConstraintUsersEmail < ActiveRecord::Migration[7.1]
  def change
    # Potentially unsafe in production, but ok
    # to add here (only used locally)

    # remove former index that does not support
    # unique constraint
    remove_index(:users, :email) if index_exists?(:users, :email)

    safety_assured do
      add_index :users, [:email], unique: true
    end
  end
end
