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
Before installing Ruby, install a *Ruby Version Manager*. The version manager makes it easy to manage multiple versions at once.

- [rbenv](https://github.com/rbenv/rbenv) is recommended.
- `brew install rbenv`

## PostgreSQL

- On macOS, [Postgres.app](https://postgresapp.com) is recommended
- Using PostgreSQL 16 (2023)
- run `export RIDESHARE_DB_PASSWORD=<secret value here>` before running setup scripts (see below)
- Scripts expect that `DB_URL` and `DATABASE_URL` are set.
- PostgreSQL is configured following [My GOTO Postgres Configuration for Web Services](https://tightlycoupled.io/my-goto-postgres-configuration-for-web-services/)
- Migrations run `SET role = owner` to run Migrations as `owner`, which owns the tables, check `lib/tasks/migration_hooks.rake`

Run:
```sh
sh db/setup.sh
```

Or to capture output to `output.log`:

```sh
sh db/setup.sh 2>&1 | tee -a output.log
```
Note that *Active Record Migrations* run `SET role = owner`, so that they run as the `owner` user. This user owns the tables. See: `lib/tasks/migration_hooks.rake`


## Clone the Repository

1. Install the Prerequisites
1. `cd` to your source code directory, e.g.: `~/Projects`
1. From there, clone the repo:
    - `git clone https://github.com/andyatkinson/rideshare.git`
1. `cd rideshare`


## Ruby Version

`cd` into Rideshare, and run `cat .ruby-version`. This is the Ruby version you'll install.

```sh
cat .ruby-version
3.2.2
```

Install the version that's listed:

- `rbenv install 3.2.2`

Run `rbenv versions` to confirm the version you've installed has an asterisk next to it. Do *not* use the `system` version.

You should see something like this:

```sh
rbenv versions
  system
* 3.2.2 (set by /Users/andy/Projects/rideshare/.ruby-version)
```

Running `ruby -v` or `which ruby` should also show the expected version:

```sh
ruby -v
ruby 3.2.2 (2023-03-30 revision e51014f9c0) [x86_64-darwin22]

which ruby
/Users/andy/.rbenv/shims/ruby
```

Review *Learn how to load rbenv in your shell.* using [`rbenv init`](https://github.com/rbenv/rbenv) if the version isn't correct.

## Bundler and Gems

With Ruby installed, you're ready to install [Bundler](https://bundler.io). To do that, run:

- `gem install bundler`

With Bundler installed, from Rideshare, run:

- `bundle install`

You should now have all Rideshare gems installed.

## Rideshare development database

Normally in Rails, you'd run `bin/rails db:create` to create databases. Rideshare has a custom setup.

Before running the script, create a unique secure password for database users. If you've already set it, retrieve the value from `~/.pgpass`.

For first-time creation, on macOS run the following command:

```sh
export RIDESHARE_DB_PASSWORD=$(openssl rand -hex 12)
```
You've now set `RIDESHARE_DB_PASSWORD` with a secure password. Or fetched the value you set earlier from `~/.pgpass`.

The value will be something like `2C6uw3LprgUMwSLQ`.

Find or create the file `~/.pgpass`, by running `touch ~/.pgpass`.

Populate the file following the sample in: `postgresql/.pgpass.sample`. For example:

```sh
localhost:5432:rideshare_development:owner:2C6uw3LprgUMwSLQ
```

With `RIDESHARE_DB_PASSWORD` set, you're ready to run the custom database creation and setup script.

From your terminal in the Rideshare directory, run:

```sh
sh db/setup.sh
```

Great. Once this completes, run `psql $DATABASE_URL`. From psql:

- Run `SELECT current_user;`. Confirm that you're connected as `owner`.
- Run`\dn`. Confirm the `rideshare` `schema` is visible.

## Run Migrations

Run pending migrations by running the following command from your terminal:

```sh
bin/rails db:migrate
```

If tables are created successfully, your development environment is ready to go!


# Development Guides and Documentation

In addition to this file, the [Development Guides](https://github.com/andyatkinson/development_guides) go into greater depth for preparing your development machine.

In that repo, you'll also find out about additional software to install that's not necessary now, but used for examples and exercises in later chapters of the book.

For Guides and tasks, check out: [Guides](GUIDES.md)

For PostgreSQL guidance, check out: [postgresql/README.md](postgresql/README.md)

For database scripts, check out: [db/scripts/README.md](db/scripts/README.md)

To testing details for Rideshare, check out: [TESTING.md](TESTING.md)

# UI

Although Rideshare is an *API-only* app, there are some UI elements.

Rideshare runs [PgHero](https://github.com/ankane/pghero) which has a UI.

* Run `bin/rails server`
* Navigate to <http://localhost:3000/pghero>

![Screenshot of PgHero for Rideshare](https://i.imgur.com/VduvxSK.png)
