[![CircleCI](https://circleci.com/gh/andyatkinson/rideshare.svg?style=svg)](https://circleci.com/gh/andyatkinson/rideshare)

# High Performance PostgreSQL for Rails
Rideshare is the Rails application for: [High Performance PostgreSQL for Rails](https://pgrailsbook.com)

# Installation
Prepare your development machine.
## Homebrew Packages
First, install [Homebrew](https://brew.sh).

Using Homebrew, install these:

- `brew install graphviz`

## Ruby Version Manager
Before installing Ruby, install a *Ruby version manager*. The recommended version manager is [Rbenv](https://github.com/rbenv/rbenv). Install it with Homebrew.

- `brew install rbenv`

## PostgreSQL

If you've installed version 16 of PostgreSQL via Homebrew, that's fine. If not:

- Install [Postgres.app](https://postgresapp.com)
- Add a PostgreSQL 16 server, and initialize it from the application

PostgreSQL configuration for Rideshare follows: [My GOTO Postgres Configuration for Web Services](https://tightlycoupled.io/my-goto-postgres-configuration-for-web-services/)

## Ruby Version

Run `cat .ruby-version` to find the version of Ruby that Rideshare uses.

```sh
cat .ruby-version
3.2.2
```

Install that version using Rbenv:

- `rbenv install 3.2.2`

Run `rbenv versions` to confirm that the correct version of Ruby is configured as the current version (with an asterisk):

```sh
  system
* 3.2.2 (set by /Users/andy/Projects/rideshare/.ruby-version)
```

Review *Learn how to load rbenv in your shell.* using [`rbenv init`](https://github.com/rbenv/rbenv) if needed.

## Bundler and Gems

Bundler is included when you install Ruby using Rbenv. You're ready to install the Rideshare gems:

- `bundle install`

## Rideshare development database

Normally in Rails, you'd run `bin/rails db:create`. Rideshare uses a custom script.

To create the database and configuration, you'll run the custom script: [`db/setup.sh`](db/setup.sh)

Before running it, ensure the following environment variables are set:

- `RIDESHARE_DB_PASSWORD`
- `DB_URL`
- `DATABASE_URL`

Review the script comment header section for more information on the values. The `DATABASE_URL` variable is set in `.env`, which makes it available for Rails commands, but not psql. Copy and paste the assignment into your shell, or add it to your shell file that's loaded for new shells.

Once you've set all 3 environment variables, run the script. To run it, capturing output to `output.log`, run the following command from the root directory of Rideshare:

```sh
sh db/setup.sh 2>&1 | tee -a output.log
```

Since you set `RIDESHARE_DB_PASSWORD` earlier, create or update the file `~/.pgpass` and add the password. Refer to `postgresql/.pgpass.sample` for an example of the format of lines in the file.

When you've updated it, `~/.pgpass` should look as follows. Replace the last segment `2C6uw3LprgUMwSLQ` below with the password value you generated.

```sh
localhost:5432:rideshare_development:owner:2C6uw3LprgUMwSLQ
```

Once this completes, you'll have the database set up. Verify that you can connect by running: `psql $DATABASE_URL`. Once connected, run this from psql:

- `SELECT current_user;`. Confirm that you're connected as `owner`
- `\dn`. Confirm that the `rideshare` schema is visible

## Run Migrations

Migrations in Rideshare first run `SET role = owner`, so that they run as the `owner` user, which ends up owning the tables. See: `lib/tasks/migration_hooks.rake`

Run migrations the standard way:

```sh
bin/rails db:migrate
```

If the tables were created successfully in the `rideshare` schema, you're good to go!


# Development Guides and Documentation

- In addition to this file, the [Development Guides](https://github.com/andyatkinson/development_guides) go into greater depth for preparing your development machine.
- For Guides and Tasks, check out: [Guides](GUIDES.md)
- For PostgreSQL guidance, check out: [postgresql/README.md](postgresql/README.md)
- For database scripts, check out: [db/scripts/README.md](db/scripts/README.md)
- To testing details for Rideshare, check out: [TESTING.md](TESTING.md)
- Check out [db/README.md](db/README.md)

# UI

Although Rideshare is an *API-only* app, there are some UI elements.

Rideshare runs [PgHero](https://github.com/ankane/pghero) which has a UI.

* Run `bin/rails server`
* Navigate to <http://localhost:3000/pghero>

![Screenshot of PgHero for Rideshare](https://i.imgur.com/VduvxSK.png)
