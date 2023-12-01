#!/bin/bash

trap 'echo "An error occurred with command: $BASH_COMMAND";' ERR

docker stop db01 && docker rm db01
docker stop db02 && docker rm db02
docker stop db03 && docker rm db03
echo "Stopped containers, waiting a moment"
sleep 1
sh run_db_db01_primary.sh
sh run_db_db02_replica.sh
echo "Started containers"
docker ps
sleep 1
sh pg_hba_reset.sh
echo "Restart db01 received new file"
docker restart db01
sleep 2

echo "Create replication slot on db01"
sh db01_create_replication_slot.sh

echo "Configure replication_user"
sh db01_create_replication_user.sh

echo "Copy existing postgresql.conf to db01"
docker cp postgresql.conf db01:/var/lib/postgresql/data/.

echo "restart db01"
docker restart db01
