# psql basics
psql is the command-line client that comes with PostgreSQL.

We will use it. In Rails configured with Postgres, `rails dbconsole` (or `db` for short) runs psql.

The connection string is supplied from the .env file

Let's open up a bash prompt: `docker compose exec -it app bash`

We want the one called `DATABASE_URL`.
```sql
cat .env | grep DATABASE_URL

bin/rails db
```

We can also connect without `bin/rails dbconsole` and use psql directly.

NOTE: This only works when installed locally, not via Docker.
```sh
export DATABASE_URL=postgres://owner@localhost:5432/rideshare_development
psql $DATABASE_URL
```

For Docker:
```sh
export DATABASE_URL=postgres://owner@db:5432/rideshare_development
psql $DATABASE_URL
```

## What's Next?
Visit [2 - Shell Scripts](/docs/workshop/02_shell_scripts.md) to continue.
