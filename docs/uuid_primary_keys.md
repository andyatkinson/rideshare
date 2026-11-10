# Optional UUID primary key conversion

This branch keeps the original migrations and `db/structure.sql` as the bigint
base. `lib/generators/uuid_conversion/templates/convert_primary_keys_to_uuid.rb.tt`
is the stable conversion source. Generate a timestamped migration only when you
want to apply it; generated conversion migrations are ignored by Git.

Use a separate checkout/worktree and database for this experiment. Copy
`config/database-uuid.sample.yml` to `config/database.yml` in that checkout. It
uses `rideshare_uuid_development` and `rideshare_uuid_test` on localhost. Override
`UUID_DEVELOPMENT_DATABASE_URL` and `UUID_TEST_DATABASE_URL` as needed (use host
`db` inside Docker). Do not point this experiment at the main checkout's database.
The sample connects as `postgres`; `MIGRATION_ROLE=postgres` overrides the app's
normal development migration role of `owner`. `SKIP_ERD=1` skips optional diagram
generation when Graphviz is unavailable. Use your own migration role if
you change these URLs. Stop any simulator/server using the experimental
databases before conversion, then restart Rails after migration.

With PostgreSQL 18 and dependencies available:

```sh
bin/rails db:create db:schema:load
bin/rails generate uuid_conversion
MIGRATION_ROLE=postgres SKIP_ERD=1 bin/rails db:migrate
RAILS_ENV=test bin/rails db:schema:load db:migrate db:schema:dump
ruby bin/generate_simulator_routes # one-time simulator prerequisite
bin/rails test
```

The migration **deletes all rows in the seven application tables** in one
transaction, converts their IDs and eight foreign keys to `uuid`, and sets each
primary key default to PostgreSQL's built-in `uuidv7()`. It rebuilds the two search
views, their indexes, and the reservation exclusion constraint using UUID equality
instead of `int4range`. It installs `btree_gist` if needed (requires extension
creation privileges). It refuses production, PostgreSQL before 18, or a schema
that has already been converted. Rails' `schema_migrations.version` and
`ar_internal_metadata.key` stay as strings.

Rails model generators default to UUID primary keys/references on this branch.
New UUID primary keys use `uuidv7()` unless a migration explicitly provides another
default. Historical bigint migrations keep their original behavior. Rails fixtures
use deterministic UUIDs for associations; newly inserted application rows receive
version 7 UUIDs from PostgreSQL.

The local schema dump changes after conversion and must match the test database
before parallel tests run. Dumps include extension definitions so parallel test
databases can load the UUID reservation constraint. Keep the converted dump local;
restore `db/structure.sql` from Git before committing. A fresh checkout still loads
the bigint base until you generate/apply the conversion.

There is no data-preserving rollback. To start over, drop **only the experimental
databases**, restore the committed bigint dump, recreate/load them, and reapply the
generated migration. Remove the ignored generated migration when returning to a
checkout/database that should stay bigint. Migration and schema changes live in
this branch; changing branches alone does not change a database.

References: [PostgreSQL 18 UUID functions](https://www.postgresql.org/docs/18/functions-uuid.html)
and [Rails UUID primary keys](https://guides.rubyonrails.org/active_record_postgresql.html#uuid-primary-keys).
