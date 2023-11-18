# Test Environment Installation

For development, you'll use some good practices in PostgreSQL like a custom app schema and app user, with reduced explicitly granted privileges.

For test environment, you'll keep it simpler.

Use the `postgres` superuser and the `public` schema. The test configuration is also used for Circle CI.

From the Rideshare directory, run:

1. `sh db/setup_test_database.sh`, which sets up `rideshare_test`
1. `bin/rails test`

Refer to `.circleci/config.yml` for the Circle CI config.

You should now have a test database, and tests should have passed.
