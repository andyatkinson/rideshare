## Docker

### Restarting container

```sh
pg_ctl: cannot be run as root
```
docker restart <container>

### Creating replication_user


### Standby process

1. Create replication slot
1. Create pg_hba.conf entries for postgres or replication_user. Use the IP address for the docker container, and the /32 version (IPv4) [^1]
1. Figure out password authentication or use `trust` (local only)
1. Connect to standby, cd to $PGDATA, remove all content
1. Make sure there is a `standby.signal` file
1. Restart it (should restart in recovery mode)

[1]: <https://stackoverflow.com/questions/17996957/fe-sendauth-no-password-supplied>
