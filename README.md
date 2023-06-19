[![CircleCI](https://circleci.com/gh/andyatkinson/rideshare.svg?style=svg)](https://circleci.com/gh/andyatkinson/rideshare)

# Rideshare

Rideshare is a Rails API only app, that simulates a portion of a Rideshare company's app.

Since it's an API only app, there is no user interface. Interact with the app via the Rails server, console, and command line programs.

Rideshare proudly runs on PostgreSQL. 🐘

## Local Development

To set up Rideshare yourself to develop on, please read the Prerequisites and Installation Steps sections below.

## Prerequisites

- Ruby `3.2.0` or whatever version is in `.ruby-version`
    - Use a Ruby version manager to install Ruby
    - [rbenv](https://github.com/rbenv/rbenv) is recommended
- Bundler. After installing Ruby, run `gem install bundler`
- (optional) To generate a DB image [Install graphiz](https://voormedia.github.io/rails-erd/install.html)
    `brew install graphviz`


## Installation Steps

1. Install the Prerequisites above.
1. `cd` in to your source code directory. Mine is `~/Projects`.
1. From there run `git clone https://github.com/andyatkinson/rideshare.git`
1. `cd rideshare`

    You're now in a directory like ~/Projects/rideshare.

    Since you installed Bundler earlier, and are running the Ruby version the project expects, you're ready to install the gems.

    To install all the Rideshare gems, run `bundle install`.

    If you run into errors, please open an Issue on this project. Errors are most common when installing gems with native dependencies like `pg`.

1. If all gems were installed successfully, you're ready to set up the database. Run the following commands from your terminal.

    ```sh
    bin/rails db:create:all
    rake test
    ```

1. You should now have development and test databases, `rideshare_development` and `rideshare_test`.

    You're done now, but if you want to do one more step, run tests to see if everything passes.

1. (Optional) Try running `bin/rails test` to run the full test suite. If it passes 100%, you're in good shape.

## Installation Guides

In addition to what's here, refer to the [Development Guides](https://github.com/andyatkinson/development_guides) for more Installation support.


## High Performance PostgreSQL for Rails

Although this was a side project started in 2019, in 2022 it took on new life as the basis for the book High Performance PostgreSQL for Rails.

In that book, Rideshare is used as a Rails application and PostgreSQL databases readers use as they work on exercises.

Going forward, Rideshare will continue to focus primarily on being a good app for the needs of the book.

