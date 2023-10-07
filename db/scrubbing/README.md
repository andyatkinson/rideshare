# Scrubbing

`rideshare.users` contains sensitive field data.

The following scripts replace the table, filled with non-sensitive
replacement rows.

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
