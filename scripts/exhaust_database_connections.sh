#!/bin/bash

# set max_connections to 3

query="SELECT pg_sleep(30)"

for run in {1..4}; do
  echo "running query ${query}. times: ${run}"
  psql \
    --dbname rideshare_development \
    -c "$query" & # separate processes
done
