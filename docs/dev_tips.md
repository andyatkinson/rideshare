## Postgres versions

I had Homebrew Postgres set up in my path for `pg_dump` but wanted to use the version with Postgres.app.

Undesired version:
```
/opt/homebrew/opt/libpq/bin/pg_dump
```

Desired version:
```
/Applications/Postgres.app/Contents/Versions/18/bin/pg_dump
```

Since I use fish shell I fixed it by running:
```sh
set -U fish_user_paths /Applications/Postgres.app/Contents/Versions/18/bin $fish_user_paths
```

Verify:
```sh
pg_dump --version
```
