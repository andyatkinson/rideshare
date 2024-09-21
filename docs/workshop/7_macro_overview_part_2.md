# Macro Query Optimization Part 2

In this section, we'll begin to work with multiple PostgreSQL instances.

Remember this hierarchy:
```
__________________________________________________________________
|
|--Instance (the server) (localhost, db01, db02, etc.)
|
|----Cluster (*all databases*, e.g. postgres, rideshare_development)
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
- Create a docker network (`rideshare-net`) the containers can use
- Run the script to start the `db01` container
- Run the script to start the `db02` container
- Verify they're running with `docker ps`

```sh
# Clean-up from past runs:
cd docker
rm postgresql.conf
rm -rf postgres-docker/

# Starting point:
docker network create rideshare-net
sh run_db_db01_primary.sh
sh run_db_db02_replica.sh
```

Let's configure them.

## Part 2: Enabling Physical Replication
Prep: Remove annoying Docker messages:
```sh
export DOCKER_CLI_HINTS=false
```

- `db01` and `db02` are now running. Review the network, host names, basics of connection to each instance.

```sh
docker ps
```

- We're running two instances of Postgres in containers, simulating two different hosts

Go to the `docker` directory and run `sh reset_docker_instances.sh`.

If you're missing `postgresql.conf`, you'll be prompted to create it.


```sh
cd docker

sh reset_docker_instances.sh
```

Follow the commands to copy down `postgresql.conf`.

Edit the settings `wal_level = logical` and save the changes. The script copies postgresql.conf to db01.

Run the command again to do that:

```sh
sh reset_docker_instances.sh
```

Let's walk through the highlights:
- Replaced postgresql.conf config file on db01
- Created replication slot on primary db01
- Created `replication_user` user on db01 with a unique password and permissions
- Created `pg_hba.conf` on db01 to allow access
- Placed password in `.pgpass` and copied to db01 and db02 for `replication_user`
- Restarted db01

Check logs on db02:
```sh
docker logs -f db02
```

Initially system identifier won't be the same:
```sh
docker exec --user postgres -it db01 \
    psql -c "SELECT system_identifier FROM pg_control_system();"

docker exec --user postgres -it db02 \
    psql -c "SELECT system_identifier FROM pg_control_system();"
```

We'll need to turn the db02 instance into a physical copy of db01.

To do that, we'll replace the data directory on db02 with a copy of db01,
where it will then be kept in sync.

## Part 3: Run `pg_basebackup`
Now we have the two instances configured, and db02 can reach db01.

We need to turn db02 into a read replica, by running `pg_basebackup` on it.

To do that, open the file `run_pg_basebackup.sh` in the docker directory, but don't run it as a script.

Instead, this file is a reference of individual commands. Copy and paste each one into db02.

💻 Do that now!

After running the main `pg_basebackup` command as demonstrated, a success message looks like this:

```sh
pg_basebackup: base backup completed
```

The container will exit. You'll want to start it again using `docker start db02`.

<details>
<summary>🎥 Rideshare - PostgreSQL physical replication with Docker containers</summary>
<div>
<a href="https://www.loom.com/share/6fb372b9f09d41b59692cf4de44441d8">
  <img style="max-width:300px;" src="https://cdn.loom.com/sessions/thumbnails/6fb372b9f09d41b59692cf4de44441d8-with-play.gif">
</a>
</div>
</details>


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

And on db02, something like this:
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
Check for connectivity from db02 to db01:
```sh
docker exec --user postgres -it db02 bin/bash

psql -U replication_user -h db01 -d postgres
```

Check for replication slot:
```sh
docker exec -it db01 psql -U postgres
\x
select * from pg_replication_slots;
```

If needed, remove the slot:
```sql
SELECT pg_drop_replication_slot('rideshare_slot');
```

To start over fully, completely remove the locally mapped data directory:
```sh
# Local volume for container data, remove this directory if starting over
rm -rf docker-postgres
```

Start over from the beginning.

## What's Next?
Visit [8 - Active Record Multi-DB Part 1](/docs/workshop/8_active_record_multi-db_prep_part_1.md) to continue.
