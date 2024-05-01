# Active Record Multiple Databases - Part 2

With multiple databases configured, we're ready to leverage Active Record Multiple Databases.

We can move things up to a higher layer of abstraction, by configuring model code, then making different calls to the primary or replica instance by "role".

What are roles?

## Section 1 - Roles
Let's change the main application model that classes inherit from.

We'll specify "writing" and "reading" roles we can connect to.

- Writing role: db01
- Reading role: db02

## Section 2 - Configuration
Edit `app/models/application_record.rb` to uncomment the `connects_to` code.

```rb
connects_to database: {
  writing: :rideshare,
  reading: :rideshare_replica
}
```

Let's try out that new configuration.

Use the rails console now instead of db:
```sh
bin/rails console
```

From there, we can establish connections to one role or the other.

Try out queries to each:
```rb
ActiveRecord::Base.connected_to(role: :writing) { Driver.first }
ActiveRecord::Base.connected_to(role: :reading) { Driver.first }
```

⚠️ Let's try an update to the reader. This won't work because it's running in read-only mode.
```rb
ActiveRecord::Base.connected_to(role: :reading) do
  Driver.first.update_attribute(:first_name, "Andrew")
end
```

We get an error like:
```
Write query attempted while in readonly mode
```

Let's send that to the writer:
```rb
ActiveRecord::Base.connected_to(role: :writing) do
  Driver.first.update_attribute(:first_name, "Andrew")
end
```

Great! If that committed, in a few moments it will be replicated.

Let's make sure it's replicated:
```rb
ActiveRecord::Base.connected_to(role: :reading) { Driver.first.first_name }
```

That should have returned "Andrew".

## Section 3 - Role Switching

What you saw earlier was "manual" role switching.

Active Record also supports [Automatic Role Switching](https://guides.rubyonrails.org/active_record_multiple_databases.html#activating-automatic-role-switching) based on the HTTP request and other factors.

Let's try that out.

```sh
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

Start up the rails server:
```sh
bin/rails server
```

Send a GET request:
```sh
curl localhost:3000/api/trips
```

💥 Boom. We don't see any queries logged on db01, and we see `SELECT * FROM trips;` logged on db02.

The query is automatically sent to the replica. It's working!

## Wrap Up
We've now seen how to use multiple PostgreSQL databases to distribute the database work, splitting up writes and read queries.

Scaling read traffic separately is part of building High Performance Active Record apps.

Beyond write/read role switching, for even more advanced scalability options, Active Record supports Horizontal Sharding, which has a similar pattern to what you've done here for "shard switching."
