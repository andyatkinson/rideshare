# Connect to db02 as "postgres". Why?
# postgres - kicks off replication
# replication_user - authenticates for replication
# against db01
docker exec --user postgres -it db02 /bin/bash

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
