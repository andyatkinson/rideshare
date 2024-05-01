# Macro Query Optimization Part 2

In this section, we'll begin to work with multiple PostgreSQL instances.

Remember this hierarchy:
```
________________________________________________________
|
|--Instance (the server) (localhost, db01, db02, etc.)
|
|----Cluster (all databases, inc. rideshare_development)
|
|------Database (postgres, rideshare_development)
|
|--------Schema (public, rideshare)
|
--------------------------------------------------------
```

We'll run these using Docker. Start up Docker.

## Part 1: Docker PostgreSQL Containers
- Boot up Docker. There may be zero containers running. (`docker ps`)
- Docker containers are in `docker` directory. Read README: <https://github.com/andyatkinson/rideshare/blob/main/docker/README.md>
- Run the shell script to start up the `db01` container
- Run the shell script to start up the `db02` container
- Run `docker ps`

```sh
# Clean-up from past runs:
cd docker
rm postgresql.conf
rm -rf postgres-docker/

# Starting point:
cd rideshare
sh docker/run_db_db01_primary.sh
sh docker/run_db_db02_replica.sh
```

Let's configure them.

## Part 2: Enabling Physical Replication
- `db01` and `db02` are now running. Review the network, host names, basics of connection to each instance.

```sh
docker ps
docker network ls
```

- We're running two instances of Postgres in containers, simulating two different hosts
- We’re enabling "physical replication" between them. The other replication type is "Logical" which we're not doing, but is covered in the book.

Go to the `docker` directory and run `sh reset_docker_instances.sh`.

If you're missing `postgresql.conf` you'll be prompted to create it.

What the script does is copy it from `db01` to then edit it, and replace the original file.

Prep: Remove annoying Docker messages:
```sh
export DOCKER_CLI_HINTS=false
```

```sh
cd docker

sh reset_docker_instances.sh
```

Follow the commands to copy down `postgresql.conf`.

Edit the file setting `wal_level = "logical"` and save your changes. The scripts will copy the file back.

Run the command again:

```sh
sh reset_docker_instances.sh
```

Let's walk through the highlights:
- Replaced config file changes on db01
- Created replication slot on primary db01
- Created user `replication_user` on db01 with a unique password, and permissions
- Created `pg_hba.conf` on db01
- Placed password in the `.pgpass` and copied to db01, to run commands as `replication_user`
- Restarted db01

Check logs on db02:
```sh
docker logs -f db02
```

Look for error:
```
FATAL:  database system identifier differs between the primary and standby
```

We'll need to replace the data directory on db02.

## Part 3: Run `pg_basebackup`
Now we have the two instances configured, and db02 can reach db01.

We need to turn db02 into a read replica, by running `pg_basebackup` on it.

To do that, open the file `run_pg_basebackup.sh` in the docker directory, but don't run it as a shell script.

This file is a reference to copy individual commands from.

After running the main `pg_basebackup` command as demonstrated, a success message looks like this:

```sh
pg_basebackup: base backup completed
```

If everything works, you'll have replication enabled between both instances with a `replication_user` user,
and a replication slow.

```sh
pg_basebackup: initiating base backup, waiting for checkpoint to complete
pg_basebackup: checkpoint completed
pg_basebackup: write-ahead log start point: 0/5000028 on timeline 1
pg_basebackup: starting background WAL receiver
31481/31481 kB (100%), 1/1 tablespace
pg_basebackup: write-ahead log end point: 0/5000100
pg_basebackup: waiting for background process to finish streaming ...
pg_basebackup: syncing data to disk ...
pg_basebackup: renaming backup_manifest.tmp to backup_manifest
pg_basebackup: base backup completed
```

And on db02:
```
2024-05-01 02:07:18.636 UTC [30] LOG:  entering standby mode
2024-05-01 02:07:18.641 UTC [30] LOG:  redo starts at 0/6000028
2024-05-01 02:07:18.641 UTC [30] LOG:  consistent recovery state reached at 0/6000138
2024-05-01 02:07:18.641 UTC [1] LOG:  database system is ready to accept read-only connections
2024-05-01 02:07:18.648 UTC [31] LOG:  started streaming WAL from primary at 0/7000000 on timeline 1
```


## Conclusion
That concludes the basics of setting up a replica instance.

In the next section we'll continue with adding content, then layer on application-level configuration.


## Appendix: Debugging and Troubleshooting
Remove locally mapped data directory entirely and start over:
```sh
# Local volume for container data, remove this directory if starting over
rm -rf docker-postgres
```

For a fatal error, we can recreate the standby:
```sh
FATAL:  database system identifier differs between the primary and standby

docker stop db02 && docker rm db02
cd docker
sh run_db_db02_replica.sh
sh pg_hba_reset.sh

echo "Copy .pgpass, chown, chmod it for db02"
# Copy .pgpass to db02 postgres home dir
docker cp .pgpass db02:/var/lib/postgresql/.
docker exec --user root -it db02 chown postgres:root /var/lib/postgresql/.pgpass
docker exec --user root -it db02 chmod 0600 /var/lib/postgresql/.pgpass

# Check for connectivity
docker exec --user postgres -it db02 /bin/bash
psql -U replication_user -h db01 -d postgres
```

Check for replication slot:
```sh
docker exec -it db01 psql -U postgres
\x
select * from pg_replication_slots;
```

Connection from db02 to db01:
```sh
postgres@db02:/$ psql -U replication_user -h db01 -d postgres
```

## What's Next?
Visit [8 - Active Record Multi-DB Part 1](/docs/workshop/8_active_record_multi-db_prep_part_1.md) to continue.
