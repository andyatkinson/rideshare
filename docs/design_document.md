## Welcome

This document has entries that were chunks of work on this app. The entries are ordered reverse chronologically, so the first entry is on the bottom.

Start from the bottom and work up to navigate the design decisions made along the way.


## 2019-11-21

Add `strong_migrations` gem, which helps prevent migrations that introduce downtime. I think this is a great project and wanted to rep it here.
Add `blazer` gem for a demonstration of data reporting.


## 2019-11-15

Adding Trip Search on at least 2 dimensions

Uniqueness on Trip Requests, they should not have the same start and end location.


## 2019-11-12

Trip model. Add rating. Ensure Trip is complete before it can be rated. Use a `completed_at` timestamp as the initial way to record the trip status, either complete or not. We may wish to add a state machine later, and states like `pending`->`in_progress`->`completed` etc.

Idea: User communication (also becomes a uniqueness dimension): add email address?

Indexing Dos and Dont's <https://www.itprotoday.com/sql-server/indexing-dos-and-don-ts>

Use `db/schema.rb` and not `db/structure.sql`

Trip has a `trip_request_id` FK, we could ensure it exists before create

:bulb: Best practice: using `delegate`. Since `TripRequest` already has a Rider, and Trip references TripRequest, we can use `delegate` to access the Rider for a Trip <https://stackoverflow.com/a/11457714/126688>

Idea: DB check constraint on rating, `completed_at` IS NOT NULL, pros and cons <https://naildrivin5.com/blog/2015/11/15/rails-validations-vs-postgres-check-constraints.html>

Idea: Consider using an [Architectural Design Record (ADR)](https://adr.github.io/) style for the Iterations log?

## 2019-11-11

:bulb: Patterns: Introduce Geocoder gem. In order to automatically `geocode` on create, we can use the `after_validation` hook.

:bulb: Patterns: has_one/belongs_to it's about where the FK is. For trip_requests, the foreign key to a rider is on the table, so a TripRequest `belongs_to` a Rider.

:bulb: Trade-off: with this Location data model, we couldn't take advantage currently of common locations being shared among trip requests.

Patterns: ActionController::API, lightweight version of `ActionController::Base` <https://api.rubyonrails.org/classes/ActionController/API.html>. We're creating an `ApiController` that extends `ActionController::API` as we're intending this to be an API app.

:bulb: Patterns: Strong params for Trip Request creation, model attribute params are forbidden to be used for mass assignment until they have been permitted
Patterns: Fixtures. Use fixtures for test objects that will be re-used, and not change often (like riders)
Patterns: use namespace for `/api` routes

:bulb: Trade-off: move current_rider to API controller, requires unnesting the rider_id inside the trip request

:bulb: Best practice: render 201 when trip request was created, or unprocessable entity (422) when it failed

Best practice: use the geocoder initializer `rails generate geocoder:config`, and customize the testing behavior so lookups are not happening in test mode.

NOTE: uniqueness among trip request records. The same rider may travel the same trip, so we might want another dimension for uniqueness.

NOTE: We could nest requests and ratings under trips, e.g. /api/trips, /api/trips/requests, /api/trips/ratings

## 2019-11-08

Keeping the `Location` simple for now, a trip would have a start and end location,
a location is a lat/lng pair. A `TripRequest` would be a geocoded rider position based
on their current location, and a geocoded address of their destination (will need a geocoder)

Skip TripRating for now and put a `rating:integer` on the Trip for now. :bulb: Trade-off: this is simpler than a dedicate model. We can still do these aggregate calculations with a simple integer field:

* Average trip rating rider has provided
* Average trip rating for a driver
* Avoiding the mutual rating feature (`rider->driver, driver->rider`) for now


:bulb: Pattern: Rails STI: use a `type` column and by creating the object using the subclass type, the type information will be stored as a string in the table.
The same works when querying, by asking for a particular record, the type information is surfaced as the type of the class.


## 2019-11-07 Initial thoughts

The purpose of this app is to model car-based ride sharing, like Uber or Lyft. This is my take on some objects and their interactions that model this domain. The main model is a Trip and then there are Drivers that provide the trip, and Riders that take the trip.


Some Active Record model ideas and notes below. Single-table inheritence can be used for both the Driver and Rider in a `users` table. :bulb: Trade-off: this saves a bit of initial work having separate models and potentially, duplication between two similar models.

```
Driver(name:string) (use STI?)
Rider(name:string) (use STI?)
Location(driver_id:integer,rider_id:integer,latitude:decimal,longitude:decimal)
TripRequest(rider_id:integer,start:location_id,end:location_id)
Trip(trip_request_id:integer,driver_id:integer,rider_id:integer,rating:integer)
~~TripRating(trip_id:integer,rating:integer)~~
```

Integer IDs (PK and FKs). :bulb: Trade-off: integer primary keys can be exhausted at large scale, and auto increment IDs can be guessable which has security concerns. UUIDs or GUIDs are an alternative, but reduce usability.


Use cases:

* A rider makes a trip request, including a start location (geolocate current) and end location (enter destination)
* A driver accepts the trip request
* A trip involving a driver and rider begins, the location is tracked (includes driver and rider)
  * A trip involving a driver and rider completes (driver and rider)
* A rider can rate a trip

