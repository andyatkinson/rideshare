## Set Database Connection

Use the readwrite "owner" role for schema modifications.

This is not a superuser role.

The password is supplied from `~/.pgpass`.

```sh
export DATABASE_URL="postgres://owner:@localhost:5432/rideshare_development"
```

## Teardown Databases

This is mostly useful for testing the "setup" automation. You wouldn't want to do this normally because you'd lose your data.

```sh
sh db/teardown.sh
```

## Generate Data

```sh
bin/rails db:reset

bin/rails data_generators:generate_all
```

## Simulate Activity

```sh
bin/rails server

bin/rails simulate:app_activity
```
