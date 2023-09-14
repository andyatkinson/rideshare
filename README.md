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

For Rideshare, you'll need a Ruby application environment and a PostgreSQL server instance. First, work on Ruby.

- Ruby `3.2.2` (check `.ruby-version`)
    - Use a Ruby version manager like [rbenv](https://github.com/rbenv/rbenv)
- Bundler. After installing Ruby, run `gem install bundler`
- (optional) To generate a DB image [Install graphiz](https://voormedia.github.io/rails-erd/install.html)
    `brew install graphviz`

Front-end technologies were removed because this is an API only app.

- `importmap-rails` does not require yarn, npm etc. <https://fly.io/ruby-dispatch/making-sense-of-rails-assets/>

### PostgreSQL

- On MacOS [Postgres.app](https://postgresapp.com) is recommended
- run `export RIDESHARE_DB_PASSWORD=<secret value here>` before running setup scripts
- Implementation of [My GOTO Postgres Configuration for Web Services](https://tightlycoupled.io/my-goto-postgres-configuration-for-web-services/)
- Implemented as series of SQL scripts in `db` directory, run via `psql` using a shell script (see next step)
- Run `sh db/setup.sh`
- expects that `DATABASE_URL` is set for Rideshare development environment


## Installation Steps (Development)

1. Install the Prerequisites
1. `cd` into a place for the Rideshare code, e.g.: `~/Projects` (whatever you prefer)
1. From there, clone the repo with git: `git clone https://github.com/andyatkinson/rideshare.git`
1. `cd rideshare`

    You're now in ~/Projects/rideshare.

    Since you installed Bundler earlier, and are running the Ruby version the project expects, you're ready to install the gems.

    To install all the Rideshare gems, run `bundle install`.

1. If all gems were installed successfully, you're ready to set up the database. Run the following commands from your terminal.

    You should have PostgreSQL installed and your local machine. Normally you'd use `bin/rails db:create` but Rideshare has custom setup.

    On MacOS run: export RIDESHARE_DB_PASSWORD=$(openssl rand -base64 12)

    This generates a strong password like '2C6uw3LprgUMwSLQ' which is used in scripts.

    To confirm the value run "echo $RIDESHARE_DB_PASSWORD"

    You may also enter this password into the file ~/.pgpass

    Once that's set, run the following script.

    ```sh
    sh db/setup.sh
    ```

    Run pending migrations. Install graphviz if needed (see above) since it updates the ERD.

    ```sh
    bin/rails db:migrate
    ```
## .pgpass

Below is an example of the `~/.pgpass` file.

```sh
> cat ~/.pgpass
localhost:5432:rideshare_development:owner:HSTnDDgFtyW9fyFI
localhost:5432:rideshare_development:app:HSTnDDgFtyW9fyFI
```

This allows you to authenticate without the password (which comes from ~/.pgpass)

```sh
psql "postgres://app@localhost:5432/rideshare_development"
```

Or even:

```sh
psql -U owner -d rideshare_development
```

## Installation Steps (Test)

For development, you'll use some good practices in PostgreSQL like an app schema, app user, with limited explicitly granted privileges.

For the test database, you'll keep it simpler. Test uses the postgres superuser and the public schema. This is the same for Circle CI.

1. Run `sh db/setup_test_database.sh` to set up `rideshare_test`

1. Run `bin/rails test`

Refer to `.circleci/config.yml` for the Circle CI config.

## Development Guides

In addition to this Readme, [Development Guides](https://github.com/andyatkinson/development_guides) go into greater depth for Rideshare.

## Data Load

To load a pre-made data dump, run the following script from the root directory:

```sh
sh scripts/reset_and_load_data_dump.sh
```

## UI

Although Rideshare is an API-only app, technically there are some UI components.

Rideshare proudly runs [PgHero](https://github.com/ankane/pghero), which can be reached at <http://localhost:3000/pghero>

![Screenshot of PgHero for Rideshare](https://i.imgur.com/VduvxSK.png)
