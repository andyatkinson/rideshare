[![CircleCI](https://circleci.com/gh/andyatkinson/rideshare.svg?style=svg)](https://circleci.com/gh/andyatkinson/rideshare)

# 📚 High Performance PostgreSQL for Rails
Rideshare is the Rails application for the book ["High Performance PostgreSQL for Rails"](https://pragprog.com/titles/aapsql/high-performance-postgresql-for-rails), published by Pragmatic Programmers in 2024.

# Installation
Prepare your development machine.

## Homebrew Packages
First, install [Homebrew](https://brew.sh).

### Graphviz
```sh
brew install graphviz
```

## Ruby Version Manager
Before installing Ruby, install a *Ruby version manager*. The recommended one is [Rbenv](https://github.com/rbenv/rbenv). Run:

```sh
brew install rbenv
```

## PostgreSQL
If you've installed version 16 of PostgreSQL via Homebrew, that's ok, although the recommended method is below.

- Install [Postgres.app](https://postgresapp.com)
- From the Menu Bar app, click "+" to create a PostgreSQL 16 server

PostgreSQL configuration is based on [My GOTO Postgres Configuration for Web Services](https://tightlycoupled.io/my-goto-postgres-configuration-for-web-services/)

## Ruby Version
Run `cat .ruby-version` to find the version of Ruby that's needed

For example, for `3.2.2` run:

```sh
rbenv install 3.2.2
```

Run `rbenv versions` to confirm the correct version is being used. The current will have an asterisk.

```sh
  system
* 3.2.2 (set by /Users/andy/Projects/rideshare/.ruby-version)
```

Running into trouble? Review *Learn how to load rbenv in your shell* using [`rbenv init`](https://github.com/rbenv/rbenv).

## Bundler and Gems
Bundler is included when you install Ruby using Rbenv. You're ready to install gems. Run:

```sh
bundle install
```

## Rideshare development database
Normally in Rails, you'd run `bin/rails db:create` to create your database. Rideshare uses a custom script.

To create the database and initial objects, you'll run the [`db/setup.sh`](db/setup.sh) script.

Before running it, ensure the following environment variables are set:

- `RIDESHARE_DB_PASSWORD`
- `DB_URL`

Review the `db/setup.sh` script header section for details on the expected values for those environment variables.

Once both are set, run the script using the command below. This method captures output to the `output.log` file.

```sh
sh db/setup.sh 2>&1 | tee -a output.log
```

Since you set `RIDESHARE_DB_PASSWORD` earlier, create or update the `~/.pgpass` file with the password value.

Refer to `postgresql/.pgpass.sample` for a sample entry.

When you've updated it, `~/.pgpass` should have an entry like the one below. Replace the last segment, for example `2C6uw3LprgUMwSLQ` is shown below, with the password value that you generated.

```sh
localhost:5432:rideshare_development:owner:2C6uw3LprgUMwSLQ
```
Run `chmod 0600 ~/.pgpass`.

Finally, run `export DATABASE_URL=<value from .env>`, setting the value from the `.env` file for the `DATABASE_URL` environment variable.

Once that's set, verify you're able to connect by running: `psql $DATABASE_URL`. Once connected, run this:

```sql
SELECT current_user;
```

Confirm you're connected as the `owner` user. Then run the *describe namespace* meta-command:

```sql
\dn
```
Verify the `rideshare` schema is displayed. Run the *describe table* meta command next: `\dt`. You should see the  Rideshare tables.

## Run Migrations
Migrations in Rideshare are preceded by `SET role = owner`, so that they run as the `owner` user, which owns the objects.

See `lib/tasks/migration_hooks.rake` for more details.

Run migrations the standard way:

```sh
bin/rails db:migrate
```
If migrations ran successfully, you're good to go!

# Development Guides and Documentation

## Troubleshooting

The Rideshare repository has many `README.md` files within subdirectories. Run `find . -name 'README.md'` to see them all.

- For expanded installation and troubleshooting, navigate to the [Development Guides](https://github.com/andyatkinson/development_guides) go into greater depth for preparing your development machine.
- For PostgreSQL things: [postgresql/README.md](postgresql/README.md)
- For Docker things: [docker/README.md](docker/README.md)
- For DB things: [db/README.md](db/README.md)
- For database scripts: [db/scripts/README.md](db/scripts/README.md)
- For DB scrubbing: [db/scrubbing/README.md](db/scrubbing/README.md)
- For test environment details in Rideshare, check out: [TESTING.md](TESTING.md)
- For Guides and Tasks in this repo, check out: [Guides](GUIDES.md)

# UI

Although Rideshare is an *API-only* app, there are some UI elements.

Rideshare runs [PgHero](https://github.com/ankane/pghero) which has a UI.

Connect to it:

```sh
bin/rails server
```

Once that's running, visit <http://localhost:3000/pghero> in your browser to see it.

![Screenshot of PgHero for Rideshare](https://i.imgur.com/VduvxSK.png)
