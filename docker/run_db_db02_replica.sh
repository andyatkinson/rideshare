#!/bin/bash
#
# Run from Rideshare dir
# Use bind dir: ./postgres-docker/db02
# network: "rideshare-net"
docker run \
  --name db02 \
  --volume ${PWD}/postgres-docker/db02:/var/lib/postgresql/data \
  --publish 54322:5432 \
  --env POSTGRES_USER=postgres \
  --env POSTGRES_PASSWORD=postgres \
  --net=rideshare-net \
  --detach postgres:16.1
