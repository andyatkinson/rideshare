## Database Setup

## Goals

The *Principle of least privilege*[^prin] is followed by creating explicit `GRANT` commands for the `owner`, `app`, and `app_readonly` users.

The configuration is based on *My GOTO Postgres Configuration for Web Services*.[^gotocon] One of the other goals besides minimizing access, is to prevent accidental table drops.

Since the schema `rideshare` is created, the `public` schema is not needed and is removed.

For `psql` commands, use a `DATABASE_URL` environment variable that's set in your terminal.

The connection string connects to the Rideshare database, using the `owner` user. The value of `DATABASE_URL` is a connection string, with the format format `protocol://role:password@host:port/databasename`.

[^prin]: <https://en.wikipedia.org/wiki/Principle_of_least_privilege>
[^gotocon]: <https://tightlycoupled.io/my-goto-postgres-configuration-for-web-services/>



## Configuring Host Based Authentication (HBA)

You may want to configure *Host Based Authentication* (`HBA`)[^pghba].

Do that by editing your `pg_hba.conf` file. Changes in `pg_hba.conf` can be applied by *reloading* PostgreSQL.

## Reloading your PostgreSQL configuration

To reload your configuration, run: `pg_ctl reload` in your terminal. If you run into the following message, we'll get that addressed.

```sh
pg_ctl: no database directory specified and environment variable PGDATA unset
Try "pg_ctl --help" for more information.
```

This command assumes `PGDATA` is set and points to the data directory for your PostgreSQL installation.

Run `echo $PGDATA` to see the value. How do you set it if it's empty? Run the following commands in your terminal:

```sh
# Look at the value
psql $DATABASE_URL -c 'SHOW data_directory'

# Assign the value to PGDATA
export PGDATA="$(psql $DATABASE_URL \
  -c 'SHOW data_directory' \
  --tuples-only | sed 's/^[ \t]*//')"
```

With `PGDATA` set, run `pg_ctl reload` again. Once PostgreSQL config reloads, you're all set.

[^pghba]: <https://www.postgresql.org/docs/current/auth-pg-hba-conf.html>

## Docker

Reset everything:

```sh
sh reset_docker_instances.sh
```

Tear down docker:

```sh
sh teardown_docker.sh
```
