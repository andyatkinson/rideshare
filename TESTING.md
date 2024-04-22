# Test Environment Installation

In the development database, you'll use good practices like a custom schema and user, with reduced privileges.

For the test database, we'll keep things simpler. The `postgres` superuser is used along with the `public` schema.

This configuration is also used for Circle CI.

From the Rideshare directory, run:

1. `sh db/setup_test_database.sh`, which sets up `rideshare_test`
1. `bin/rails test`

Refer to `.circleci/config.yml` for the Circle CI config.

You should now have a test database, and tests should have passed.
