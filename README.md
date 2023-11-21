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

Normally in Rails, you'd run `bin/rails db:create`. In Rideshare you'll use a custom script.

Before running the script, you'll need to configure several environment variables. You'll create a secure password for the database users that get created.

These are the variables you'll set:

```sh
RIDESHARE_DB_PASSWORD
DB_URL
DATABASE_URL
```

If you're creating the roles for the first time, you can generate a password on macOS by running this command from your terminal:

```sh
export RIDESHARE_DB_PASSWORD=$(openssl rand -hex 12)
```
Once you've created a value for `RIDESHARE_DB_PASSWORD`, you'll set it in `~/.pgpass`. Refer to `postgresql/.pgpass.sample` for an example.

Find or create the file `~/.pgpass`, by running `touch ~/.pgpass`.

If you are running this later, then you can assign `RIDESHARE_DB_PASSWORD` to the existing password value you've set in `~/.pgpass`.

The content of `~/.pgpass` might look like below, and the last segment is the password.

```sh
localhost:5432:rideshare_development:owner:2C6uw3LprgUMwSLQ
```

Once you've set `RIDESHARE_DB_PASSWORD`, `DB_URL`, and `DATABASE_URL`, you're ready to run the database creation script.

To do that, run the following from your terminal:

```sh
sh db/setup.sh
```

If environment variables aren't populated, you'll be prompted to do that.

Once this completes, you'll have the database set up. Let's verify that you can connect. Run `psql $DATABASE_URL`. Once connected, run this from psql:

- `SELECT current_user;`. Confirm that you're connected as `owner`
- `\dn`. Confirm that the `rideshare` schema is visible

## Run Migrations

Run pending migrations by running the following command from your terminal:

```sh
bin/rails db:migrate
```

If tables are created successfully, your development environment is ready to go!


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
