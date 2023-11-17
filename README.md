[![CircleCI](https://circleci.com/gh/andyatkinson/rideshare.svg?style=svg)](https://circleci.com/gh/andyatkinson/rideshare)

# Rideshare

Rideshare is a Rails *API-only* app that implements a portion of a fictional Ridesharing service.

# High Performance PostgreSQL for Rails

Rideshare is the Rails application for the book: [High Performance PostgreSQL for Rails](https://pgrailsbook.com).

# Installation
Prepare your development machine. Review the [Development Guides](https://github.com/andyatkinson/development_guides) repo to make sure your development machine has all dependencies installed.

## Homebrew Packages

First, install [Homebrew](https://brew.sh).

Using Homebrew, install these:

- `brew install graphviz`

## Ruby Version Manager

Before installing Ruby, install a *Ruby Version Manager*. The version manager makes it easy to manage multiple versions at once.

[rbenv](https://github.com/rbenv/rbenv) is recommended.
- Recommended method: [Basic Git Checkout installation](https://github.com/rbenv/rbenv#basic-git-checkout)

## PostgreSQL

- On macOS, [Postgres.app](https://postgresapp.com) is recommended
    - Use PostgreSQL 16 (Released 2023)
    - *Note*: If you're happy with PostgreSQL installed via Homebrew, no need for `Postgres.app`

## Repository
Clone the repository and install the code.

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

Run pending migrations, by running the following command:

```sh
bin/rails db:migrate
```

If tables are created successfully, your development environment is ready to go!

# Test Environment Installation

For development, you'll use some good practices in PostgreSQL like a custom app schema and app user, with reduced explicitly granted privileges.

For test environment, you'll keep it simpler.

Use the `postgres` superuser and the `public` schema. The test configuration is also used for Circle CI.

From the Rideshare directory, run:

1. `sh db/setup_test_database.sh`, which sets up `rideshare_test`
1. `bin/rails test`

Refer to `.circleci/config.yml` for the Circle CI config.

You should now have a test database, and tests should have passed.

# Development Guides

In addition to this file, the [Development Guides](https://github.com/andyatkinson/development_guides) go into greater depth for preparing your development machine.

For Guides specific to this repo, check [Guides](/GUIDES.md).

# UI

Although Rideshare is an *API-only* app, there are some UI elements.

Rideshare runs [PgHero](https://github.com/ankane/pghero) which has a UI.

* Run `bin/rails server`
* Navigate to <http://localhost:3000/pghero>

![Screenshot of PgHero for Rideshare](https://i.imgur.com/VduvxSK.png)

# Databases

- PostgreSQL configuration follows [My GOTO Postgres Configuration for Web Services](https://tightlycoupled.io/my-goto-postgres-configuration-for-web-services/)
- Review SQL scripts in the `db` directory

# UI

Note: Front-end technologies were removed because this is an *API-only* app.

- `importmap-rails` does not require yarn, npm etc. <https://fly.io/ruby-dispatch/making-sense-of-rails-assets/>
