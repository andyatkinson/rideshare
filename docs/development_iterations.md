# Development Iterations

Development was done in small iterations over time, and the work was tracked here.

Consider this a development journal that's a "build in public" that may be interesting to others, although it was mostly written for my own needs as journal.


## Iteration 27

Partition the `trip_positions` table using `pgslice`.

* Add `pgslice` to Gemfile and install the binstub

```sh
# add 'pgslice` to Gemfile
bundle install
bundle binstubs pgslice
```
Invoke it with `rails runner`, e.g. `bin/rails runner "PgsliceHelper.new.add_partitions"`

TODO, but deferred

* `insert_all` compatibility

## Iteration 26 (2023)

- Remove webpacker, and most front-end JS (this is an API app)
- Retire Blazer. It's a great tool, but no longer part of the goal of this app.

```sh
gem update --system
brew upgrade ruby-build
rbenv install 3.2.0
gem install bundler
bundle install
bundle update
bin/rails test
```

## Iteration 25

Add Full Text Search (FTS). Add `pg_search` to evaluate the features.

- tsearch - Full text search, which is built-in to PostgreSQL
- trigram - Trigram search, which requires the trigram extension
- dmetaphone - Double Metaphone search, which requires the fuzzystrmatch extension

## Iteration 24

Add slow query logging using Active Support Instrumentation without 3rd party gems or PostgreSQL extensions

When configured to log at >= 1 second duration, test it with:

```rb
ActiveRecord::Base.connection.execute("select pg_sleep(1)")
```

## Iteration 23

- Add Trip Position model, and populate it with sample rows
- Remove some experimental PG extensions from the application DB
- Perform a conversion from unpartitioned to partitioned trip_positions table using pgslice

`drop extension sslinfo`, `drop extension pg_buffercache` for now, these
may return later. This cleans up the `db/structure.sql` so that it reflects
the extensions in use by the application.

## Iteration 22

- Maintain the data generators
- Disable Prepared Statements for now
- Start using Active Record Doctor gem: `bundle exec rake active_record_doctor` for more insights

## Iteration 21

Trip rating database CHECK constraint.

## Iteration 20

Counter cache example for trips that belong to a driver.

## Iteration 19

Vehicle Reservation concept (e.g. special car, limo). Has a reservation duration.

When vehicle is reserved, cannot be overlapping reservation.

Create an exclusion constraint. Run a specific test like this:

`rails test test/services/book_reservation_test.rb -n BookReservationTest#test_can_NOT_book_overlapping_reservation`

## Iteration 18

Rails Entity Relationship Diagram (ERD)

[Customization](https://voormedia.github.io/rails-erd/customise.html)

```
bundle exec rake erd \
  inheritance=true \
  only="Driver,Rider,User,Location,TripRequest,Trip,Vehicle,VehicleReservation" \
  attributes=foreign_keys,primary_keys
```

## Iteration 17

Start a pgbench benchmark basics. Add fx gem to manage DB functions (pl/pgsql). Add data scrub functions.

Add paranoia gem and create some deleted users for the purposes of different query types.


## Iteration 16 (2022)

* Upgrade to Rails 7. Remove some gems.

## Iteration 15

* Add [PgHero](https://github.com/ankane/pghero)
* Use new CircleCI docker configuration

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
