# Shell Script Basics
Let's load more data. You may remove all data if needed.

⚠️ (Optional) WARNING: Run this to remove all data and start over.
```sh
rails db:reset
```

If you've migrated the database and it's empty, let's first
load some sample data from Rake scripts you're familiar with.

NOTE: only local
```sh
cd rideshare
rails data_generators:generate_all
```

For Docker:
```sh
docker compose exec -it app rails data_generators:generate_all
```

Bulk load via SQL (which load data via psql)

NOTE: expects `DATABASE_URL` to be set/reachable

"Bulk load" inserts 10000000 (10 million) users records, "bulk load extended" creates 1 million trip requests
```sh
sh db/scripts/bulk_load.sh
sh db/scripts/bulk_load_extended.sh
```

With millions of records loaded, we will begin to "feel" slower queries now. In fact on modern machines with modern SSDs, even 10 million records can be scanned quickly, so we may need to make multiple passes and load even more data.

The goal is to get a basic simulation of a production environment that can have 10s or 100s of millions, or billions of records.

## What's Next?
Visit [3 - Query Planning](/docs/workshop/03_query_planning.md) to continue.
