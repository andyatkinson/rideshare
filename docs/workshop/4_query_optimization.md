# Query Optimization Part 1

We're still in psql. We've enabled timing.

We have a slow query of user rows filtered by first name:

```sql
SELECT * FROM users WHERE first_name = 'Alphonso';
```

We know the plan type is a sequential scan.

## Section 1: Index Design Basics
The most significant way we can improve performance for this query is to add an index that supports the query.

Why is that? The index *duplicates* the `first_name` column value from every row, into an ordered data structure.

Benefits:
- The index is faster to scan and filter on, being ordered (in ascending or descending order)
- The index entries are maintained for us as new writes happen

Downsides:
- Indexed fields add latency to write operations, since the fields are maintained as index entries

Optimization Game Plan:
- Identify the column we are filtering on.
- We are filtering on `users.first_name`
- Create a B-Tree index that includes the first name column

Do this in psql. We can replay it in Active Record later.

```sql
-- Enable timing to see build time
\timing

CREATE INDEX idx_first_name ON users (first_name);
```

This took around 10 seconds to build. Before analyzing the improvement, let's discuss the details.

## Section 2: Index Definition Analysis and Query Results
- This is a "single column" index
- This is using the default index type which is B-Tree, since it's unspecified
- We are picking all rows from the table
- We are using the default sort order
- We are using the default `NULL` handling (although `first_name` doesn't allow nulls)

Let's view our index in psql:
```sql
\d users
```

With the index in place, let's re-run the query. Make sure `\timing` is enabled.

Remember the query time before was around 0.5-1.5 seconds.

```sql
SELECT * FROM users WHERE first_name = 'Alphonso';
```

The query now takes milliseconds or less to run, which is tremendously faster.

Why is that?

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
