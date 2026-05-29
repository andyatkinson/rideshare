# Query Planning
We'll use psql (or run `rails db`) going forward.

```sql
psql $DATABASE_URL
```

## Psql Quick Tips
Backslash commands:
- `\q` to quit!
- clear: `\! clear`
- `\x` vertically format output, easier to read


## Section 1: We need a query
We need a query. We just loaded 10 million users.

Let's get all users that have a certain **first** name. Let's find one from the existing rows.

```sql
SELECT first_name FROM users ORDER BY id ASC LIMIT 1;
 first_name
------------
 Alphonso
```

## Section 2: Enabling timing
Toggle timing to `on`.

```sql
\timing
Timing is on.
```

```sql
SELECT * FROM users WHERE first_name = 'Alphonso';
-- Type "q" to exit results
-- Time: 2012.136 ms (00:02.012)
```

On my machine, this returns 8 rows, taking around 2 seconds. Two seconds is way too slow! We want sub-5ms execution or better for a production environment.

We need to figure out why this is slow!

Let's look at the query plan. To do that we'll start with the `EXPLAIN` keyword.

```sql
EXPLAIN SELECT * FROM users WHERE first_name = 'Alphonso';
```

## Section 3: Intro to [`EXPLAIN`](https://www.postgresql.org/docs/current/using-explain.html)
Let's understand the parts we're seeing.

```sql
set jit=off; -- optional
```

- Plan step is contained within the one above it
- Filter operation, condition to match, we may see "rows removed by filter" (when using `ANALYZE`, will discuss later)
- "Sequential scan" (the "scan node") on `users` table (<https://pganalyze.com/docs/explain/scan-nodes/sequential-scan>)
- This data is not sorted, so it's very inefficient to find data this way. Postgres has no idea where "Alphonso" will be.
- Parallel sequential scan using 2 workers (Parallel Seq Scan), we will set to 1 later
- Estimated to match one row (`rows=1`) (but we know there are more)
- Width is "estimated average width of rows" in bytes, e.g. 129 bytes <https://www.postgresql.org/docs/current/using-explain.html>
- The cost is an "arbitrary unit" based on how many disk pages are accessed, it has two figures, we can calculate it manually
- Startup cost and total cost, e.g. `cost=0.00..1234.56`
- Startup cost: before the first row can be returned (index navigation, sorting, build a hash table, 0.00 means no cost)
- Total cost: Estimated cost to return all rows from node

Let's get into the cost details more.

## Section 4: Pages Intro and Cost calculation
Data in PostgreSQL is stored in "pages" which are fixed size 8kb (by default) chunks. Row data and index data are stored in pages.

For this workshop, we won't go into greater depth. Just know that "more pages = slower query", as there's latency to access more data. Conversely, "fewer pages = faster query".

Let's look at a simplified version of the query:
- Let's disable parallel sequential scans (max worker of 1)

```sql
SET max_parallel_workers_per_gather = 0;
```

- Now we should see a single Sequential Scan

Let's make this even more painful:
- Let's scan the whole table with no `WHERE` clause
- Let's get the number of pages for the table
- Let's manually reproduce the cost formula calculation

Let's run the simplified query from psql:
```sql
EXPLAIN SELECT * FROM users;
                            QUERY PLAN
-------------------------------------------------------------------
 Seq Scan on users  (cost=0.00..247873.94 rows=10020294 width=129)
```

The rounded estimated cost is 247874.

Let's recalculate 247874. To start, get the number of pages from psql used to store all the rows:
```sql
SELECT relpages AS pages, reltuples::numeric AS estimated_rows
FROM pg_class WHERE relname = 'users';

 pages  | estimated_rows
--------+----------------
 147671 |       10020300
```

Cost formula from docs:
`(pages * seq_page_cost) + (estimated_rows * cpu_tuple_cost)`

Cost calculation components:

- Pages: `147671`
- Estimated rows: `10020300`
- `SHOW seq_page_cost;` (`1`)
- `SHOW cpu_tuple_cost;` (`0.1`)


```sql
SELECT FLOOR((147671 * 1) + (10020300 * 0.01)) AS estimated_cost;
 estimated_cost
----------------
         247874
```

Now we understand some planner information about the plan type, the cost, the width, plan nodes, let's continue on with query optimization.

## What's Next?
Visit [4 - Query Optimization](/docs/workshop/04_query_optimization.md) to continue.
