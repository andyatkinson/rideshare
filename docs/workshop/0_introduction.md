# Introduction

## Prerequisites Checklist
You have Rideshare running:
- `rideshare_development` database is reachable
- `bin/rails console` works
- DB creation scripts ran
- Migrations ran (`bin/rails db:migrate`)

If any of these aren't completed, go back to the main [Workshop README](/docs/workshop/README.md)

## Setup
- Run shell scripts from Rideshare root directory
- Learn to add psql to your `bin/rails console` command-line tools
- Create indexes without Active Record

## Performance
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
Visit [1 - Psql Basics](/docs/workshop/1_psql_basics.md) to continue.
