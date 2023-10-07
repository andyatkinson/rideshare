## Set Up Databases

```sh
sh db/setup.sh

sh db/setup_test_database.sh
```


## Set Database Connection

Use the readwrite `owner` role for schema modifications.

This is not a superuser role, although it does have write capabilities.

The password is supplied from `~/.pgpass`.

```sh
export DATABASE_URL="postgres://app:@localhost:5432/rideshare_development"
```

The `app` user cannot `TRUNCATE` tables.

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

## Local Circle CI

Inspired by [Issue #99](https://github.com/andyatkinson/rideshare/issues/99) from @momer.

Using this configuration, Circle CI can use its configuration and run locally.

Currently there is this error: "invalid UTS mode"

```sh
brew install circleci

circleci local execute -c process.yml build # works

circleci local execute -c process.yml test # error
```

## Rebuild the Data Dump

```sh

```

## Scrub a Unscrubbed Download

```sh
sh scrubbing/scrubber.sh
```

## Check for sensitive fields

Basic search of common field names, against flat list of columns.

