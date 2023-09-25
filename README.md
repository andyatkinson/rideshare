[![CircleCI](https://circleci.com/gh/andyatkinson/rideshare.svg?style=svg)](https://circleci.com/gh/andyatkinson/rideshare)

# Rideshare

Rideshare is a Rails API app that implements a portion of a fictional Ridesharing service.

## High Performance PostgreSQL for Rails

This repo started as a side project back in 2019 to demonstrate good practices.

In 2022, it took on a new purpose as the Rails application for exercises and examples in [High Performance PostgreSQL for Rails](https://pgrailsbook.com).

Rideshare proudly runs on PostgreSQL. 🐘

## Local Development

To set up Rideshare for development, please read the Prerequisites and Installation Steps sections below.

These steps involve setting up your development machine with all the runtime dependencies, and then setting up your local PostgreSQL instance.

## Prerequisites

### Ruby

For Rideshare, you'll need Ruby and PostgreSQL. First, work on Ruby.

- Ruby `3.2.2` (check `.ruby-version`)
    - Use a Ruby version manager like [rbenv](https://github.com/rbenv/rbenv)
- [Bundler](https://bundler.io). After installing Ruby, run `gem install bundler`.
- (optional) To generate a DB image [Install graphiz](https://voormedia.github.io/rails-erd/install.html)
    `brew install graphviz`

Front-end technologies were removed because this is an API only app.

- `importmap-rails` does not require yarn, npm etc. <https://fly.io/ruby-dispatch/making-sense-of-rails-assets/>

### PostgreSQL

- On macOS, [Postgres.app](https://postgresapp.com) is the recommended way to install it
- Currently on PostgreSQL 16 (2023)
- run `export RIDESHARE_DB_PASSWORD=<secret value here>` before running setup scripts (see below)
- Configures PostgreSQL following [My GOTO Postgres Configuration for Web Services](https://tightlycoupled.io/my-goto-postgres-configuration-for-web-services/)
- Configuration uses a series of SQL scripts in `db` directory, run from `psql` via a shell script (see next step)
- Run `sh db/setup.sh`
- expects `DATABASE_URL` is set
- Migrations will first run `SET role = owner` to run Migrations as `owner`, which will own the tables, check `lib/tasks/migration_hooks.rake`


## Installation Steps (Development)

1. Install the Prerequisites
1. `cd` into your source code directory e.g.: `~/Projects`
1. From there, clone the repo: `git clone https://github.com/andyatkinson/rideshare.git`
1. `cd rideshare`

    Install all the Rideshare gems by running `bundle install`

1. If all gems were installed, you're ready to set up the database.

    You should have PostgreSQL installed but no database for the app created yet.

    Normally you'd run `bin/rails db:create` to create databases, but Rideshare has a custom setup.

    On macOS run, for a brand new installation:

    ```sh
    export RIDESHARE_DB_PASSWORD=$(openssl rand -base64 12)
    ```

    For existing credentials (upgrades), set RIDESHARE_DB_PASSWORD using the password defined in ~/.pgpass.

    This sets an environment variable with a value like '2C6uw3LprgUMwSLQ' that will be used when creating roles.

    Create the file `~/.pgpass` and refer to the sample file in the `postgresql` directory of this project, filling in your details.

    Once that's set, run the following script to set up the databases, roles, grants, and more.

    ```sh
    sh db/setup.sh
    ```

    Set up DATABASE_URL, which is used locally in `config/database.yml`. Use the `owner` role which is a readwrite role, and should have permissions to modify the schema, creating tables in the `rideshare` PostgreSQL schema.

    export DATABASE_URL="postgres://owner:@localhost:5432/rideshare_development"

    Try connecting with `psql $DATABASE_URL` and run `\dn` from psql. You should see the `rideshare` schema and all the tables created in that schema.

    Run pending migrations. You may need to install graphviz (see above) to update the ERD.

    ```sh
    bin/rails db:migrate
    ```
## `~/.pgpass`

Below is sample `~/.pgpass` file.

```sh
cat ~/.pgpass

localhost:5432:rideshare_development:owner:HSTnDDgFtyW9fyFI
localhost:5432:rideshare_development:app:HSTnDDgFtyW9fyFI
```

Authenticate without the password (supplied from from `~/.pgpass`)

```sh
psql $DATABASE_URL
```

Or:

```sh
psql -U owner -d rideshare_development
```

## Installation Steps (Test)

For development, you'll use some good practices in PostgreSQL like a custom app schema and app user, with reduced explicitly granted privileges.

For the test database, you'll keep it simpler. Use the postgres superuser and the public schema. The test configuration is also used for Circle CI.


1. Run `sh db/setup_test_database.sh` to set up `rideshare_test`

1. Currently need to `RAILS_ENV=test bin/rails db:migrate` first, to apply migrations to `rideshare_test`. In test, the tables are created in the `public` schema. May change to app-schema as well.

1. Run `bin/rails test`

Refer to `.circleci/config.yml` for the Circle CI config.

## Development Guides

In addition to this Readme, [Development Guides](https://github.com/andyatkinson/development_guides) go into greater depth for setting up your machine for Rideshare development.

For Guides specific to this repo, check [Guides](/GUIDES.md).

## Data Load

To load a pre-made data dump, run the following script from the root directory:

```sh
sh scripts/reset_and_load_data_dump.sh
```

## UI

Although Rideshare is an API-only app, there are some UI elements.

Rideshare proudly runs [PgHero](https://github.com/ankane/pghero), which can be reached at <http://localhost:3000/pghero>

![Screenshot of PgHero for Rideshare](https://i.imgur.com/VduvxSK.png)
