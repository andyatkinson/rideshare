# Scrubbing

In this section, we're looking at how to scrub sensitive columns within table rows.

The example assumes you've started from a physical or logical copy of rows, for all tables. You'll apply scrubbing only to columns that contain sensitive data, tracking which ones they are using a simple and maintainable system.

For an example to work with, you'll use the `rideshare.users` table. You'll consider a couple of the fields within `rideshare.users` to be sensitive. Since the scrubbing is all done with standard PostgreSQL procedural language, shell scripts, and without extensions or Ruby gems, this solution is portable to anywhere PostgreSQL is running.

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
