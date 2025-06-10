# SQL Migrations
Apply safe, additive DDLs as SQL, backfill a Rails migration for consistency

## SQL Migrations Release Process
1. Requirements: give SQL migration a name, e.g. `01_create_index.sql`
1. Run [Squawk](https://squawkhq.com) on the file. Squawk finds a missing `CONCURRENTLY`, checking against a rule that requires it for creating indexes.
1. Modify the file to add `CONCURRENTLY`. Run squawk again and verify no issues are reported.
1. Apply this migration after review, lower environments etc. Make it idempotent (`IF NOT EXISTS`)
1. Once applied, you're ready to feed the SQL into a Rails migration, for consistency with your traditional Rails migration process.

Example of Squawk rule violation detection:
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
- Can be used via a Pre-commit hook

## Rails Migration Generator
Using the SQL DDL, pipe this into a generated Rails migration.

The generation migration file should be equivalent to what `rails g migration` would generate, although it's using different code.

Currently this is a proof of concept only supporting the SQL files in here.

This workflow could be to iterate on the SQL DDL, get the SQL reviewed, and then generate the
migration file from there as part of the same PR. Place the file into `db/migrate` directory and running migrations.

## Using rails_migration_generator
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
```
```rb
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
