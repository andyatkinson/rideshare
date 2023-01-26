class AddSearchableFullNameToUsers < ActiveRecord::Migration[7.1]
  def change
    safety_assured do # executing in non-prod
      execute <<-SQL
        ALTER TABLE users
        ADD COLUMN searchable_full_name tsvector GENERATED ALWAYS AS (
          setweight(to_tsvector('english', coalesce(first_name, '')), 'A') ||
          setweight(to_tsvector('english', coalesce(last_name,'')), 'B')
        ) STORED;
      SQL
    end
  end
end
