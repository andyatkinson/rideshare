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

### `.pg_pass`

* Remove `sample`
* Copy to `~/.pgpass`
* Edit the file with your specific credentials

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
