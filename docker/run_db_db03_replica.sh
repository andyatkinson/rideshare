#!/bin/bash
#
# db03 uses Logical Replication
#
docker run \
  --name db03 \
  --volume ./pg18_db03_data:/var/lib/postgresql \
  --publish 54323:5432 \
  --env POSTGRES_USER=postgres \
  --env POSTGRES_PASSWORD=postgres \
  --net=rideshare-net \
  --detach postgres:18.4
