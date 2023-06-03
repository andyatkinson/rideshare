[![CircleCI](https://circleci.com/gh/andyatkinson/rideshare.svg?style=svg)](https://circleci.com/gh/andyatkinson/rideshare)

# Rideshare

An example Rails API app. Past iterations building it are documented, and recommendations are given.

I made this app to model the well-known *Ride Sharing* domain. Along the way, there are opportunities to call out Rails Best Practices, patterns, and trade-offs.

There are also opportunities to demonstrate my personal style and recommendations.

## Goals

- Stay on `master`/`main` of Rails, modern Ruby versions
- Use PostgreSQL
- Run on Mac OS, use Homebrew


## Prerequisites

- Ruby 3.2 or whatever version is listed in `.ruby-version`
    - Use a Ruby version manager to install multiple versions
    - [rbenv](https://github.com/rbenv/rbenv) is recommended
- Bundler. After installing Ruby, run `gem install bundler`
- (optional) To generate a DB image [Install graphiz](https://voormedia.github.io/rails-erd/install.html)
    `brew install graphviz`


## Install

1. Install prerequisites. Ruby, Bundler, etc.
1. `cd` into your source code project directory, e.g. `~/Projects`
1. From there, run `git clone git@github.com:andyatkinson/rideshare.git`
1. Go in to that directory, `cd rideshare`

    You should now be in ~/Projects/rideshare. Since Bundler is installed, run `bundle install` to install all of the gems for Rideshare.

1. Once the gems are installed, create the database.

    ```sh
    bin/rails db:create:all
    rake test
    ```

1. You should now have development and test databases, e.g. `rideshare_development` and `rideshare_test`.
1. (Optional) To confirm everything is working, try running `bin/rails test` to run the test suite.

## Installation Guides

In addition to what's here, refer to the [Installation Guides](https://github.com/andyatkinson/installation_guides) repo for even more guidance.


## High Performance PostgreSQL for Rails

Although this was a side project started in 2019, in 2022 it took on new life as the basis for the book High Performance PostgreSQL for Rails.

In that book, Rideshare is used as a Rails application and PostgreSQL databases readers use as they work on exercises.

Going forward, Rideshare will continue to focus primarily on being a good app for the needs of the book.


