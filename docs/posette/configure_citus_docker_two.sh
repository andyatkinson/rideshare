#!/bin/bash
#
# Single node citus:
# https://docs.citusdata.com/en/v12.1/installation/single_node_docker.html
#
# export DOCKER_CLI_HINTS=false
#

# Configure Rideshare:
cd rideshare
export DOCKER_CLI_HINTS=false
export DB_URL="postgres://postgres:postgres@localhost:15001/postgres"
export RIDESHARE_DB_PASSWORD="HSnDDgFtyW9fyFI"

# sh db/setup.sh 2>&1 | tee -a citus.log
# psql:db/create_database.sql:3: NOTICE:  Citus partially supports CREATE DATABASE for distributed databases
# DETAIL:  Citus does not propagate CREATE DATABASE command to workers
# HINT:  You can manually create a database and its extensions on workers.
# CREATE DATABASE

docker exec -it citus psql -U postgres

\l
\c rideshare_development
\dx

SELECT * FROM citus_version();
