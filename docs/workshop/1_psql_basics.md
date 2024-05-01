# psql basics

psql is the command-line client that comes with PostgreSQL.

We will use it. Running `bin/rails dbconsole` (or `db` for short), it launches psql.

The connection string is supplied from the .env file 

We want the one called `DATABASE_URL`.

```sql
cd rideshare

cat .env | grep DATABASE_URL

bin/rails db
```

We can also connect without `bin/rails dbconsole` and use psql directly.

```sh
export DATABASE_URL=postgres://owner@localhost:5432/rideshare_development

psql $DATABASE_URL
```

## What's Next?
Visit [2 - Shell Scripts](/docs/workshop/2_shell_scripts.md) to continue.
