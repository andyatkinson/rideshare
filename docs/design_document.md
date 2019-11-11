
## 2019-11-08

Keeping the Location simple for now, a trip would have a start and end location,
a location is a lat/lng pair. A TripRequest would be a geocoded rider position based
on their current location, and a geocoded address of their destination (will need a geocoder)

Skip TripRating for now and put a rating:integer on the Trip for now. We can still do these aggregate calculations:
* Average trip rating rider has provided
* Average trip rating for a driver
* Avoiding the mutual rating feature (rider->driver,driver->rider) for now


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

