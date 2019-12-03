[![CircleCI](https://circleci.com/gh/andyatkinson/rideshare.svg?style=svg)](https://circleci.com/gh/andyatkinson/rideshare)

# Rideshare

An exemplary Rails 6.0 API app, in iterations

### Rails Best Practices and choices

* Data Integrity (in the DB)
  * Enforce Nullability
  * Foreign key constraints for referential integrity
  * Unique constraints
* Code Quality
  * Rails best practices
  * Strong Migrations
* Named Scopes
* Search functionality
* Automatic Geocoding
  * Use callbacks
  * Disable in test environment
* Fixtures
* Strong Params
* API Application
  * We only need an API, use `ActionController::API` for lighter weight API code
  * Use `/api` namespace
  * Status codes
    * `201` on created
    * `422` on error
* Use [Single table inheritence](https://api.rubyonrails.org/v6.0.1/classes/ActiveRecord/Base.html#class-ActiveRecord::Base-label-Single+table+inheritance) [DB migration commit](https://github.com/andyatkinson/rideshare/commit/39232da339c2c04966e49e3e4ff03d88c2e66842#diff-7d736cc988a61ff29b4b9b2466b7a6ab)

### Iteration 10

Use Circle CI as a CI system.

### Iteration 9

Add two great tools, Strong Migrations and Blazer. Strong Migrations ensures that migrations will be safe to run in production, and avoid risky operations.

Blazer is a simple platform for doing data analysis and data pulls. We used this extensively at a previous job and it let anyone with SQL knowledge learn about the data, serving their own reporting interests, and served as a repository of knowledge about common operations queries.

I created a Driver and Rider dashboard here with some queries to look at Top rated drivers, and the most active Riders.

<img src="https://i.imgur.com/JdEGWPr.png" alt="Driver and Rider Blazer dashboard" />

### Iteration 8

Improve test code coverage and maintain a `1:0.6` code to test ratio.

`rake stats`

```
 Code LOC: 198     Test LOC: 115     Code to Test Ratio: 1:0.6
```

Put together a [Trip Search Sequence Diagram](https://www.planttext.com/).

```
@startuml

title "Trip Search Sequence Diagram"

actor User
boundary "TripSearch"

User -> TripSearch : Search by start location, driver name, rider name
TripSearch -> User : Respond with matching Trips

@enduml
```

<img src="https://www.plantuml.com/plantuml/img/JOyz3iCm24PtJe4ofnV8K6Ne2Vfp06AZ12csKqnQvVPrdLRj10BU-qIVZTJMC0EOsCpON5KMl32fcqgvhnmTuqbeL0eD03bBYhVC2aDQeoVTTcP7oiLxXuSZ_eROVON3XZKGv-J89CKMlSgZ0942jwZYFptyuKLMfHsUEIyfUdoAJHZ8t2Hnh4aPeEVeooSl" alt="Trip search" />


### Iteration 7

Dockerize the application. <https://docs.docker.com/compose/rails/>

* Change the `database.yml` and set the `host: db`
* Install `yarn`

#### Docker Commands

* `docker-compose build`
* `docker-compose up`
* `docker-compose run web bundle exec rake db:create`
* `docker-compose run web bundle exec rake db:migrate`
* `docker-compose run web bundle exec rake data_generators:trips`

Now query for some data:

`curl http://localhost:3000/api/trips?start_location=New%20York&driver_name=Kasie`


### Iteration 6

Add integration and model tests for trip search. Add trip search by multiple dimensions (Driver name, rider name, location).

### Iteration 5

Generate sample Driver, Trip, Rider, and Rating data. Add basic Driver dashboard. Show driver stats.

<img src="https://i.ibb.co/KcgZTBM/driver-dashboard.png" alt="Driver dashboard"/>

### Iteration 4

UML Sequence Diagram of Rider, Driver, Trip Request, Trip, and Rating messages

```
@startuml

title "Rider, Driver, Trip Sequence Diagram"

actor Rider
boundary "TripRequest"
actor Driver
entity Trip

Rider -> Rider : Enters Start and End Location
Rider -> TripRequest : Requests Trip
Driver -> TripRequest : Accepts Trip Request
TripRequest -> Trip : Trip Starts
Trip -> Trip : Trip Ends
Rider -> Trip : Rider Rates Trip

@enduml
```

<img src="https://www.plantuml.com/plantuml/img/PP0v3i8m44NxESKeDLo00WKfT5G95nZi4RAKsC6U8ENsU4C4gBoz__tiDWXvMQOHG8oCZ4rlDFiTTjuyqtZrPiQ17mjRnTWPkdkQ6W1IuZnc66vkiPhyYasY-mG7QIfIYe1jx5zp7K2EuVvOydZ0inNs0OSaWsHrtD1uSOh4EFl1D_KnL6UXb9Px_gcJKZnNw1s1BL8J4IrlJGuX4xz7KIfyooIBlEv9k8f0orR77tq1" alt="Trips Sequence diagram">

### Iteration 3

* Trip model, when a Driver accepts a Trip Request
* Completed Trips can be rated


### Iteration 2

* Location (Geo coordinates) and Trip Request models
* API base controller
* Trip Requests index and create API endpoints


### Iteration 1

* Started with [Design Document](/docs/design_document.md)
  * Writing out use cases
  * Planning models, database tables, constraints, validations
    * Using single-table inheritance for Driver and Rider instances in a Users table
