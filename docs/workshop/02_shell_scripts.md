# Shell Script Basics
Let's load more data. You may remove all data if needed.

⚠️ (Optional) WARNING: Run this to remove all data and start over.
```sh
bin/rails db:reset
```

If you've migrated the database and it's empty, let's first
load some sample data from Rake scripts you're familiar with.

For Docker:
```sh
docker compose exec -it app rails data_generators:generate_all
```

For local install:
```sh
bin/rails data_generators:generate_all
```

Bulk load via SQL (which load data via psql)

NOTE: expects `DATABASE_URL` to be set/reachable

"Bulk load" inserts 10,000,000 (10 million) users records, "bulk load extended" creates 1 million trip requests. This takes several minutes to run and uses more space.

The `statement_timeout` is raised to `30min` to make sure this runs in time.
```sh
sh db/scripts/bulk_load.sh
sh db/scripts/bulk_load_extended.sh
```

With millions of records loaded, we will begin to "feel" slower queries now. In fact on modern machines with modern SSDs, even working with 10 million records can be fast, so we may need to make multiple passes and load even more data.

The goal here is to simulate a closer-to-production environment with millions or billions of records.

## What's Next?
Visit [3 - Query Planning](/docs/workshop/03_query_planning.md) to continue.
