# Trip activity simulator

Run against the single, unpartitioned development database. In Docker:

```sh
docker compose exec app sh -c 'export PGPASSWORD="$RIDESHARE_DB_PASSWORD"; bin/rails "simulate:app_activity[10]"'
```

For Rails running directly on your machine with the same database configuration:

```sh
bin/rails 'simulate:app_activity[10]'
```

The task reuses 10 simulator drivers, 30 riders, and two locations: Kendall Square
(42.36242, -71.08572) and Central Square (42.36507, -71.10310), Cambridge, MA.
Each ride chooses a direction, assigns an idle driver, records positions, completes,
and receives a random trip rating from 1 to 5. The rating has no separate author
field. Completed drivers return to the idle pool. Existing locations and trips
are preserved; only new simulator rides use these endpoints.

Defaults are 13 positions at 30-second intervals: pickup at time zero, arrival at
six minutes, then immediate completion. Sequential runs generate about 10 trips
and 130 position records per hour. Adjust `SIM_SAMPLES` and `SIM_INTERVAL` (seconds);
ride duration is `(SIM_SAMPLES - 1) * SIM_INTERVAL`. Zero interval skips sleeping.
For a fast preview:

```sh
docker compose exec -e SIM_INTERVAL=0.5 app sh -c 'export PGPASSWORD="$RIDESHARE_DB_PASSWORD"; bin/rails "simulate:app_activity[10]"'
```

`SIM_DRIVERS` and `SIM_RIDERS` control roster sizes; `SIM_SEED` makes participant,
direction, and rating choices reproducible. `SIM_SQL_LOG=1` includes SQL logs.

## Route and records

`db/simulator_routes.json` stores independently routed driving geometry in both
directions, approximately 1.56 km each, from [OSRM](https://project-osrm.org/)
and [OpenStreetMap](https://www.openstreetmap.org/copyright). Positions interpolate
by distance along street segments at a constant simulated speed. These are
synthetic GPS samples, not measured traffic or recorded journeys. No geocoding or
routing API is called during simulation. Coordinate order follows the app's
existing convention: PostgreSQL point x is latitude, y is longitude. Caller-supplied
locations outside this pair retain straight-line interpolation.

Rides run sequentially through real model writes and `TripCreator`; no HTTP server
or worker is needed to generate data. Assignment locks prevent duplicate use of
a driver. Busy pools fail before creating a request. Position updates and
completion commit separately; interruptions leave a real unfinished trip and busy
driver. Requests, trips, and positions accumulate; fixed actor pools are reused.

## Live dashboard

Start the Rails server and open `/simulator` in development. The read-only page
polls every second (five seconds when hidden). Yellow drivers are idle; green
are active. The [Leaflet](https://leafletjs.com/) map starts framed around both
squares. Green pins show every recorded position for active trips and disappear
on completion. Click a completed trip number for its saved blue position pins;
**Back to live** restores active trips. Pin pop-ups show trip, sample, and time.

The page shows up to 50 active trips and the latest 15 completed trips (three
initially, with expandable history). Exact database-wide counts include unrelated
data and add read load as tables grow. Growth resets when the page reloads.
Leaflet assets load from unpkg and tiles from OpenStreetMap, requiring internet
access, with attribution displayed. No API key or paid map account is required.
The dashboard is development-only; tests exercise it against the test database.
