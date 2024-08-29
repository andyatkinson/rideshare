# Query Optimization: Part 2

## Section 1: Efficiency Design Concepts
- Add more restrictions to the query
- Add indexes to support more restricted query

```sql
EXPLAIN (ANALYZE)
SELECT * FROM users WHERE first_name = 'Alphonso';
```

## Section 2: Filtering On Rows
We can reduce the rows in our index. When we do that, we're making a [Partial Index](https://www.postgresql.org/docs/current/indexes-partial.html).

Let's explore our data and loop for opportunities.

We store different `type` values in this table, so let's `COUNT()` by type for first name "Alphonso".

```sql
SELECT type, COUNT(*) FROM users
WHERE first_name = 'Alphonso'
GROUP BY type;

  type  | count
--------+-------
 Driver |     4
 Rider  |     4
```

Imagine we only wanted to index the Driver type, since this query finds drivers.

We can limit our index to just the Drivers. Let's drop our current index, and add it back with the same name.

```sql
-- Drop existing index
DROP INDEX IF EXISTS idx_first_name;

CREATE INDEX idx_first_name ON users (first_name)
WHERE (type = 'Driver');
```

Let's run: `\di+ idx_first_name;` again and this time we see the index is half the size at 151MB vs. 301MB.

Let's run our query again:

```sql
EXPLAIN (ANALYZE)
SELECT * FROM users
WHERE first_name = 'Alphonso';
```

😲 It's slow! We need to add this same condition we added to the index, to the query. Let's try that:


```sql
EXPLAIN (ANALYZE)
SELECT * FROM users
WHERE first_name = 'Alphonso'
AND type = 'Driver'; -- This is the new condition
```

Now it's super fast again. It's using our index. There are only 4 result rows which makes sense.

Can we do better?

## Section 2: Filtering On Columns
Besides filtering rows in our index, we can filter columns picked in both our query and index definition.

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

Let's replace it with a new definition that includes those two columns.


```sql
-- Drop existing index
DROP INDEX IF EXISTS idx_first_name;

CREATE INDEX idx_first_name ON users (first_name, id)
WHERE (type = 'Driver');
```

We now have:
- A partial index
- A multicolumn index, where the leading column is our filtered column

Let's check the query plan.

```sql
EXPLAIN (ANALYZE)
SELECT id, first_name
FROM users WHERE first_name = 'Alphonso'
AND type = 'Driver';
```

We're now getting the most efficient plan type possible, which is the "Index Only Scan."

This is because our index contains the full set of needed columns for the query, meaning PostgreSQL only needs to access the index.

```sql
                                                         QUERY PLAN
----------------------------------------------------------------------------------------------------------------------------
 Index Only Scan using idx_first_name on users  (cost=0.43..8.45 rows=1 width=20) (actual time=0.032..0.034 rows=4 loops=1)
   Index Cond: (first_name = 'Alphonso'::text)
   Heap Fetches: 0
 Planning Time: 0.126 ms
 Execution Time: 0.055 ms
```

## What's Next?
Visit [6 - Macro Query Optimization Part 1](/docs/workshop/6_macro_overview_part_1.md) to continue.
