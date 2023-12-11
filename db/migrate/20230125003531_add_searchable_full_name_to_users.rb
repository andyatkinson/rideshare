class AddSearchableFullNameToUsers < ActiveRecord::Migration[7.1]
  def change
    safety_assured do # executing in non-prod
      execute <<-SQL
        ALTER TABLE users
        ADD COLUMN searchable_full_name TSVECTOR GENERATED ALWAYS AS (
          SETWEIGHT(TO_TSVECTOR('english', COALESCE(first_name, '')), 'A') ||
          SETWEIGHT(TO_TSVECTOR('english', COALESCE(last_name,'')), 'B')
        ) STORED;
      SQL
    end
  end
end
