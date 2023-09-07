## My Rails Best Practices and Patterns

Demonstrations of each of these items can be found in the app

* Data Integrity (in the DB and application)
  * Enforce Null Constraints
    * Foreign key constraints for referential integrity
    * Unique constraints
    * Exclusion
* Code Quality
  * Rails best practices gem (`bin/rails_best_practices .`)
  * Strong Migrations
  * Use `delegate` in models
  * Strong Params
* Performance
  * DB indexes
    * Primary, uniqueness, indexed foreign key columns
* Named Scopes
* Search functionality
* Automatic Geocoding
  * Use callbacks
  * Disable geocoding in the test environment
* Testing
  * Fixtures and factories
  * Minimum Code to Test Ratio: 1:0.6 (use `bin/rails stats`)
  * Fake data generators for local development (`faker` gem, rake task), SQL data loads
* API Application
  * We only need an API, use `ActionController::API` for lighter weight API code
  * Use `/api` namespace
  * JSON:API for API standardization
    * Sparse Fieldsets
    * Compound Documents
  * Status codes
  * `201` on created
  * `422` on error
  * HTTP Caching (ETag, Last Modified, static content)
* Use [Single table inheritence](https://api.rubyonrails.org/v6.0.1/classes/ActiveRecord/Base.html#class-ActiveRecord::Base-label-Single+table+inheritance) when appropriate
  * Link: [DB migration commit](https://github.com/andyatkinson/rideshare/commit/39232da339c2c04966e49e3e4ff03d88c2e66842#diff-7d736cc988a61ff29b4b9b2466b7a6ab)
