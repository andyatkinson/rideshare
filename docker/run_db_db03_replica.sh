#!/bin/bash
#
# db03 uses Logical Replication
#
docker run \
  --name db03 \
  --volume ${PWD}/postgres-docker/db03:/var/lib/postgresql/data \
  --publish 54323:5432 \
  --env POSTGRES_USER=postgres \
  --env POSTGRES_PASSWORD=postgres \
  --net=rideshare-net \
  --detach postgres:16.1
