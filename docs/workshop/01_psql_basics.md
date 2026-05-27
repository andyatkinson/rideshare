# psql basics
psql is the command-line client that comes with PostgreSQL.

We will use it. Running `rails dbconsole` (or `db` for short), it launches psql.

The connection string is supplied from the .env file

We want the one called `DATABASE_URL`.

```sql
cd rideshare

cat .env | grep DATABASE_URL

rails db
```

We can also connect without `rails dbconsole` and use psql directly.

NOTE: This only works when installed locally, not via Docker.
```sh
export DATABASE_URL=postgres://owner@localhost:5432/rideshare_development
psql $DATABASE_URL
```

## What's Next?
Visit [2 - Shell Scripts](/docs/workshop/02_shell_scripts.md) to continue.
