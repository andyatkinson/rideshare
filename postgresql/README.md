# PostgreSQL

Remove `sample` from the file name

### `postgresql.conf`

* Remove `sample` from filename

### `pg_hba.conf`

* Remove `sample` from filename

### `.pg_service.conf`

* Remove `sample`
* Copy to `~/.pg_service.conf`
* Edit the service info with your config

### `~/.pgpass`

* Remove `sample` from the sample file
* Copy file content to `~/.pgpass` (scripts will populate it as well)
* Edit the file with your specific credentials
* Perform the following changes:

```sh
chown <user>:<group> /home/dir/.pgpass
chmod 0600 /home/dir/.pgpass
```

Replace `/home/dir` with the path to the home directory of the user.

On PostgreSQL docker containers, that's `/var/lib/postgresql/`

For user and group on PostgreSQL docker containers, the user is `postgres` and the group is `root`

### `.psqlrc`

* Remove `sample`
* Copy to `~/.psqlrc`

### PgBouncer

> The mode that results in a more sane balance of improved concurrency and retained critical database features is transaction mode.
From: [PgBouncer is useful, important, and fraught with peril](https://jpcamara.com/2023/04/12/pgbouncer-is-useful.html)

* For 1.21.0, recommend `transaction` pool mode (compatible with multi-statement transactions)
* For macOS, install with Homebrew
* Copy changes from `pgbouncer.sample.ini` file
* Restart with `brew services restart pgbouncer`
