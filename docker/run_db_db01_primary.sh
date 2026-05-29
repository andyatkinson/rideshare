#!/bin/bash
#
# Run from Rideshare dir
# Use bind dir: ./postgres-docker/db01
# network: "rideshare-net"
docker run \
  --name db01 \
  --volume ./pg18_db01_data:/var/lib/postgresql/18/docker \
  --publish 54321:5432 \
  --env POSTGRES_USER=postgres \
  --env POSTGRES_PASSWORD=postgres \
  --net=rideshare-net \
  --detach postgres:18.4
