# Scrubbing

`rideshare.users` contains sensitive data in fields

The following scripts clone the table structured, and fill in rows from
the original table using either the exact column values, or scrubbed column
values for columns that have been classified as sensitive.

Compare rows before and after running the script.

## Run Scrubbing

```sh
cd db

sh scrubbing/scrubber.sh
```

## View Comments

Database comments can be used to record sensitive fields


```sh
sh db/list_table_comments.sh
```

## Batching

Review the batched UPDATE example procedure:

[scrub_batched_direct_updates.sql](scrub_batched_direct_updates.sql)
