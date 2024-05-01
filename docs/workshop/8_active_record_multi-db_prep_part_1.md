# Active Record Multiple Databases Part 1

Now we have `db01` and `db02` running. Let's create the Rideshare DB, and configure it.

We'll work with `db01`, which is mapped to local port 54321.

We'll set `DB_URL` and `RIDESHARE_DB_PASSWORD`.

## Section 1: Primary and Secondary DB config
We use `postgres/postgres`, and connect to `postgres` on port 54321 (db01).

```sh
export DB_URL="postgres://postgres:postgres@localhost:54321/postgres"

cd rideshare

# Run setup, will complain if RIDESHARE_DB_PASSWORD is not set
sh db/setup.sh 2>&1 | tee -a db01_output.log

# Check for any errors:
vim db01_output.log
```

Now let's connect as the owner role using a single-DB config:
```sh
export DATABASE_URL="postgres://owner:@localhost:54321/rideshare_development"
```

Verify port 54321 is listed. There should be no tables here: `\dt`. We should see the `rideshare` schema: `\dn`.

Now we're ready to run migrations on db01:
```sh
bin/rails db:migrate
```

Let's see if the tables were replicated!

We're gradually moving to a multi-DB setup, but still using a single-DB setup.

To prepare, let's configure new env vars. These are in the `.env` for Rideshare.

```sh
export DATABASE_URL_PRIMARY="postgres://owner:@localhost:54321/rideshare_development"

export DATABASE_URL_REPLICA="postgres://owner:@localhost:54322/rideshare_development"
```

Let's connect to the replica and check for tables.

If you see tables on the replica, it's because they were created via replication not from running migrations there. Migrations only run on the primary instance.

```sh
psql $DATABASE_URL_REPLICA
```

Note:
- We automatically got the `owner` role
- We're connected to port 54322 (one greater), which is the locally mapped port to db02
- We see the tables in the `rideshare` schema

Cool!

If we check row counts on both, all the tables are empty.

Let's populate data so that we work on queries.

Note that this still uses `DATABASE_URL`, but that now points at db01.

```sh
bin/rails data_generators:generate_all
```

Connect again to db02 and verify the row counts are the same. There should be data on db02! This data came from db01 via replication.

With data on both instances, we're ready to move to Active Record configuration.

## Section 2: Database config multiple databases
In this section, we're going to move to a multi-DB configuration.

Copy and paste the contents from the file below, replacing the current contents of `db/config.yml`:

```sh
config/database-multiple.sample.yml
```

Replace the contents of `config/database.yml` with the file contents above.

Take note of:
- These reference the env vars you set earlier: `DATABASE_URL_PRIMARY` and `DATABASE_URL_REPLICA`
- "Named" configurations for both: `rideshare` (db01) and `rideshare_replica` (db02)
- Database names are `rideshare_development` for both instances
- db02 has `replica: true` config
- `schema_search_path` is set to `rideshare` for both
- `database_tasks: false` for db02, we don't want to run migrations there

Now we can try these out!

Now when running migrations, they should only run on db01 primary instance:

```sh
bin/rails db:migrate
```

Test the new configurations, first using `db`:

```sh
bin/rails db --database rideshare
bin/rails db --database rideshare_replica
```

This concludes the configuration portion of Active Record Multiple Databases.

In the last section, we'll wrap things up with application level configuration and usage:

See you there!

## Appendix: Troubleshooting
Tip: Log all statements if desired. Run this on the db01 or db02 instance.

```sql
ALTER DATABASE rideshare_development SET log_statement = 'all';
```

## What's Next?
Visit [9 - Active Record Multi-DB Part 2](/docs/workshop/9_active_record_multi-db_roles.md) to continue.
