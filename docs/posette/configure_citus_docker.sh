#!/bin/bash
#
# Single node citus:
# https://docs.citusdata.com/en/v12.1/installation/single_node_docker.html
#
# export DOCKER_CLI_HINTS=false
#
docker run \
  --name citus \
  --publish 15001:5432 \
  --volume ${PWD}/docker-pg-data-dir:/var/lib/postgresql/data \
  --env POSTGRES_USER=postgres \
  --env POSTGRES_PASSWORD=postgres \
  --detach \
  citusdata/citus:12.1.3

# Wait a moment
sleep 2

# verify it's running, and that Citus is installed:
PGPASSWORD=postgres psql -U postgres \
  -h localhost \
  -p 15001 \
  -d postgres \
  -c "SELECT * FROM citus_version();"
