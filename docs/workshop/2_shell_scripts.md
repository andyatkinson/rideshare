# Shell Script Basics

Let's load more data. You may remove all data if needed.

⚠️ (Optional) WARNING: Run this to remove all data and start over.
```sh
bin/rails db:reset
```

If you've migrated the database and it's empty, let's first
load some sample data from Rake scripts you're familiar with.

```sh
cd rideshare
bin/rails data_generators:generate_all
```

Bulk load via SQL commands running in psql

```sh
sh db/scripts/bulk_load.sh
sh db/scripts/bulk_load_extended.sh
```

## What's Next?
Visit [3 - Query Planning](/docs/workshop/3_query_planning.md) to continue.
