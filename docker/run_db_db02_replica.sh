#!/bin/bash
#
# Run from Rideshare dir
# Use bind dir: ./postgres-docker/db02
# network: "rideshare-net"
docker run \
  --name db02 \
  --volume ./pg18_db02_data:/var/lib/postgresql/18/docker \
  --publish 54322:5432 \
  --env POSTGRES_USER=postgres \
  --env POSTGRES_PASSWORD=postgres \
  --net=rideshare-net \
  --detach postgres:18.4
