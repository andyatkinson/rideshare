# Trip activity simulator

Run against the single, unpartitioned development database. In Docker:

```sh
docker compose exec app sh -c 'export PGPASSWORD="$RIDESHARE_DB_PASSWORD"; bin/rails "simulate:app_activity[10]"'
```

For Rails running directly on your machine with the same database configuration:

```sh
bin/rails 'simulate:app_activity[10]'
```

The task reuses five simulator drivers, 30 riders, and two locations: Kendall Square
(42.36242, -71.08572) and Central Square (42.36507, -71.10310), Cambridge, MA.
Each ride chooses a direction, assigns an idle driver, records positions, completes,
and receives a random trip rating from 1 to 5. The rating has no separate author
field. Completed drivers return to the idle pool. Existing locations and trips
are preserved; new rides and dashboard history use only these two Cambridge
endpoints and simulator drivers 1–5. Database-wide counts still include old data.

Defaults are 13 positions at 30-second intervals: pickup at time zero, arrival at
six minutes, then immediate completion. Runs default to two concurrent rides, generating about 20 trips
and 260 position records per hour. Adjust `SIM_SAMPLES` and `SIM_INTERVAL` (seconds);
ride duration is `(SIM_SAMPLES - 1) * SIM_INTERVAL`. Zero interval skips sleeping.
For a fast preview:

```sh
docker compose exec -e SIM_INTERVAL=0.5 app sh -c 'export PGPASSWORD="$RIDESHARE_DB_PASSWORD"; bin/rails "simulate:app_activity[10]"'
```

`SIM_DRIVERS` (1–5) and `SIM_RIDERS` control roster sizes. `SIM_CONCURRENCY`
is 1 or 2 (default 2). `SIM_SEED` seeds random choices; use one worker for
reproducible ordering. `SIM_SQL_LOG=1` includes SQL logs.

## Route and records

`db/simulator_routes.json` stores independently routed driving geometry in both
directions, approximately 1.56 km each, from [OSRM](https://project-osrm.org/)
and [OpenStreetMap](https://www.openstreetmap.org/copyright). Positions interpolate
by distance along street segments at a constant simulated speed. These are
synthetic GPS samples, not measured traffic or recorded journeys. No geocoding or
routing API is called during simulation. Coordinate order follows the app's
existing convention: PostgreSQL point x is latitude, y is longitude. Caller-supplied
locations outside this pair retain straight-line interpolation.

Rides run through real model writes and `TripCreator`; the CLI task uses up to
two threads. A database assignment lock enforces a maximum of two unfinished
simulator trips across runs. No HTTP server or worker service is needed to generate data. Assignment locks prevent duplicate use of
a driver. Busy pools fail before creating a request. Position updates and
completion commit separately; interruptions leave a real unfinished trip and busy
driver. Requests, trips, and positions accumulate; fixed actor pools are reused.

## Live dashboard

Start the Rails server and open `/simulator` in development. **Run 10 trips**
starts the same Rails task as a detached process inside the server's environment
(in the app container when using Docker). It uses five drivers, 30 riders, two
Cambridge endpoints, 13 samples, 30-second intervals, and two concurrent rides;
a batch takes about 30 minutes. No Docker socket or external job worker is needed.
A process-held file lock prevents duplicate runs from the UI or CLI. The button
disables while a batch runs; output and failures go to `log/simulator.log`.
An existing unfinished simulator ride must finish before starting a new UI batch.
The start endpoint is development-only and protected by Rails CSRF validation.
Reloading the page does not interrupt a batch. Logs from CLI invocations remain
in their terminal.

The page polls every second (five seconds when hidden). Yellow drivers are idle; green
are active. The [Leaflet](https://leafletjs.com/) map starts framed around both
squares. Distinct colors and trip-number labels identify recorded positions for each
active trip; pins disappear on completion. Matching colored borders identify
the active ride cards below the wide map, and active drivers sort before idle
drivers. Marker icons and labels are slightly offset to distinguish overlapping
trips; stored coordinates are unchanged. Click a completed trip number for its saved blue position pins;
**Back to live** restores active trips. Pin pop-ups show trip, sample, and time.

The page shows up to 50 active trips and the latest 15 completed trips (three
initially, with expandable history). Exact database-wide counts include unrelated
data and add read load as tables grow. Growth resets when the page reloads.
Leaflet assets load from unpkg and tiles from OpenStreetMap, requiring internet
access, with attribution displayed. No API key or paid map account is required.
The dashboard is development-only; tests exercise it against the test database.
