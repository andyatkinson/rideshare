## Search

- Using `pg_search` gem, adds AR scopes
- `tsearch` is built in, PostgreSQL Full Text Search
- Creates a `tsvector` from document text
- Search it using a `tsquery`
- Rank fields using `ts_rank()`
- Store tsvectors using a Generated column
- Index tsvectors using a GIN index
- Add `users.searchable_full_name` `GENERATED ALWAYS`
- For unaccent, consider an expression based index
