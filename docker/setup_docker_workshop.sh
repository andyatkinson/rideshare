docker network inspect rideshare-net >/dev/null 2>&1 || docker network create rideshare-net

docker rm -f db01 >/dev/null 2>&1 && sh ./docker/run_db_db01_primary.sh
docker rm -f db02 >/dev/null 2>&1 && sh ./docker/run_db_db02_replica.sh
docker rm -f db03 >/dev/null 2>&1 && sh ./docker/run_db_db03_replica.sh

docker ps

export DOCKER_CLI_HINTS=false
