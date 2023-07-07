[![CircleCI](https://circleci.com/gh/andyatkinson/rideshare.svg?style=svg)](https://circleci.com/gh/andyatkinson/rideshare)

# Rideshare

Rideshare is a Rails API only app that simulates a portion of a fictional Rideshare company app.

Since it's an API only app, there is no user interface. You'll interact with the app via the Rails server, console, and command line programs.

Rideshare proudly runs on PostgreSQL. 🐘

## Local Development

To set up Rideshare for development, please read the Prerequisites and Installation Steps sections below.

## Prerequisites

For Rideshare, you'll need a working Ruby application environment and a PostgreSQL server to connect to.

- Ruby `3.2.0` or whatever version is in `.ruby-version`
    - Use a Ruby version manager to install Ruby
    - [rbenv](https://github.com/rbenv/rbenv) is recommended
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

    If you run into a gem installation error, please open an Issue. Errors when installing gems with native dependencies like `pg` are common.

1. If all gems were installed successfully, you're ready to set up the database. Run the following commands from your terminal.

    ```sh
    bin/rails db:create
    ```

1. You should now have development and test databases, `rideshare_development` and `rideshare_test`.

    Installation is now complete. If you want to confirm more things are working as expected, try running the test suite.

1. (Optional) Run `bin/rails test` to run the full test suite. If the suite passes 100%, you're in good shape.

## Installation Guides

In addition to what's in this Readme, refer to the [Development Guides](https://github.com/andyatkinson/development_guides) for more Installation and Usage support.

## High Performance PostgreSQL for Rails

This Rideshare repo started as a side project back in 2019 to share some good development practices and tools.

In 2022 it took on a new purpose as the Rails application to base exercises on for the book [High Performance PostgreSQL for Rails](https://pgrailsbook.com).

Going forward, Rideshare will exclusively focus on the needs of the book, and the original purpose will be retired.
