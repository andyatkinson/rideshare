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
    Client["TripPosition / psql"] --> PgDog["PgDog :6432"]
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

For the full app and tests, connect the normal stack to the demo network:

```sh
docker compose -f docker-compose.yml -f docker-compose.pgdog-app.yml up -d --build
docker compose -f docker-compose.yml -f docker-compose.pgdog-app.yml exec -e RAILS_ENV=test app bin/rails test
```

Tests use `rideshare_test` for primary data and `rideshare_sharded_test` on the
same two shards for positions. PgDog integration tests run when
`PGDOG_TEST_DATABASE_URL` is set (the app override sets it); otherwise they skip.
New volumes initialize both shard databases.
For existing volumes without the test database, run once per shard:
`docker compose -p rideshare-pgdog -f docker-compose.pgdog.yml exec shard_0 sh /docker-entrypoint-initdb.d/setup-test.sh`
(and repeat for `shard_1`).

For a Rails console (requires existing trips in the normal development DB):

```sh
docker compose -f docker-compose.yml -f docker-compose.pgdog-app.yml exec app bin/rails console
```

```ruby
sample = Trip.first!.trip_positions.create!(position: '(1,2)')
TripPosition.for_trip(sample.trip_id).to_a
TripPosition.where(trip_id: sample.trip_id, id: sample.id).delete_all
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

`TripPosition < PgdogRecord` keeps its validations and `belongs_to :trip`.
`config/database.yml` defines `primary`, `pgdog`, and `pgdog_readonly` connections.
`PgdogRecord` maps the Rails `writing`/`reading` roles to the PgDog connections;
both reach the same two primary shards. Use `PgdogRecord.connected_to(role:
:reading)` for reads. PgDog, not Rails, chooses the physical shard.

Override `PGDOG_DATABASE_URL` and optionally `PGDOG_READING_DATABASE_URL` for
development; tests use `TEST_DATABASE_URL` and `PGDOG_TEST_DATABASE_URL`. PgDog
connections disable Rails database tasks; shared DDL is managed directly on shards.

Supply `trip_id` for writes and targeted reads/updates. UUID position IDs avoid
independent bigint sequence collisions; `(trip_id, created_at)` indexes support
timeline reads. There is no foreign key to the original `trips` table. Ordinary
association reads use separate queries; SQL joins across these databases are not
supported. Use `preload(:trip_positions)` for separate association queries;
`includes` with position conditions can turn into an unsupported join. Joins
starting from `Trip` still query the old primary table and can return stale data
or fail on bigint/UUID comparisons. Transactions on the primary do not cover
position writes.

Existing position rows need a deliberate backfill/cutover and ID migration;
the old primary table is not removed automatically. Normal Rails migrations and
fixtures must not target PgDog. Demo routing samples use synthetic trip IDs and
skip parent validation; real application writes retain validation.
Passwords and superuser access are for local development; ports bind to loopback.
