# Active Record Multiple Databases - Part 2
Let's further explore Active Record Multiple Databases configuration.

We can now connect application code via parent models that are configured to work with a DB. Each DB can have "roles" for writing and reading.

What are Active Record Multiple Databases roles?

## Section 1 - Active Record DB Roles
Let's change the main application model that classes inherit from.

We'll specify "writing" and "reading" roles we can connect to.

- Writing role: `db01`
- Reading role: `db02`

## Section 2 - Configuration
Edit `app/models/application_record.rb` and uncomment `connects_to` code.

```rb
connects_to database: {
  writing: :rideshare,
  reading: :rideshare_replica
}
```

Let's try out that new configuration.

To make this work, we set `DATABASE_URL_PRIMARY` and `DATABASE_URL_REPLICA` in docker-compose.yml to connect to db01 and db02.

Use the rails console:
```sh
docker compose exec -it app bin/rails console
```

From there, we can establish connections to one role or the other.

Try queries to each. Thanks to replication, these are in sync.

You're running running queries on two different instances, switching at the application level:
```rb
ActiveRecord::Base.connected_to(role: :writing) { Driver.first }
ActiveRecord::Base.connected_to(role: :reading) { Driver.first }
```

To verify that in psql we can use `\conninfo`, but from Active Record we can compare host IPs or check if "in recovery" (which is true for the replica):
```rb
ActiveRecord::Base.connected_to(role: :writing) { ApplicationRecord.connection.select_value("SELECT inet_server_addr()") }
ActiveRecord::Base.connected_to(role: :reading) { ApplicationRecord.connection.select_value("SELECT inet_server_addr()") }
```
```rb
ActiveRecord::Base.connected_to(role: :reading) { ApplicationRecord.connection.select_value("SELECT pg_is_in_recovery();") }
ActiveRecord::Base.connected_to(role: :writing) { ApplicationRecord.connection.select_value("SELECT pg_is_in_recovery();") }
```

⚠️ Let's try an update to the reader. This won't work because it's running in read-only mode.
```rb
ActiveRecord::Base.connected_to(role: :reading) { Driver.first.update_attribute(:first_name, "Andrew") }
```

We should get an error like this:
```
  Driver Load (2.8ms)  SELECT "users".* FROM "users" WHERE "users"."type" = $1 ORDER BY "users"."id" ASC LIMIT $2  [["type", "Driver"], ["LIMIT", 1]]
(rideshare):19:in `block in <top (required)>': Write query attempted while in readonly mode: UPDATE "users" SET "first_name" = $1, "updated_at" = $2 WHERE "users"."id" = $3 (ActiveRecord::ReadOnlyError)
        from (rideshare):19:in `<top (required)>'
```

Let's send that to the writer:
```rb
ActiveRecord::Base.connected_to(role: :writing) { Driver.first.update_attribute(:first_name, "Andrew") }
```

This works! Great! Once that committed, in a few moments it will be replicated.

Let's make sure it's replicated:
```rb
ActiveRecord::Base.connected_to(role: :reading) { Driver.first.first_name }
```

That should have returned "Andrew".

## Section 3 - Role Switching
What you saw earlier is called "manual role switching" in Active Record lingo.

Active Record also supports [Automatic Role Switching](https://guides.rubyonrails.org/active_record_multiple_databases.html#activating-automatic-role-switching) based on the HTTP request and other factors.

Let's try that out. We'd apply these changes:
```sh
docker compose exec -it app bash
bin/rails g active_record:multi_db
```

Add to `config/application.rb`:
```rb
config.active_record.database_selector = { delay: 2.seconds }
config.active_record.database_resolver = ActiveRecord::Middleware::DatabaseSelector::Resolver
config.active_record.database_resolver_context = ActiveRecord::Middleware::DatabaseSelector::Resolver::Session
```

Let's log all queries. We'd like to verify that sending a GET request runs on db02, although we make this change on db01:
```sh
docker exec --user postgres -it db01 psql
ALTER DATABASE rideshare_development SET log_statement = 'all';
```

Let's tail db01 and db02 logs in different terminals:
```sh
docker logs -f db01
docker logs -f db02
```

Make sure rails server is running in Docker.

Send a GET request:
```sh
curl localhost:3000/api/trips
```

Where did the query run? On the primary (db01) or the replica (db02)? 

Well, Active Record uses the request verb (GET) to determine it's safe to run this query on the replica.

It *automatically* routes this query to the replica, meaning the DB resources needed for it are on the replica, not the primary.

We don't see any queries logged on db01, and we *do* see `SELECT * FROM trips;` logged on db02!

💥 Boom. You've just scaled part of your workload automatically across multiple Postgres instances.

## Wrap Up
We've now seen how to use multiple PostgreSQL databases to distribute the database work, splitting up writes and read queries.

Leveraging replicas for read queries when possible is part of building High Performance Active Record and Postgres apps that distribute work among multiple instances.

Beyond write/read role switching, for even more advanced scalability options, Active Record supports Horizontal Sharding, which has a similar pattern to what you've done here for "shard switching."

[Horizontal Sharding with Active Record](https://guides.rubyonrails.org/active_record_multiple_databases.html#horizontal-sharding)

We can also:
- Create a `ShardRecord` parent class
- Manually connect to shards
- Automatically connect to shards using a "Shard Resolver"

This will be beyond the scope of this workshop, but if there is time we can talk through some of the details.

Thank you!
