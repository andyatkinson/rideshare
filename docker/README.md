## Docker

### Restarting container
```sh
pg_ctl: cannot be run as root
```
docker restart <container>

### Replacing `pg_hba.conf` content
```sh
docker cp db01:/var/lib/postgresql/data/pg_hba.conf .
cp pg_hba.conf pg_hba.backup.conf

vim pg_hba.conf
host    replication     replication_user 172.19.0.3/32               md5

docker cp pg_hba.conf db01:/var/lib/postgresql/data/.

docker restart db01
```


### Standby process

1. Create replication slot
1. Create `pg_hba.conf` entries for replication_user. Use the IP address from db02 and db03 /32 version (IPv4)
1. Make sure there is a `standby.signal` file
1. Restart it (should restart in recovery mode)


### Docker permissions

- Run `chown` and `chmod` on the `.pgpass` file
- Use the `postgres` user

```sh
docker exec --user root -it db02 chown postgres:root /var/lib/postgresql/.pgpass
docker exec --user root -it db02 chmod 0600 /var/lib/postgresql/.pgpass
```
