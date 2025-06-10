# SQL Migrations
Linter for Postgres migrations
<https://squawkhq.com>

## Squawk
1. Requirements: give it a name
1. Squawk finds missing "concurrently"
1. Bring your own idempotency, add "if not exists"
1. Use same index name

```sh
squawk db/sql_migrations/01_create_index.sql
warning[require-concurrent-index-creation]: During normal index creation, table updates are blocked, but reads are still allowed.
 --> db/sql_migrations/01_create_index.sql:1:1
  |
1 | create index on trips (id, created_at);
  | --------------------------------------
  |
  = help: Use `CONCURRENTLY` to avoid blocking writes.

Find detailed examples and solutions for each rule at https://squawkhq.com/docs/rules
Found 1 issue in 1 file (checked 1 source file)
```

## Config
- Pre-commit hook

## Rails Migration Generator
You can use the SQL and pipe it into a generated Rails migration file.

Currently this is a narrow proof of concept only supporting the SQL files in here.

The workflow would be to iterate on the SQL, get the SQL reviewed, and then generate the
migration file from that, placing the file into `db/migrate` directory and running migrations.

Run without an argument, get a Usage statement:
```sh
./db/sql_migrations/rails_migration_generator.rb
Usage: ./db/sql_migrations/rails_migration_generator.rb <file_path>
```

Run it with an argument for the path to a SQL file:
```sh
./db/sql_migrations/rails_migration_generator.rb db/sql_migrations/02_create_index.sql
```

A Rails migration file will be generated with the SQL filled in:
```sh
Wrote file: /Users/andy/Projects/rideshare/db/migrate/20250610033520_create_index_idx_trips_id_created_at.rb
class CreateIndexIdxTripsIdCreatedAt < ActiveRecord::Migration[7.2]
  disable_ddl_transaction!

  def change
    safety_assured do
      execute <<-SQL
        create index concurrently if not exists idx_trips_id_created_at
on trips (id, created_at);

      SQL
    end
  end
end
```

Finally, run:
```sh
rails db:migrate
```
