# Connect to db02 as "postgres". Why?
# postgres - kicks off replication
# replication_user - authenticates for replication
docker exec --user postgres -it db02 /bin/bash

# Confirm ~/.rep_user_password is accessible
cat ~/.rep_user_password

# ~/.pgpass isn't working
# See issue #143: https://github.com/andyatkinson/rideshare/issues/143
# Used workaround: for the pg_basebackup process, and for ongoing authentication
# Use PGPASSWORD env var instead of ~/.pgpass
export PGPASSWORD=$(cat ~/.rep_user_password)
echo $PGPASSWORD

# ############# WARNING ############
#
# Copy the "rm" and "pg_basebackup" commands
# together as one, and paste them together
#
# pg_basebackup run immediately, before container stops
#
# This expects "rideshare_slot" to exist
# ##################################
rm -rf /var/lib/postgresql/data/*

pg_basebackup --host db01 \
  --username replication_user \
  --pgdata /var/lib/postgresql/data \
  --verbose \
  --progress \
  --wal-method stream \
  --write-recovery-conf \
  --slot=rideshare_slot

# Restart container
# (or `docker start` if stopped and needing to connect)
docker restart db02

# Review live logs
docker logs -f db02
