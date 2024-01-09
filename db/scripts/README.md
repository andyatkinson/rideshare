# DB Scripts

Run all scripts from the `db` directory.

From the Rideshare root, `cd` into `db`.

## Bulk Load

Create `10_000_000` records, mix of Drivers and Riders, in `rideshare.users` using SQL

Inspiration: <https://vnegrisolo.github.io/postgresql/generate-fake-data-using-sql>

```sh
sh scripts/bulk_load.sh
```

## pgbench

```sh
sh scripts/benchmark.sh
```

## List table comments

```sh
sh scripts/list_table_comments.sh
```

## Simulate bloat

```sh
sh scripts/simulate_bloat.sh
```
