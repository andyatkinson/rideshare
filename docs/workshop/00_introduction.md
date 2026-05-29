# Introduction

## Intro Checklist
Let's review what's set up to get started:
- `rideshare_development` database is reachable (recommended setup is via Docker)
- Migrations have ran on the instance (`docker compose exec -it app bin/rails db:migrate`)
- `rails console` works (`docker compose exec -it app bin/rails console`)
- DB data creation scripts have ran e.g. `Trip.count` (from `rails console`) returns 1000 records
- Let's check out the ERD: <https://github.com/andyatkinson/rideshare/blob/main/erd.pdf>
- [Rails + Postgres Architecture #1 Primary](https://github.com/andyatkinson/rideshare/blob/main/docs/rideshare_rails_postgres_architecture_1.svg)
- [Rails + Postgres Architecture #2 Primary + Replica](https://github.com/andyatkinson/rideshare/blob/main/docs/rideshare_rails_postgres_architecture_2.svg)

If you're missing any of these, go back to the main [Workshop README](/docs/workshop/README.md) and review the Dev Env setup steps first.

## Setup
What we're going to do:
- Run shell scripts in Rideshare (in root or `./docker` directories), e.g. `sh setup_docker_workshop.sh`
- Run SQL commands from the psql client, running within Docker
- Create indexes without Active Record and learn to use Active Record Migrations (if they're new to you)

## Postgres Database Performance
What we consider performance:
- We're going to start with individual query optimization, micro analysis
- We're going to expand to macro analysis of the system, and look to reduce system load

This is only a part of managing critical CPU, Memory, and IOPS resources, but it's a good start.

## Micro Optimization
- Benefit: Learn to read query execution plans and optimize a query
- Query planning insights, key data to study
- Index design basics, supporting a query
- More advanced index design

## Macro Optimization
- Benefit: Reduce system load, add headroom, improve reliability, distribute load to more instances
- Find worst performing queries

## Schema Change Management
- Using Active Record Migrations
- Safe and unsafe changes

## What's Next?
Visit [1 - Psql Basics](/docs/workshop/01_psql_basics.md) to continue.
