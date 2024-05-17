# Scrubbing

In this section, we're looking at how to scrub sensitive columns within data rows.

The examples assume you've started from a physical or logical copy of all rows for all tables. Only apply scrubbing for tables with sensitive data. For reference data tables that don't contain sensitive values, use the data as is.

For an example to work with, we'll use the `rideshare.users` table, and consider fields within the table to be sensitive. You'll work with this table, then take the tactics you learn to your database. Since the scrubbing is all done with standard PostgreSQL procedural language and shell scripts, this solution is portable.

The following scripts clone the table structure, without row data. The scripts fill in rows from
the original table and perform scrubbing on the fly. You'll also learn a basic mechanism to track which columns are sensitive, allowing you to maintain that information over time using your normal Rails Migrations process.

Compare rows before and after running the script.

## Run Scrubbing
```sh
cd db

sh scrubbing/scrubber.sh
```

## View Comments
Database comments are used to record which fields are sensitive.

```sh
sh db/list_table_comments.sh
```

## Batching
Review the batched `UPDATE` example:

[scrub_batched_direct_updates.sql](scrub_batched_direct_updates.sql)

For more information, please check out [High Performance PostgreSQL for Rails](https://pragprog.com/titles/aapsql/high-performance-postgresql-for-rails/), where this section is covered extensively in a full "Performance Database" chapter.
