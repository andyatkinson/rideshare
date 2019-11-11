## 2019-11-11

Patterns: Introduce Geocoder gem. In order to automatically `geocode` on create, we can use the `after_validation` hook.
Patterns: has_one/belongs_to it's about where the FK is. For trip_requests, the foreign key to a rider is on the table, so a TripRequest `belongs_to` a Rider.

Trade-off: with this Location data model, we couldn't take advantage currently of common locations being shared among trip requests.

Patterns: ActionController::API, lightweight version of `ActionController::Base` <https://api.rubyonrails.org/classes/ActionController/API.html>. We're creating an `ApiController` that extends `ActionController::API` as we're intending this to be an API app.

Patterns: Strong params for Trip Request creation, model attribute params are forbidden to be used for mass assignment until they have been permitted
Patterns: Fixtures. Use fixtures for test objects that will be re-used, and not change often (like riders)
Patterns: use namespace for `/api` routes

Trade-off: move current_rider to API controller, requires unnesting the rider_id inside the trip request
Best practice: render 201 when trip request was created, or unprocessable entity (422) when it failed

Best practice: use the geocoder initializer `rails generate geocoder:config`, and customize the testing behavior so lookups are not happening in test mode

NOTE: uniqueness among trip request records. The same rider may travel the same trip, so we might want another dimension for uniqueness.

## 2019-11-08

Keeping the Location simple for now, a trip would have a start and end location,
a location is a lat/lng pair. A TripRequest would be a geocoded rider position based
on their current location, and a geocoded address of their destination (will need a geocoder)

Skip TripRating for now and put a rating:integer on the Trip for now. We can still do these aggregate calculations:
* Average trip rating rider has provided
* Average trip rating for a driver
* Avoiding the mutual rating feature (rider->driver,driver->rider) for now


Pattern: Rails STI: use a `type` column and by creating the object using the subclass type, the type information will be stored as a string in the table.
The same works when querying, by asking for a particular record, the type information is surfaced as the type of the class.


## 2019-11-07 Initial thoughts

Some model ideas:

Driver(name:string) (use STI?)
Rider(name:string) (use STI?)
TripRequest(rider_id:integer,start:location_id,end:location_id)
Trip(trip_request_id:integer,driver_id:integer,rider_id:integer,rating:integer)
TripRating(trip_id:integer,rating:integer)
Location(driver_id:integer,rider_id:integer,latitude:decimal,longitude:decimal)

Integer IDs (PK and FKs)


Use cases:

* A rider makes a trip request, including start (geolocate current) and end locations (enter destination)
* A driver accepts the trip request
* A trip involving a driver and rider begins, the location is tracked (includes driver and rider)
  * A trip involving a driver and rider completes (driver and rider)
* A rider can rate a trip

