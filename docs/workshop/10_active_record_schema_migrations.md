# Active Record Schema Migrations
How do we change our database schema design?

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
Ensuring safety in migrations
