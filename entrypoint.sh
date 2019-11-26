#!/bin/bash

# Exit on fail
set -e

# Remove a potentially pre-existing server.pid for Rails.
if [ -f /app/tmp/pids/server.pid ]; then
  rm -f /app/tmp/pids/server.pid
fi

# Run pending migrations if any and start rails or run tests:

bundle exec rails db:migrate

# Examples:
#
# docker-compose -f docker-compose.dev.yml run web
# docker-compose -f docker-compose.test.yml run test
