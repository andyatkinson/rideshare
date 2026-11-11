# Optional UUID primary key conversion

On the PgDog branch, this generator also emits an ignored migration under
`db/pgdog_migrate`, which clears old positions and converts their `trip_id` to UUID.
Both PgDog environments must be migrated together with primary; the pooler hashes
UUID keys. The standalone UUID branch remains separate.

The branch isolates the code changes; it uses the existing development and test
databases from `config/database.yml` (`rideshare_development` and `rideshare_test`
in the standard setup). No database configuration changes or separate databases
are required. Stop the Rails server and simulator before converting or resetting.
Both workflows delete application data.

The original migrations and committed `db/structure.sql` remain the bigint base.
`lib/generators/uuid_conversion/templates/convert_primary_keys_to_uuid.rb.tt` is
the stable conversion source. Timestamped conversion migrations are generated
locally and ignored by Git.

## Apply UUIDs

With PostgreSQL 18 and the normal app/database setup available, run these in your
usual Rails environment (inside the app container if using Docker):

```sh
git switch explore/pgdog-trip-positions
bin/rails generate uuid_conversion
RAILS_ENV=development bin/rails db:migrate:primary db:migrate:pgdog
RAILS_ENV=development bin/rails db:schema:dump
RAILS_ENV=test bin/rails db:migrate db:schema:dump
bin/rails test
bin/rails test:simulator # optional; generates driving routes first
```

The migration converts the existing databases directly; it does not load a new
schema first. Each migration deletes all rows in the seven application tables in
one transaction, converts their IDs and eight foreign keys to `uuid`, and sets
each primary key default to PostgreSQL's built-in `uuidv7()`. It rebuilds the two
search views, their indexes, and the reservation exclusion constraint using UUID
equality instead of `int4range`. It installs `btree_gist` if needed; the migration
role needs database CREATE privileges for that trusted extension, plus ownership
of the application tables. The normal development migration hook still uses the
`owner` role, and the normal ERD generation setup still applies.

Conversion refuses production, PostgreSQL before 18, or an already-converted
schema. Rails' `schema_migrations.version` and `ar_internal_metadata.key` stay as
strings. Restart Rails after migration.

Rails model generators default to UUID primary keys/references on this branch.
New UUID primary keys use `uuidv7()` unless a migration explicitly provides another
default. Historical bigint migrations keep their original behavior. Fixtures use
deterministic UUIDs for associations; application inserts get version 7 UUIDs.

The converted schema dump stays local. Dump the test schema before parallel tests
so worker databases use UUIDs too; dumps include extension definitions for the
reservation constraint. Do not commit the converted `db/structure.sql`.

## Return to main and bigint keys

Stop Rails and the simulator again. Remove the generated migration while still
on the UUID branch, discard its local schema dump, and switch back:

```sh
rm -f db/migrate/*_convert_primary_keys_to_uuid.rb db/pgdog_migrate/*_convert_pgdog_trip_ids_to_uuid.rb
git restore db/structure.sql db/pgdog_structure.sql
git switch main
RAILS_ENV=development bin/rails db:drop db:create db:schema:load
RAILS_ENV=test bin/rails db:drop db:create db:schema:load
bin/rails test
```

Stop the PgDog-enabled app when returning to main, then start main's normal Docker
app/network configuration. The shards may retain UUID data while unused by main.
Before reapplying this experiment, clear/reload **only** the two configured PgDog
schemas from the committed `db/pgdog_structure.sql`, then apply the generated
conversion again. This deletes shard data too.

These commands rebuild the same configured development and test databases from
main's committed bigint schema, including migration bookkeeping. Use credentials
with permission to drop/create those databases and the normal local setup for
roles/extensions. Restart Rails afterwards. There is no data-preserving rollback;
switching branches alone does not change database types. To try UUIDs again,
switch to this branch and repeat the generation/application steps.

References: [PostgreSQL 18 UUID functions](https://www.postgresql.org/docs/18/functions-uuid.html)
and [Rails UUID primary keys](https://guides.rubyonrails.org/active_record_postgresql.html#uuid-primary-keys).
