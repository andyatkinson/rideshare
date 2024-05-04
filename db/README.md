# Database Setup

## PostgreSQL Version
Make sure you're running PostgreSQL 16 or newer.

We recommend Postgres.app, however Homebrew is popular. Make sure you've used this formula:

<https://formulae.brew.sh/formula/postgresql@16>

## Fake data
Fake data generated from Ruby, using the Faker gem, may be generated using the following commands.

This will generate around 20K user records which is useful for most tests. More data will be needed for performance testing.
```sh
bin/rails data_generators:generate_all

bin/rails data_generators:drivers

bin/rails data_generators:trips_and_requests
```

For more data, see SQL scripts in: [db/scripts/README.md](db/scripts/README.md)

```sh
sh db/scripts/bulk_load.sh
sh db/scripts/bulk_load_extended.sh
```

## Data Loads Video Demo
To see a demonstration of both methods:


<details>
<summary>🎥 Rideshare - Loading data using a Rake task and Shell Script</summary>
<div>
<div>
  <a href="https://www.loom.com/share/6a1419efae7b4c3aac51e7d95726baf0">
    <img style="max-width:300px;" src="https://cdn.loom.com/sessions/thumbnails/6a1419efae7b4c3aac51e7d95726baf0-1714505177620-with-play.gif">
  </a>
</div>
</details>

## Security Goals
The *Principle of least privilege*[^prin] is followed by creating explicit `GRANT` commands for the `owner`, `app`, and `app_readonly` users.

The configuration is based on *My GOTO Postgres Configuration for Web Services*.[^gotocon] One of the other goals besides minimizing access, is to prevent accidental table drops.

Since the schema `rideshare` is created, the `public` schema is not needed and is removed.

For `psql` commands, use a `DATABASE_URL` environment variable that's set in your terminal.

The connection string connects to the Rideshare database, using the `owner` user.

The value of `DATABASE_URL` is a connection string, with the format `protocol://role:password@host:port/databasename`. An example is checked in to `.env`.

[^prin]: <https://en.wikipedia.org/wiki/Principle_of_least_privilege>
[^gotocon]: <https://tightlycoupled.io/my-goto-postgres-configuration-for-web-services/>

## Configuring Host Based Authentication (HBA)
You may want to configure *Host Based Authentication* (`HBA`)[^pghba].

Do that by editing your `pg_hba.conf` file. Changes in `pg_hba.conf` can be applied by *reloading* PostgreSQL.


## Reloading your PostgreSQL configuration
Finding config file: `psql -U postgres -c 'SHOW config_file'`

To reload your configuration, run: `pg_ctl reload` in your terminal. If you run into the following message, read on for more information.

```sh
pg_ctl: no database directory specified and environment variable PGDATA unset
Try "pg_ctl --help" for more information.
```

This command assumes the `PGDATA` environment variable is set, and points to the data directory for your PostgreSQL installation.

Run `echo $PGDATA` to confirm it's set and see the value. How do you set the value if it's empty? Run the following commands in your terminal:

```sh
# Look up the value
psql -U postgres -c 'SHOW data_directory'

# Assign the value to PGDATA
export PGDATA="$(psql -U postgres \
  -c 'SHOW data_directory' \
  --tuples-only | sed 's/^[ \t]*//')"
echo "Set PGDATA: $PGDATA"
```

When you've confirmed `PGDATA` is set, run `pg_ctl reload` again. The command should reload the PostgreSQL config, referencing your data directory via `PGDATA`.

[^pghba]: <https://www.postgresql.org/docs/current/auth-pg-hba-conf.html>

## Docker
Reset everything:

```sh
sh reset_docker_instances.sh
```

Tear down docker:

```sh
sh teardown_docker.sh
```

## Slow Clients
Replace `config/database.yml` (or just the "slow clients" section)

```
cp config/database-slow-clients.sample.yml config/database.yml
```

With that in place, create a model:

```ruby
class SlowClientModel < ApplicationRecord
  self.establish_connection :slow_clients
end
```

Run query code that takes 5 seconds, and verify that it's canceled in the normal configuration.

The "slow client" configuration allows it since it has a higher statement timeout configured.

```rb
Trip.connection.execute("SELECT PG_SLEEP(5)")
SlowClientModel.connection.execute("SELECT PG_SLEEP(5)").first
```

## pg_cron
[Scheduling maintenance with pg_cron](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/PostgreSQL_pg_cron.html)

- The extension is created using the postgres superuser
- The superuser grants usage privileges to the owner role, for the cron schema
- Now the owner user can schedule their own jobs, for objects they own

```sql
psql -U postgres -d rideshare_development;

CREATE EXTENSION pg_cron;

GRANT USAGE ON SCHEMA cron TO owner;
```

Run a job:
```sql
SELECT cron.schedule(
  'rideshare trips manual vacuum',
  '10 * * * *',
  'VACUUM (ANALYZE) rideshare.trips'
);
```

View the jobs:
```sql
SELECT * FROM cron.job;
```

View job runs:
```sql
SELECT * FROM cron.job_run_details;
```

![Screenshot of PgHero Scheduled Jobs](https://i.imgur.com/rxRf7Qn.png)

## active-record-doctor
Run the tool from your terminal:

```sh
bundle exec rake active_record_doctor:
```

## database_consistency
Run the tool from your terminal:

```sh
database_consistency
```

## rails-pg-extras
Specify a custom schema for table_cache_hit

```sh
bin/rails runner \
  'RailsPgExtras.table_cache_hit(args: { schema: "rideshare" })'
```

Or for version >= 5.3.1, set a schema using an environment variable:

```sh
export PG_EXTRAS_SCHEMA=rideshare
```

For example, we can search for unused indexes, and indexes within
the expected schema (`rideshare`) are examined

```sh
bin/rails pg_extras:unused_indexes
```
```sh
bin/rails pg_extras:diagnose
```

## rails_best_practices
```sh
bin/rails_best_practices .
```


## PgBouncer Prepared Statements
- Run `brew services` and confirm PgBouncer is running on port 6432
- Set `DATABASE_URL` to be port 6432
- Disable Query Logs in `config/application.rb` (currently incompatible)
- Restart PgBouncer to clear out the prepared statements


Run the following script to observe how prepared statements are populated:

```sh
sh pgbouncer_prepared_statements_check.sh
```

## pgbench
We can use pgbench and some pre-made SQL queries forming a transaction,
to measure the transactions per second (TPS) that the server is capable of.

```sh
sh db/scripts/benchmark.sh
```
