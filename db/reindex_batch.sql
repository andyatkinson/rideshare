set statement_timeout='2h'; -- or whatever max is needed to perform the longest one of these

reindex (verbose) index concurrently trips_pkey;
reindex (verbose) index index_trips_on_driver_id;
reindex (verbose) index index_trips_on_rating;
reindex (verbose) index index_trips_on_trip_request_id;

reindex (verbose) index trip_requests_pkey;
reindex (verbose) index index_trip_requests_on_end_location_id;
reindex (verbose) index index_trip_requests_on_rider_id;
reindex (verbose) index index_trip_requests_on_start_location_id;

-- users table has 3 indexes, reindex all indexes for table
reindex (verbose) table concurrently users;
