#!/bin/bash
#
# Disable Query Logs if they're enabled
#
# Configure DATABASE_URL with password
# (can't read from ~/.pgpass), set port 6432
#
# Overwrite DATABASE_URL to use PgBouncer port
conn="postgres://owner:"
conn+="@localhost:6432/rideshare_development"
export DATABASE_URL="${conn}"

# Confirm prepared statements are initially empty
echo "List Prepared Statements results (empty to start):"
bin/rails runner "puts ActiveRecord::Base.connection.
  execute('SELECT * FROM pg_prepared_statements').values"

echo "Run a query to populate prepared statements:"
bin/rails runner "Trip.first"

# Check again
echo "List Prepared Statements results again:"
bin/rails runner "puts ActiveRecord::Base.connection.
  execute('SELECT * FROM pg_prepared_statements').values"
