# Macro Query Optimization Part 1
In the last few sections, we learned about "micro" optimization, individual query optimization.

To make broad improvements, we can apply the same concepts across all our queries, but we'll need to focus our efforts as we've got 1000s of queries.
- Tactic #1: Find all the slow queries, and focus on high impact ones
- Tactic #2: For read-only queries, i.e. the `SELECT` queries but not `INSERT`, `UPDATE`, and `DELETE`, distribute them to a second read-only PostgreSQL instance (a.k.a. replica, follower, secondary) to add headroom on our primary instance, given we can tolerate replication delay

How do we find slow queries? To do that, we will dig into the internal query statistics tracking mechanism in Postgres: `pg_stat_statements`:
- We will use the `pg_stat_statements` extension
- Read and Write Splitting with Active Record

<details>
<summary>🎥 Configuring and using pg_stat_statements data, creating generic query exec plans</summary>
<div>
  <a href="https://www.loom.com/share/25a2903db92c48c5ad42bc1c49d4a8ee">
    <img style="max-width:300px;" src="https://cdn.loom.com/sessions/thumbnails/25a2903db92c48c5ad42bc1c49d4a8ee-1715978361702-with-play.gif">
  </a>
</div>
</details>

## Section 1: Configure `pg_stat_statements`
While being an extension, it's officially supported by PostgreSQL and distributed with it, but is not enabled by default.

We need to enable it using a superuser, for the `rideshare_development` database, in the `rideshare` schema.

⚠️ This part won't be included in the workshop due to time, or can be a self-study opportunity. Presenter will demo.

NOTE: this is for the original RailsConf 2024 version, and for host OS installed Postgres 16. We'll configure the Postgres 18 Docker version for 2026 to have pgss ready to go.
```sh
vim "/Users/andy/Library/Application Support/Postgres/var-16/postgresql.conf"

# edit shared_preload_libraries
shared_preload_libraries = 'pg_stat_statements'

# Restart PostgreSQL
pg_ctl restart --pgdata "/Users/andy/Library/Application Support/Postgres/var-16/"

# Connect as superuser, e.g. "postgres"
psql -U postgres -d rideshare_development

# Enable the extension (run `CREATE EXTENSION`)
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

## For Docker
```sh
docker ps # find the postgres container

# Connect as the postgres superuser, to the rideshare_development database
docker container exec -it c16f2850a281 psql -U postgres -d rideshare_development

# Create PGSS inside the rideshare schema from psql:
CREATE EXTENSION IF NOT EXISTS pg_stat_statements SCHEMA rideshare;
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

## Improve psql formatting
Run these in psql:
```sh
\x off
\a
\t
\pset pager off
\f ' | '
\pset linestyle unicode
\pset recordsep '\n'
```

Reset:
```sh
docker container exec -it rideshare-db-1 psql -U postgres -d rideshare_development
SELECT rideshare.pg_stat_statements_reset();
```

Optional:
```
\pset recordsep '\n'
```

```sql
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
SELECT query, calls FROM pg_stat_statements
JOIN mydb ON dbid = mydb.mydbid
JOIN me ON userid = me.myuserid;
```

In fact, we can filter out a ton of stuff:
<https://github.com/andyatkinson/pg_scripts/pull/13>

Let's populate some query statistics rows. Run our earlier slow query, to act as slow query data:

```sql
SELECT * FROM users WHERE first_name = 'Alphonso';
```

We can get a query from [`andyatkinson/pg_scripts`](https://github.com/andyatkinson/pg_scripts) for PGSS,
adapting the 10 worst performers, to get the single worst one.

We can also use PgHero to explore query statistics: <http://localhost:3000/pghero>

Run this:
```sql
SELECT
    queryid,
    query as normalized_query,
    mean_exec_time AS avg_ms,
    calls,
    rows,
    (rows / calls) AS avg_rows
FROM
    pg_stat_statements
ORDER BY
    3 DESC
LIMIT 1;
```

Notes:
- Get a generic plan on 16+ with `EXPLAIN (GENERIC_PLAN) SELECT * FROM users WHERE first_name = $1;`
- Re-run the query a few times and observe the growth of "calls" and "rows" (cumulative until reset)
- We get averages but not percentiles. We can approximate percentiles (may cover that at the end of there is time)
- High call volume (e.g. calls/minute) is a great focus area!
- High average rows returned could be an opportunity to fetch smaller results on average, leading to faster execution time
- We also want to look at the IO impact which we can do using blocks information, but that may be at the end given time

NOTE: Important caveat!
- PGSS only tracks successfully executed queries
- If queries are cancelled due to exceeding an allowed time (`statement_timeout`) then they will not be tracked in PGSS, we'll have to find those in the `postgresql.log`

PGSS tracks all executions of "same group" (with params removed) types of queries.
We can now at least identify our slowest average execution time queries.

## What's Next?
Visit [7 - Macro Query Optimization Part 2](/docs/workshop/07_macro_overview_part_2.md) to continue.
