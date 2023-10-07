#!/bin/bash
#
# https://access.crunchydata.com/documentation/postgresql11/11.5/pgbench.html
#
# Tested on 16.0

echo "Running pgbench"
pgbench \
  --username owner \
  --protocol prepared \
  --time 10 \
  --jobs 2 \
  --client 2 \
  --no-vacuum \
  --file scripts/queries.sql \
  --report-per-command \
  rideshare_development
