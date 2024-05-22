[![CircleCI](https://circleci.com/gh/andyatkinson/rideshare.svg?style=svg)](https://circleci.com/gh/andyatkinson/rideshare)

# 📚 High Performance PostgreSQL for Rails
Rideshare is the Rails application supporting the book "High Performance PostgreSQL for Rails" <http://pragprog.com/titles/aapsql>, published by Pragmatic Programmers in 2024. 

# Installation
Prepare your development machine.

<details>
<summary>🎥 Installation - Rideshare on a Mac, Ruby, PostgreSQL, Gems</summary>
<div>
  <a href="https://www.loom.com/share/8bfc4e79758a42d39cead8f6637aa314">
    <img style="max-width:300px;" src="https://cdn.loom.com/sessions/thumbnails/8bfc4e79758a42d39cead8f6637aa314-1714771702452-with-play.gif">
  </a>
</div>
</details>

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
PostgreSQL 16 or greater is required. Installation may be via Homebrew, although the recommended method is [Postgres.app](https://postgresapp.com)

### PostgresApp
- Once installed, from the Menu Bar app, choose "Open Postgres" then click the "+" icon to create a new PostgreSQL 16 server


## Ruby
Run `cat .ruby-version` from the Rideshare directory to find the needed version of Ruby.

For example, if `3.2.2` is listed, run:

```sh
rbenv install 3.2.2
```

Run `rbenv versions` to confirm the correct version is active. The current version has an asterisk.

```sh
  system
* 3.2.2 (set by /Users/andy/Projects/rideshare/.ruby-version)
```

Running into rbenv trouble? Review *Learn how to load rbenv in your shell* using [`rbenv init`](https://github.com/rbenv/rbenv).

## Bundler and Gems
Bundler is included when you install Ruby using Rbenv. You're ready to install the Ruby gems for Rideshare.

Run the following command from the Rideshare directory:

```sh
bundle install
```

## Rideshare Development Database
⚠️  This scripts expects PostgreSQL version 16. If you see syntax errors with underscore numbers like `10_000`, it's probably from using an older version that doesn't support that number style.

⚠️   Normally in Ruby on Rails applications, you'd run `bin/rails db:create` to create the development and test databases. Don't do that here. Rideshare uses a custom script.

The script is called [`db/setup.sh`](db/setup.sh). Don't run it yet. The video below shows common issues for this section.

<details>
<summary>🎥 Rideshare DB setup. Common issues running db/setup.sh</summary>
<a href="https://www.loom.com/share/fc919520089c4e0abb2c0a02b68bbd91">
  <img style="max-width:300px;" src="https://cdn.loom.com/sessions/thumbnails/fc919520089c4e0abb2c0a02b68bbd91-with-play.gif">
</a>
</div>
</details>

Before you run it, let's set some environment variables. Open the file `db/setup.sh` and read the comments at the top for more info about these env vars:

- `RIDESHARE_DB_PASSWORD`
- `DB_URL`

⚠️  The script generates a password value using `openssl`, assuming it's installed and available.

Once you've set values, before running the script, run `echo $RIDESHARE_DB_PASSWORD` (and `echo $DB_URL`) to make sure they're set.

Once both are set, you're ready to run the script.

Let's capture the output of the script. Use the command below to do that. The script output goes into `output.log` file so we can more easily review it for errors.

```sh
sh db/setup.sh 2>&1 | tee -a output.log
```

Since you set `RIDESHARE_DB_PASSWORD` earlier, create or update the special `~/.pgpass` file with the password you generated.
This allows us to put the PostgreSQL user in the connection string, without needing to also supply the password.

Refer to `postgresql/.pgpass.sample` for an example, and copy the example into your own `~/.pgpass` file, replacing the password with your generated one.

When you've updated `~/.pgpass`, it should look like the line below. The last segment (`2C6uw3LprgUMwSLQ` below) is the password you generated.

```sh
localhost:5432:rideshare_development:owner:2C6uw3LprgUMwSLQ
```

Run `chmod 0600 ~/.pgpass` to change the file mode (permissions).

Finally, run `export DATABASE_URL=<value from .env>`, getting the value from the `.env` file in this project, set as the value of the `DATABASE_URL` environment variable.

Confirm that's a non-empty value by running `echo $DATABASE_URL`.

Once `DATABASE_URL` is set, we'll use it as an argument to `psql` to connect to the database. Run `psql $DATABASE_URL` to do that.

Once connected, you're good to go. If you'd like to do more checks, expand the checks and run through them below.

<details open>

<summary>Installation Checks</summary>

From within psql, run this:

```sql
SELECT current_user;
```

Confirm user `owner` is displayed.

```sql
owner@localhost:5432 rideshare_development# select current_user;
 current_user
 --------------
  owner
```

From psql, run the *describe namespace* meta-command:

```sql
\dn
```

Verify the `rideshare` schema is displayed.

```sql
owner@localhost:5432 rideshare_development# \dn
  List of schemas
   Name    | Owner
-----------+-------
 rideshare | owner
```

Now that you've confirmed the `owner` user and the `rideshare` schema have been set up correctly, you can run the migrations to create Rideshare's tables.
</details>


## Run Migrations
Run migrations the standard way:

```sh
bin/rails db:migrate
```

Run the *describe table* meta command next: `\dt`. Rideshare tables like `users`, `trips` are listed.

Note that migrations are preceded by the command `SET role = owner`, so they're run with `owner` as the owner of database objects.

See `lib/tasks/migration_hooks.rake` for more details.

If migrations ran successfully, you're good to go!

## Data Loads
To load some sample data, check out: [db/README.md](db/README.md)


# Development Guides and Documentation

## Troubleshooting
The Rideshare repository has many `README.md` files within subdirectories. Run `find . -name 'README.md'` to see them all.

- For expanded installation and troubleshooting, visit: [Development Guides](https://github.com/andyatkinson/development_guides)
- For DB things: [db/README.md](db/README.md)
- For database scripts: [db/scripts/README.md](db/scripts/README.md)
- For PostgreSQL things: [postgresql/README.md](postgresql/README.md)
- For Docker things: [docker/README.md](docker/README.md)
- For DB scrubbing: [db/scrubbing/README.md](db/scrubbing/README.md)
- For test environment details in Rideshare, check out: [TESTING.md](TESTING.md)
- For Guides and Tasks in this repo, check out: [Guides](GUIDES.md)

# User Interfaces
Although Rideshare is an *API-only* app, there are some UI elements.

Rideshare runs [PgHero](https://github.com/ankane/pghero) which has a UI.

Connect to it:

```sh
bin/rails server
```

Once that's running, visit <http://localhost:3000/pghero> in your browser to see it.

![Screenshot of PgHero for Rideshare](https://i.imgur.com/VduvxSK.png)
