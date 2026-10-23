# Sharding trip positions with PgDog

This local demo shards only `rideshare.trip_positions` by bigint `trip_id` using
[PgDog](https://github.com/pgdogdev/pgdog). Two PostgreSQL instances each run the
same [DDL](../../docker/pgdog/setup.sql) in database `rideshare_sharded`, but own
different rows. Position samples can grow many times faster than trips because
each ride records multiple positions.

PgDog hashes `trip_id`: writes and reads with the same key use one shard;
reads without the key query both shards and combine results.

```mermaid
flowchart TD
    Client["Rails / psql"] --> PgDog["PgDog :6432"]
    PgDog -->|"Write / keyed read: hash trip_id, choose one"| Route{"Shard"}
    Route --> S0["shard_0 / host :5433<br/>rideshare_sharded<br/>rideshare.trip_positions"]
    Route --> S1["shard_1 / host :5434<br/>rideshare_sharded<br/>rideshare.trip_positions"]
    PgDog -->|"Unkeyed read: both shards"| S0
    PgDog -->|"Unkeyed read: both shards"| S1
    S0 --> Results["PgDog returns / combines read results"]
    S1 --> Results
    Results --> Client
```

## Run

From the repository root:

```sh
docker compose -p rideshare-pgdog -f docker-compose.pgdog.yml up -d --build
docker compose -p rideshare-pgdog -f docker-compose.pgdog.yml run --rm --build demo
```

The demo checks inserts, keyed reads, physical row placement, trip locality, and
cross-shard counts, then removes its own rows. All services share a Docker
network; volumes and ports are separate from the normal development stack.

For a Rails console:

```sh
docker compose -p rideshare-pgdog -f docker-compose.pgdog.yml run --rm demo bin/rails console
```

```ruby
sample = PgdogDemo::TripPosition.create!(trip_id: 42, position: '(1,2)')
PgdogDemo::TripPosition.for_trip(42).to_a
PgdogDemo::TripPosition.where(trip_id: 42, id: sample.id).delete_all
```

For SQL through PgDog from the host:

```sh
PGPASSWORD=postgres psql -h 127.0.0.1 -p 6432 -U postgres -d rideshare_sharded
```

Direct shard connections use the same credentials/database on host ports 5433
and 5434. Inside Docker use `shard_0:5432`, `shard_1:5432`, and `pgdog:6432`.
Init scripts run only for empty volumes; apply subsequent DDL to both shards.
Stop with `docker compose -p rideshare-pgdog -f docker-compose.pgdog.yml down`.

## PgDog admin console

Use the [PostgreSQL-protocol admin console](https://docs.pgdog.dev/administration/),
similar to PgBouncer. This demo sets database/user `admin`, password `pgdog` in
`docker/pgdog/pgdog.toml`. The upstream default password is random; see
[admin credential settings](https://docs.pgdog.dev/configuration/pgdog.toml/admin/).

Connect using the client in a shard container:

```sh
docker compose -p rideshare-pgdog -f docker-compose.pgdog.yml exec -e PGPASSWORD=pgdog shard_0 psql -X -h pgdog -p 6432 -U admin -d admin
```

Or from the host:

```sh
PGPASSWORD=pgdog psql -X -h 127.0.0.1 -p 6432 -U admin -d admin
```

```sql
SHOW POOLS;
SHOW STATS;
SHOW SERVERS;
SHOW CLIENTS;
```

Rebuild PgDog after changing its baked-in configuration:
`docker compose -p rideshare-pgdog -f docker-compose.pgdog.yml up -d --build pgdog`.

## Scope

`PgdogDemo::TripPosition` uses its own connection; the original models/API remain
unchanged. Supply `trip_id` for writes and targeted reads/updates. UUID position
IDs avoid independent bigint sequence collisions; `(trip_id, created_at)` indexes
support timeline reads. Shards have no foreign key to the original `trips` table.

Real integration requires a backfill/cutover, an ID migration strategy, and
application handling of parent existence and writes across separate databases.
Normal Rails migrations/fixtures must not target this single-table demo.
Passwords and superuser access are for local development; ports bind to loopback.
