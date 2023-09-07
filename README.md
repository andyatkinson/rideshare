[![CircleCI](https://circleci.com/gh/andyatkinson/rideshare.svg?style=svg)](https://circleci.com/gh/andyatkinson/rideshare)

# Rideshare

Rideshare is a Rails API-only app that implements a portion of a fictional Rideshare service.

## High Performance PostgreSQL for Rails

This repo started as a side project back in 2019 as a place to demonstrate good practices.

In 2022, it took on a new purpose as the Rails application for exercises and examples in the book [High Performance PostgreSQL for Rails](https://pgrailsbook.com).

Rideshare proudly runs on PostgreSQL. 🐘

## Local Development

To set up Rideshare for development, please read the Prerequisites and Installation Steps sections below.

## Prerequisites

For Rideshare, you'll need a working Ruby application environment and a PostgreSQL server to connect to.

- Ruby `3.2.2` (check `.ruby-version`)
    - Use a Ruby version manager like [rbenv](https://github.com/rbenv/rbenv)
- Bundler. After installing Ruby, run `gem install bundler`
- (optional) To generate a DB image [Install graphiz](https://voormedia.github.io/rails-erd/install.html)
    `brew install graphviz`

- `importmap-rails` does not require yarn, npm etc. <https://fly.io/ruby-dispatch/making-sense-of-rails-assets/>

## Installation Steps

1. Install the Prerequisites above.
1. `cd` in to your source code directory like: `~/Projects`.
1. From there clone the application with: `git clone https://github.com/andyatkinson/rideshare.git`
1. `cd rideshare`

    You're now in a directory like ~/Projects/rideshare.

    Since you installed Bundler earlier, and are running the Ruby version the project expects, you're ready to install the gems.

    To install all the Rideshare gems, run `bundle install`.

1. If all gems were installed successfully, you're ready to set up the database. Run the following commands from your terminal.

    You should have PostgreSQL 15 installed and your server should already be running. Create the databases for the application.

    ```sh
    bin/rails db:create
    ```

    Apply any pending migrations. Install graphviz if needed (see above).

    ```sh
    bin/rails db:migrate
    ```

1. You should now have development and test databases, `rideshare_development` and `rideshare_test`.

1. (Optional) Run `bin/rails test` to run the full test suite. If the suite passes 100%, you're in good shape.

## Development Guides

In addition to what's in this Readme, refer to the [Development Guides](https://github.com/andyatkinson/development_guides) for more Installation and Usage support.

## Data Load

To load a pre-made data dump, run the following script from the root directory:

```sh
sh scripts/reset_and_load_data_dump.sh
```
