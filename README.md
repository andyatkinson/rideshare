[![CircleCI](https://circleci.com/gh/andyatkinson/rideshare.svg?style=svg)](https://circleci.com/gh/andyatkinson/rideshare)

# Rideshare

An example Rails 6.0 API app, in iterations.

I made this app to demonstrate how I would model a well-known domain, ride sharing like Uber or Lyft. Along the way, there are opportunities to call out Rails Best Practices, Patterns, and design trade-offs. There are also opportunities to demonstrate my personal style and recommendations.

## My Rails Best Practices and Patterns

Demonstrations of each of these items can be found in the app

* Data Integrity (in the DB and application)
  * Enforce Nullability
    * Foreign key constraints for referential integrity
    * Unique constraints
* Code Quality
  * Rails best practices gem (`rails_best_practices .`)
  * Strong Migrations
  * Use `delegate` in models
  * Strong Params
* Performance
  * DB indexes
    * Primary, unique, foreign key columns
* Named Scopes
* Search functionality
* Automatic Geocoding
  * Use callbacks
  * Disable geocoding in the test environment
* Testing
  * Fixtures and factories
  * Test to code ratio of `0.6` (use `rake stats`)
  * Fake data generators for local development (`faker` gem, rake task)
* API Application
  * We only need an API, use `ActionController::API` for lighter weight API code
  * Use `/api` namespace
  * JSON API for API standardization
    * Sparse Fieldsets
    * Compound Documents
  * Status codes
  * `201` on created
  * `422` on error
  * HTTP Caching (ETag, Last Modified, static content)
* Use [Single table inheritence](https://api.rubyonrails.org/v6.0.1/classes/ActiveRecord/Base.html#class-ActiveRecord::Base-label-Single+table+inheritance) when appropriate
  * Link: [DB migration commit](https://github.com/andyatkinson/rideshare/commit/39232da339c2c04966e49e3e4ff03d88c2e66842#diff-7d736cc988a61ff29b4b9b2466b7a6ab)

## Maintenance

* `bundle update [gemname]` to update a particular gem
* `yarn upgrade` (may need to use `nvm use [version]` to switch to particular Node version)

## Iteration 14

Upgrade Rails 6.0->6.1

## Iteration 13

Add JSON Web Token support for authenticated API actions. More details TBD.

## Iteration 12

Plan out a public API. A rider's "my trips" API. Includes driver details, maybe additional information like my rating, average rating. Includes start and end location.
Use fast_jsonapi and some of the JSON API features, like sparse fieldsets and compound documents.

## Iteration 11

Introduce ETag HTTP caching to the trips API. `ETag` is content-based HTTP caching  built in to Rails. ETags can be strong or weak, weak ETags are used by default in Rails, and are identified with a `W/` on the front, e.g. `W/"02d4d6729566d6bb56f0aa9e644c8c93"`.

Collections (an `ActiveRecord::Relation`) are supported, although they will be covered here in the future, for now this uses a `trips#show` API as a demonstration.

Sending a curl request and asking for headers only, we can see an ETag as a response header, and a 200 status code.

Using that ETag value as a request header, for example below, if the content for this trip has not changed, we'll see a `304 Not Modified` response.

```
curl -I --header 'If-None-Match: W/"02d4d6729566d6bb56f0aa9e644c8c93"' localhost:3000/api/trips/1
```

We can open a console and updated this trip, e.g. `Trip.find(1).touch`, and then sending the same ETag, we'll see the trip is rendered again, and we get a 200 response as expected, since the content of the trip has changed (the `updated_at` timestamp was updated).

Another response header that `stale?` introduces (this header doesn't seem to appear with a regular `render`) is `Last-Modified`, e.g. as a header and value an example is `Last-Modified: Thu, 14 May 2020 01:42:08 GMT`.

Now we can create a curl request with the request header `If-Modified-Since` and this timestamp, e.g.

```
curl -i --header 'If-Modified-Since: Thu, 14 May 2020 01:42:08 GMT' localhost:3000/api/trips/1
```

And confirm that we receive a `304 Not Modified`. Updating the trip and sending an equivalent request responds with a `200`, which makes sense since the trip has been updated. And similarly, if we replace the timestamp value with the new value from the `Last-Modified`, we are back to getting a `304 Not Modified` response.


## Iteration 10

Use Circle CI as a CI system. Set it up so that pushes on master kick off a test test. The repo has a status badge indicating whether the tests are passing or not.

## Iteration 9

Add two great tools, [Strong Migrations](https://github.com/ankane/strong_migrations) and [Blazer](https://github.com/ankane/blazer). Strong Migrations ensures that migrations will be safe to run in production, avoiding known risky operations.

Blazer is a simple platform for doing data analysis and data pulls. We used this extensively at a previous job and allowed any team member with SQL experience to learn about the data, satisfying their own reporting needs, and served as a repository of knowledge about common operations-related data and queries.

I created a Driver and Rider dashboard here with some queries to look at Top Rated Drivers, and the most Active Riders.

<img src="https://i.imgur.com/JdEGWPr.png" alt="Driver and Rider Blazer dashboard" />

## Iteration 8

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


## Iteration 7

Dockerize the application. <https://docs.docker.com/compose/rails/>

* Change the `database.yml` and set the `host: db`
* Install `yarn`

### Docker Commands

* `docker-compose build`
* `docker-compose up`
* `docker-compose run web bundle exec rake db:create`
* `docker-compose run web bundle exec rake db:migrate`
* `docker-compose run web bundle exec rake data_generators:trips`

Now query for some data:

`curl http://localhost:3000/api/trips?start_location=New%20York&driver_name=Kasie`


## Iteration 6

Add integration and model tests for trip search. Add trip search by multiple dimensions (Driver name, Rider name, Location).

## Iteration 5

Generate sample Driver, Trip, Rider, and Rating data (`rake data_generators:trips`). Add basic Driver dashboard. Show driver stats.

<img src="https://i.ibb.co/KcgZTBM/driver-dashboard.png" alt="Driver dashboard"/>

## Iteration 4

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

## Iteration 3

* Trip model, created when a Driver accepts a Trip Request
* Ratings: Completed Trips can be rated


## Iteration 2

* Location (Geo coordinates) and Trip Request models
* API base controller
* Trip Requests `index` and `create` API endpoints


## Iteration 1

* Started with a [Design Document](/docs/design_document.md)
  * Wrote out use cases of Riders, Drivers etc.
  * Planning models, database tables, constraints, validations
    * Using single-table inheritance for Driver and Rider instances in a Users table
