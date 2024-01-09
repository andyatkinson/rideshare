class DropColumnSearchableFullName < ActiveRecord::Migration[7.1]
  def change
    # Add this migration back in order to use:
    # `searchable_full_name` in the User model:
    # - concatenates first_name and last_name
    # - Configures it with pg_search
    # - Index added for this column
    # db/migrate/20230125003531_add_searchable_full_name_to_users.rb

    safety_assured do
      remove_column :users, :searchable_full_name
    end
  end
end
