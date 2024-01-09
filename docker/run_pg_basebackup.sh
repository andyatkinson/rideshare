# Connect to db02 as "postgres"
# replication_user - authenticates from db02 host
docker exec --user postgres -it db02 /bin/bash

# ############# WARNING ############
#
# Copy the "rm" and "pg_basebackup" commands
# to clipboard at once, so they can be pasted together
#
# Dependencies:
# - "rideshare_slot" exists
# - replication_user exists, with password supplied from ~/.pgpass
# - db01 and db02 are running
#
# ##################################
rm -rf /var/lib/postgresql/data/* && \

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
