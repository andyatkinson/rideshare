# SQL Migrations
Linter for Postgres migrations
<https://squawkhq.com>

## Squawk
1. Requirements: give it a name
1. Squawk finds missing "concurrently"
1. Bring your own idempotency, add "if not exists"
1. Use same index name

```sh
squawk db/sql_migrations/01_create_index.sql
warning[require-concurrent-index-creation]: During normal index creation, table updates are blocked, but reads are still allowed.
 --> db/sql_migrations/01_create_index.sql:1:1
  |
1 | create index on trips (id, created_at);
  | --------------------------------------
  |
  = help: Use `CONCURRENTLY` to avoid blocking writes.

Find detailed examples and solutions for each rule at https://squawkhq.com/docs/rules
Found 1 issue in 1 file (checked 1 source file)
```

## Config
- Pre-commit hook
