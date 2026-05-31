# Query Optimization: Part 2

## Section 1: Efficiency Design Concepts
- Add more restrictions to the query, for example limit the fields
- We then may want to revise our index definition or add a new index to support a more restricted query

```sql
EXPLAIN (ANALYZE)
SELECT * FROM users WHERE first_name = 'Alphonso';
```

## Section 2: Filtering Down Rows in Index
We can reduce the rows in our index. When we do that we're making a [Partial Index](https://www.postgresql.org/docs/current/indexes-partial.html).

Let's explore our data and look for opportunities.

We store different `type` values in this table, so let's `COUNT()` by type for first name "Alphonso".

This finds Drivers and Riders, both stored in `users` table that are named Alphonso.
```sql
SELECT type, COUNT(*) FROM users
WHERE first_name = 'Alphonso'
GROUP BY type;

  type  | count
--------+-------
 Driver |     4
 Rider  |     4
```


Imagine we only wanted to index the Driver type and not Riders.

Let's change our query then:
```sql
EXPLAIN (ANALYZE)
SELECT * FROM users
WHERE first_name = 'Alphonso'
AND where type = 'Driver'; -- <-- we added this additional WHERE clause condition
```

This still scans our index, but our index contains both Riders and Drivers now.

```
Rows Removed by Filter: 9
```

This means that Riders scanned in the index are immediately discarded by Postgres. This is fine at our
size of data, but when we have 100s of millions or billions of rows, and we're discarding large quantities of data,
this could become an inefficient index scan.

How can we make our index more efficient and contain only the needed data?

We can limit our index to just Drivers. Let's drop our current index, and add it back with the same name, but add
an additional condition. This works just like a `WHERE` clause for a query, but it's a `WHERE` clause for the index.
```sql
-- Drop existing index
DROP INDEX IF EXISTS idx_first_name;

CREATE INDEX idx_first_name ON users (first_name)
WHERE (type = 'Driver'); -- <-- we're adding this!!
```

Let's run: `\di+ idx_first_name;` again and this time we see the index is half the size at 151MB vs. 301MB.

Let's run our query again:
```sql
EXPLAIN (ANALYZE)
SELECT * FROM users
WHERE first_name = 'Alphonso';
```

😲 It's slow! What happened? Think a moment about the query...

Ok, we updated our index definition, but we didn't update the query.

We need to align the query and the index definition. Postgres can't use the index if its definition doesn't match the query.

We're trying to create a special-purpose index here for this query.

Let's add the same additional WHERE clause condition we added to the index, to the query. Run again:
```sql
EXPLAIN (ANALYZE)
SELECT * FROM users
WHERE first_name = 'Alphonso'
AND type = 'Driver'; -- <-- Add type='Driver' here, matching index
```

It's now smoking fast again, using the new even smaller index! About 10x faster (`0.868/0.087`) with the partial index condition compared without it!

We're accessing 14 buffers, all shared hits.

Can we do even better?

## Section 2: Filtering Down Columns in Index
Besides filtering rows in our index with partial indexes, we can limit the columns picked in both our query and index definitions.

By including the exact set of columns our query needs instead of `SELECT *`, PostgreSQL can get all needed data from the index alone, which is very fast.

Let's imagine we needed the `id` of the `Driver` types of `users` named "Alphonso".

Let's change our query first and see if it's better:
```sql
EXPLAIN (ANALYZE)
SELECT id, first_name
FROM users WHERE first_name = 'Alphonso'
AND type = 'Driver'; -- This is the new condition
```

It's not really any better despite reducing our columns.

This is because our current index does not include the `id` column. PostgreSQL can't get all field data from the index alone.

Let's replace the current index with a new index that includes only those two columns.
```sql
-- Drop existing index
DROP INDEX IF EXISTS idx_first_name;

CREATE INDEX idx_first_name ON users (first_name, id) -- <-- only two columns
WHERE (type = 'Driver');
```

Let's review our index characteristics now:
- A partial index
- A multicolumn index, where the leading column is our filtered column

Let's check the query plan.
```sql
EXPLAIN (ANALYZE)
SELECT id, first_name
FROM users WHERE first_name = 'Alphonso'
AND type = 'Driver';
```

Maybe not any faster in execution time, but this is the most scan node type possible, the "Index Only Scan."

And we're accessing the fewest possible buffers: 3.5x fewer than above (`14/4`) (all still cache hits), which means the least amount of IO when this is a "cache miss" and the storage device is accessed.

Our index contains the full set of needed columns for the query, meaning PostgreSQL only needs to access the index and not the heap.

We can see that with "Heap Fetches: 0" below.
```sql
                                                           QUERY PLAN
--------------------------------------------------------------------------------------------------------------------------------
 Index Only Scan using idx_first_name on users  (cost=0.43..8.45 rows=1 width=20) (actual time=0.053..0.057 rows=11.00 loops=1)
   Index Cond: (first_name = 'Alphonso'::text)
   Heap Fetches: 0
   Index Searches: 1
   Buffers: shared hit=4
 Planning Time: 0.205 ms
 Execution Time: 0.091 ms
(7 rows)

Time: 0.966 ms
```

We have throughly optimized this query.

Now we realize our application has literally thousands of queries with tons of variants. How do we work on the queries with the most optimization return on investment (ROI)?

## What's Next?
Visit [6 - Macro Query Optimization Part 1](/docs/workshop/06_macro_overview_part_1.md) to continue.
