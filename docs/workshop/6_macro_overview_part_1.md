# Macro Query Optimization Part 1

In the last few sections, we learned about "micro" or individual query optimization.

To make broad improvements, we can apply the same concepts across all our queries.
- Tactic #1: Find all the slow queries, and focus on high impact ones
- Tactic #2: For read-only queries, i.e. the `SELECT` queries but not `INSERT`, `UPDATE`, and `DELETE`, distribute them to a second read-only PostgreSQL instance (a.k.a. replica, follower, secondary)

To do that, we will explore:
- The `pg_stat_statements` extension
- Read and Write Splitting with Active Record

Let's improve our DBA skills!

## Section 1: Configure `pg_stat_statements`
While being an extension, it's officially supported by PostgreSQL and distributed with it, but is not enabled by default.

We need to enable it using a superuser, for the `rideshare_development` database, in the `rideshare` schema.

⚠️ This part won't be included in the workshop due to time, or can be a self-study opportunity. Presenter will demo.

```sh
vim "/Users/andy/Library/Application Support/Postgres/var-16/postgresql.conf"

# edit shared_preload_libraries
shared_preload_libraries = 'pg_stat_statements'

# Restart PostgreSQL
pg_ctl restart --pgdata "/Users/andy/Library/Application Support/Postgres/var-16/"

# Connect as superuser, e.g. "postgres"
psql -U postgres -d rideshare_development

# Enable the extension
postgres@[local]:5432 rideshare_development# \dx
                 List of installed extensions
  Name   | Version |   Schema   |         Description
---------+---------+------------+------------------------------
 plpgsql | 1.0     | pg_catalog | PL/pgSQL procedural language

# Loads into current database
CREATE EXTENSION IF NOT EXISTS pg_stat_statements
SCHEMA rideshare;

# Reset (Requires superuser) WARNING: Removes stats data
SET search_path = 'rideshare';
SELECT pg_stat_statements_reset();

\q -- quit psql
```

We can go back to our less-privileged app user `owner`.

Now we're ready to view the PGSS data.

Let's connect in psql and then look for the `rideshare_development` DB:

```sql
SELECT pg_database.oid
FROM pg_database
WHERE pg_database.datname = 'rideshare_development';
   oid
---------
 1462704
```

Filter in `pg_stat_statements` on `dbid` and the `owner` `userid`:

```sql
\x -- vertical presentation

WITH mydb AS (
    SELECT pg_database.oid AS mydbid
    FROM pg_database
    WHERE pg_database.datname = 'rideshare_development'
),
me AS (
    SELECT oid AS myuserid
    FROM pg_roles
    WHERE rolname = 'owner'
)
SELECT * FROM pg_stat_statements
JOIN mydb ON dbid = mydb.mydbid
JOIN me ON userid = me.myuserid;
```

Let's populate some data. Run our original below to do that.

```sql
SELECT * FROM users WHERE first_name = 'Alphonso';
```

Review [`andyatkinson/pg_scripts`](https://github.com/andyatkinson/pg_scripts) for PGSS queries like top 10 worst performers.

```sql
SELECT
    query,
    total_exec_time,
    mean_exec_time AS avg_ms,
    calls,
    rows
FROM
    pg_stat_statements
ORDER BY
    2 DESC
LIMIT 3;
```

Notes:
- Adding `EXPLAIN` or w/ params creates a new query in PGSS
- Re-run the query a few times and analyze the number for calls and rows, watch it grow

We can now identify our slowest queries and begin optimizing them.

## What's Next?
Visit [7 - Macro Query Optimization Part 2](/docs/workshop/7_macro_overview_part_2.md) to continue.
