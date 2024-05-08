# Workshop

Hello! This is meant to be a two hour long workshop, facilitated by Andrew Atkinson.

## Prerequisites
For prerequisites, you'll use the Rideshare app. Follow the instructions in the main [Rideshare README.md](/README.md) to fully set it up.

When you've installed the app, verify that:
- Running `bundle install` in the Rideshare directory installs all Ruby gems
- `sh db/setup.sh` ran and created the `rideshare_development` database, users, etc.
- `bin/rails db:migrate` run and created empty tables, indexes, etc.
- `bin/rails data_generators:generate_all` ran and created a base set of fake data

The workshop uses content from my book ["High Performance PostgreSQL for Rails"](https://andyatkinson.com/pgrailsbook).

For book references, check Chapters "7 - Query Performance &  8 - Optimized Indexes for Fast Retrieval" for the first half of the workshop.

Check Chapter "13 - Scaling with Replication and Sharding" for the second half of the workshop.

## Workshop Structure
- Two 1 hr. halves, with a short break
- Numbered files from 0 through 9, with "Sections" in the files
- Each section has runnable code in backticks blocks, that's expected to be run by participants, unless flagged as "instructor only"

## Support
As an independent consultant, your support is very meaningful!

If you'd like to support me financially, please consider [buying my book](https://andyatkinson.com/pgrailsbook) and telling your colleagues about it!

To get a discount, ask me about codes. Usually there are active discounts during events like conferences.

If your team needs help, please visit my [Consulting page](http://andyatkinson.com/consulting), where you can find information about what I offer and how to hire me.

## Let's Get Started
In each section, you'll find links at the bottom to the next topic.

Click the [0 - Introduction](/docs/workshop/0_introduction.md) to get started.
