# Workshop
Hello! This is a 2-3 hour workshop on Postgres and Ruby on Rails database features, facilitated by Andrew Atkinson.

The workshop uses content from my book ["High Performance PostgreSQL for Rails"](https://andyatkinson.com/pgrailsbook).

For book references, check Chapters "7 - Query Performance &  8 - Optimized Indexes for Fast Retrieval" for the first half of the workshop (original RailsConf 2024 version).

Check Chapter "13 - Scaling with Replication and Sharding" for the second half of the workshop. (original RailsConf 2024 version)

## Prerequisites
You'll need Docker. Ideally you're on Mac OS although other platforms that support Docker may work.

You'll work in this app/repo, Rideshare. Follow the instructions for the [Docker Dev Env](https://github.com/andyatkinson/rideshare/blob/main/README.md#docker-dev-env) in the main [Rideshare README.md](/README.md).

For that you'll use Docker & Docker Compose, running `docker compose up` to bring up the app and DB. You'll set up the schema, run migrations, enable `pg_stat_statements`, and populate data.

Besides the Dev Env, download/run the docker containers for the multi-DB sections. These are 3 additional instances (db01, db02, db03) that will be used as a primary and replicas. From the Rideshare root:
```sh
sh docker/setup_docker_workshop.sh
```

When everything above is up and running, you should be able to run `docker ps -a` and see something like:
```sh
andy@MacBookPro ~/P/rideshare (main)> docker ps -a
CONTAINER ID   IMAGE           COMMAND                  CREATED       STATUS         PORTS                                           NAMES
1375d841de1d   postgres:18.4   "docker-entrypoint.s…"   3 hours ago   Up 3 hours     0.0.0.0:54323->5432/tcp, [::]:54323->5432/tcp   db03
ea5e643b688d   postgres:18.4   "docker-entrypoint.s…"   3 hours ago   Up 3 hours     0.0.0.0:54322->5432/tcp, [::]:54322->5432/tcp   db02
8e29a5aedd84   postgres:18.4   "docker-entrypoint.s…"   3 hours ago   Up 3 hours     0.0.0.0:54321->5432/tcp, [::]:54321->5432/tcp   db01
a506f74a11d3   rideshare-app   "bash -c 'rm -f tmp/…"   3 hours ago   Up 2 seconds   0.0.0.0:3000->3000/tcp, [::]:3000->3000/tcp     rideshare-app-1
24a4749934c1   postgres:18.4   "docker-entrypoint.s…"   3 hours ago   Up 3 seconds   0.0.0.0:5432->5432/tcp, [::]:5432->5432/tcp     rideshare-db-1
```

This workshop is revised for PG Data Chicago 2026, adding a third section.

## Workshop (PG Data 2026)
3 hours in total, each section is 1 hour.
1. Training: SQL Performance Basics
1. Training: ActiveRecord ORM and Schema Evolution
1. Training: Scaling with Multiple Databases

## Workshop Structure (Original 2024 RailsConf version)
- Two 1 hr. halves, with a short break
- Numbered files from 0 through 9, with "Sections" in the files
- Each section has runnable code in backticks blocks, that's expected to be run by participants, unless flagged as "instructor only"

## Support
As an independent consultant, your support is very meaningful!

If you'd like to support me financially, please consider [buying my book](https://andyatkinson.com/pgrailsbook) and telling your colleagues about it!

To get a discount, ask me about codes. Usually there are active discounts during events like conferences.

If your team needs help, please visit my [Consulting page](http://andyatkinson.com/consulting), where you can find information about what I offer and how to hire me.

## Rideshare and Workshop Loom Videos (local non-Docker installation)
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

Click the [0 - Introduction](/docs/workshop/00_introduction.md) to get started.
