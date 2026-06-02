# Active Record Schema Migrations
How do we change our database schema design?

- Earlier we looked at Data Manipulation Language (DML), now we're switching into Data Definition Language (DDL).
- Postgres has loads of data types we declare upfront.
- Over time things change, we may need "bigger" data types, we may decide to change how something is stored
- We want to change the structure without having to stop the DB and incur downtime.

Systems evolve! Including the structure itself of your DB design! We want to "Always Be Shipping".....ideally "additive," (not destructive), nullable, non-blocking...changes. What does that mean?

Do safe things, don't do unsafe things. What does that mean?

Safe things:
- Adding new tables
- Adding new nullable columns
- Adding (and removing!) indexes outside of a transaction, i.e. using `concurrently`
- Detaching code from table or column references

Do good things:
- Use an appropriate data type
- Design for the needs you have today
- Get good at learning to evolve the schema into whatever shape you need, including migrating all the row data
- Always be shipping not only code changes, but schema design changes. Still do reviews, make it possible to roll back, but keep the process for new code and schema designs low friction.


Let's imagine we want to add a column `birthday_month smallint` to our users table. In SQL (from psql):
```sql
alter table users
add column birthday_month smallint;
```

We used the `smallint` data type, and we allowed null values.

Except in our Ruby on Rails application, developers typically control the schema design and they're used to using the ORM migrations mechanism: Active Record Migrations.

## Active Record Migrations components
- A "Generator" to generate a "Migration" file.
- Ruby "helpers" that are Ruby methods that perform SQL DDL.  This is optional. We can also pass in a multi-line string of SQL DDL.
- A `schema_migrations` table with a single `version` column

From a bash prompt:
```sh
rails generate migration AddBirthdayMonthToUsers
```

We'll get a new file:
```
invoke  active_record
create    db/migrate/20260527034321_add_birthday_month_to_users.rb
```

```rb
add_column :users, :birthday_month, :smallint
```

```sql
execute(%{
  alter table users
  add column birthday_month smallint
})
```

```rb
class AddBirthdayMonthToUsers < ActiveRecord::Migration[7.2]
  def change
    # add_column :users, :birthday_month, :smallint
    safety_assured do
      execute(%{
        alter table users
        add column if not exists birthday_month smallint
      })
    end
  end
end
```


We can see our version `20260527034321` was inserted into `schema_migrations`
```sql
INSERT INTO "schema_migrations" ("version") VALUES ('20260527034321') RETURNING "version"
```

See all migration versions for all of time:
```sql
select * from schema_migrations;
```

## Strong Migrations
Ruby on Rails does not try to enforce which migrations are "unsafe" to perform on busy production tables.

Enter "Strong Migrations," which fills in this gap, detecting unsafe patterns and prevent them or even auto-fixing them.
<https://github.com/ankane/strong_migrations>

A couple of classic examples of unsafe operations:
- Adding an index non-concurrently
- Adding a foreign key constraint (blocks writes on both tables)
- Adding a check constraint

What about when I know something is safe?

There is a mechanism to "opt out" by wrapping in a Ruby block:
```rb
safety_assured do
end
```

Let's review examples of unsafe DDL changes on busy tables, and briefly introduce lock types.

We want to avoid operations that hold heavyweight locks (i.e. `access exclusive`) that also take a long period of time.

For heavyweight locks (as opposed to LW locks), we want to use "shared" locks and minimize their duration.


## Locks for a Bad Time
<https://pglocks.org/>

Vacuuming bad/good:
- Bad: `VACUUM FULL` on a table, AccessExclusiveLock (table), https://pglocks.org/?pgcommand=VACUUM%20FULL
- Good: `VACUUM` on a table, ShareUpdateExclusiveLock (table), most things can run (insert, update, delete)

Indexes bad/good:
- Bad: CREATE INDEX (without CONCURRENTLY) ShareLock (table), conflicts: insert, update, delete etc. (ouch!)
- Good: CREATE INDEX (CONCURRENTLY) ShareUpdateExclusiveLock (table)

## Presentation
Go to Presentation for lots of additional thoughts on Schema Changes


## Scaling With Multiple Instances
Visit [08 - Multiple Instances Macro Overview #2](/docs/workshop/08_macro_overview_part_2.md) to continue.
