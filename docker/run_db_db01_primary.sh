#!/bin/bash
#
# Run from Rideshare dir
# create a network "rideshare-net"
docker run \
  --name db01 \
  --volume ${PWD}/postgres-docker:/var/lib/postgresql/db01data \
  --publish 54321:5432 \
  --env POSTGRES_USER=postgres \
  --env POSTGRES_PASSWORD=postgres \
  --net=rideshare-net \
  --detach postgres:16
