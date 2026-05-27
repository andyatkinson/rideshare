# Query Optimization Part 1
We're still in psql. We've enabled timing.

We have a slow query of user rows filtered by first name:
```sql
SELECT * FROM users WHERE first_name = 'Alphonso';
```

Even once Postgres accesses these pages and copies them into memory buffers, we still see an unacceptably slow execution time
of 500ms - 2 seconds. As a reminder, for a scalable system we want sub 5ms or even sub 1ms execution times.

We know the plan scan node is a (parallel) sequential scan, which is the most inefficient scan node type. How can we do better?

## Section 1: Index Design Basics
Can we modify the query itself to get better execution? I can't think of any ways.

Can we modify how the data is stored? Well, we could keep different copies of the `users` table and store all the "A" names in one copy, sort of "sharded names". That sounds horrible.

We want to manage a single table for all of our users for now. 10 million rows is a significant amount, but Postgres can certainly access a single row in sub 5ms given right schema design.

The most significant way we can improve performance for this query is to add an index that supports the query, specifically, to help us quickly find "Alphonso"!

Why is an index faster? An index keeps an ordered data structure for fast lookup. The indexed column like "first_name" here, *duplicates* the column value for every row into this ordered data structure.

The index is a tree structure including a root node, branches, and leaf nodes. The complexity then is more like `O(log n)` vs. `O(n)`.

With this index in place, Postgres scans the index, follows a branch to a leaf node, and repeats this until the item is found. Then the heap is scanned using the pointer that's part of the index entry.

Benefits for reads:
- The index is faster to scan and filter on compared with an inefficient sequential scan of the whole table, being ordered, and using a tree structure
- Index entries are maintained for us as new writes happen, which does add some latency to write operations

Downsides:
- Added latency to write operations
- Space consumption

Our Optimization Game Plan:
- Identify the column we are filtering on.
- We are filtering on `users.first_name`
- Create a B-Tree index that includes the first name column

Do this in psql. We can replay it in Active Record later.

```sql
-- Enable timing to see build time
\timing

<!-- CREATE INDEX "the main command" -->
<!--     idx_first_name "the index name" -->
<!--     ON users "the table where the index is added -->
<!--     (first_name); "the field we're indexing" -->

CREATE INDEX idx_first_name ON users (first_name);
```

This took around 10 seconds on my machine to build. Before determining whether this index helps us find Alphonso faster, let's discuss the characteristics of this index.

## Section 2: Index Definition Analysis and Query Results
- This is a "single column" index ("first_name")
- This is using the default index type B-Tree, since we didn't specify a type
- We're picking all rows from the table
- We're using the default sort order
- We're using the default `NULL` handling (although `first_name` doesn't allow nulls)

Let's view our index in psql:
```sql
\d users
```

With the index in place, let's re-run the query. Make sure `\timing` is enabled.

Remember the query time before was around 0.5-2 seconds.
```sql
SELECT * FROM users WHERE first_name = 'Alphonso';
```

Nice! The query is now e.g. 2300x faster (2000/0.868), achieving our goal of sub 5ms or sub 1ms when warmed up.

Let's dig in further as to what is happening here.

## Section 3: Index Design Concepts
Let's look at the query plan. Let's introduce `ANALYZE` now to run the query.

```sql
EXPLAIN (ANALYZE)
SELECT * FROM users WHERE first_name = 'Alphonso';
```

```sql
\dt+ users            -- 1154MB size
\di+ idx_first_name   -- 301MB
```

Table size vs. index size:
- Now we're scanning the index which is smaller, it contains one column, and it's in order
- This is an Index Scan using the index we created `idx_first_name`
- We still "filter" on the index, but with much less data access
- Startup and actual costs are much lower compared with before
- Actual rows shows 8 rows, 1 loop

PostgreSQL still needs to access more fields (`SELECT *`) from the heap/table storage, but for a small filtered set of rows.

Can we do better?

## What's Next?
Visit [5 - Query Optimization Part 2](/docs/workshop/5_query_optimization_part_2.md) to continue.
