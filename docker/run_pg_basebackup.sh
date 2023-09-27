#!/bin/bash
#
# --write-recovery-conf
# will create a file in PG_DATA standby.signal
# and place connection info in
# postgresql.auto.conf. Restarting
# it starts in recovery mode
#
# Expects $DB_PASSWORD to be set
#
# Use a unique/new directory for --pgdata
#
docker exec -it db02 \
  pg_basebackup \
  --host db01 \
  --pgdata $PGDATA \
  --username=replication_user \
  --slot rideshare_slot \
  --verbose \
  --progress \
  --wal-method stream \
  --write-recovery-conf
