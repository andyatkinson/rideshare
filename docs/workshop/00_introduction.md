# Introduction

## Prerequisites Checklist
You have Rideshare running:
- `rideshare_development` database is reachable
- Migrations ran (`rails db:migrate`)
- `rails console` works
- DB data creation scripts ran e.g. `Trip.count` returns 1000 records

If any of these aren't completed, go back to the main [Workshop README](/docs/workshop/README.md)

## Setup
- Run shell scripts from Rideshare root directory
- Learn to add psql to your `rails console` command-line tools
- Create indexes without Active Record

## Database Performance
- Individual query optimization (micro)
- Macro query optimization, reduce system load

# Micro Optimization
- Benefit: Lessen load on server
- Query planning basics
- Index design basics
- Index design more advanced

# Macro Optimization
- Benefit: Lessen load, distribute load
- Find worst performing queries
- Move read only queries to a read replica

## What's Next?
Visit [1 - Psql Basics](/docs/workshop/01_psql_basics.md) to continue.
