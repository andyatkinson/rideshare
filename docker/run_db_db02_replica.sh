#!/bin/bash
#
docker run \
  --name db02 \
  --volume ${PWD}/postgres-docker:/var/lib/postgresql/data \
  --publish 54322:5432 \
  --env POSTGRES_USER=postgres \
  --env POSTGRES_PASSWORD=postgres \
  --net=rideshare-net \
  --detach postgres:16
