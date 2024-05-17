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

## Rideshare and Workshop Loom Videos
<details>
<summary>🎥 Installation - Rideshare on a Mac, Ruby, PostgreSQL, Gems</summary>
    <div>
    <a href="https://www.loom.com/share/8bfc4e79758a42d39cead8f6637aa314">
    <img style="max-width:300px;" src="https://cdn.loom.com/sessions/thumbnails/8bfc4e79758a42d39cead8f6637aa314-1714771702452-with-play.gif">
    </a>
</div>
</details>

<details>
<summary>🎥 Rideshare DB setup. Common issues running db/setup.sh</summary>
<a href="https://www.loom.com/share/fc919520089c4e0abb2c0a02b68bbd91">
<img style="max-width:300px;" src="https://cdn.loom.com/sessions/thumbnails/fc919520089c4e0abb2c0a02b68bbd91-with-play.gif">
</a>
</div>
</details>

<details>
<summary>🎥 Rideshare - Loading data using a Rake task and Shell Script</summary>
<div>
<div>
<a href="https://www.loom.com/share/6a1419efae7b4c3aac51e7d95726baf0">
<img style="max-width:300px;" src="https://cdn.loom.com/sessions/thumbnails/6a1419efae7b4c3aac51e7d95726baf0-1714505177620-with-play.gif">
</a>
</div>
</details>

<details>
<summary>🎥 Configuring and using pg_stat_statements data, creating generic query exec plans</summary>
<div>
  <a href="https://www.loom.com/share/25a2903db92c48c5ad42bc1c49d4a8ee">
    <img style="max-width:300px;" src="https://cdn.loom.com/sessions/thumbnails/25a2903db92c48c5ad42bc1c49d4a8ee-1715978361702-with-play.gif">
  </a>
</div>
</details>

<details>
<summary>🎥 Rideshare - PostgreSQL physical replication with Docker containers</summary>
<div>
<a href="https://www.loom.com/share/6fb372b9f09d41b59692cf4de44441d8">
  <img style="max-width:300px;" src="https://cdn.loom.com/sessions/thumbnails/6fb372b9f09d41b59692cf4de44441d8-with-play.gif">
</a>
</div>
</details>


## Let's Get Started
In each section, you'll find links at the bottom to the next topic.

Click the [0 - Introduction](/docs/workshop/0_introduction.md) to get started.
