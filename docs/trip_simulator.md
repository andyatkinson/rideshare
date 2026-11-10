# Trip activity simulator

Open `/simulator` on the development Rails server. Choose **Concurrent trips**
(1–10), **Sample every** (0.25–60 seconds), and **Start jitter** (0–300 seconds,
default 30), then **Run 10 trips**. The backend validates and applies the entire
configuration; the active settings are displayed beside the controls. Edits apply
to the next batch. Stop the current batch before starting another configuration.

Each ride lasts six simulated minutes regardless of sampling frequency, with a
pickup sample immediately and an arrival sample at six minutes. At five-second
intervals each ride creates 73 position records. An interval that does not divide
six minutes gets a final shorter interval so the arrival time stays unchanged.
Origins and destinations are chosen randomly and are always different. Only one
active trip may occupy each pickup location. With seven locations, at most seven
trips are active; additional workers wait until an origin becomes available. Before
each trip, a worker waits a random 0–jitter seconds, including its first trip and
replacement trips. Jitter does not hold a database connection.

## Locations and routes

The fixed location roster is Kendall Square, Central Square, Harvard Square,
Inman Square, [MIT's main entrance](https://www.mit.edu/visit/) near 77 Massachusetts
Avenue, [Harvard's Oxford Street campus](https://chsi.harvard.edu/visit-us), and
North Station across the river in Boston. Pickup coordinates are approximate.
Existing unrelated locations and records are preserved.

Generate the offline route file once after checkout, before running the simulator
or its tests (Ruby standard library only; no Rails boot or database needed):

```sh
ruby bin/generate_simulator_routes
# Or inside Docker:
docker compose exec app ruby bin/generate_simulator_routes
```

The script reads the location roster from `TripSimulator::Pool::LOCATIONS` and
fetches all 42 directed driving routes from
[OSRM](https://project-osrm.org/) using [OpenStreetMap](https://www.openstreetmap.org/copyright).
It writes `db/simulator_routes.json`, which is ignored by Git and reused as static
local data. Internet access is needed only for generation. Re-run after changing
locations or to refresh road geometry; restart Rails and any running simulator to
reload the cache. `OSRM_URL` can point to another OSRM server with the driving
profile. Failed generation preserves the previous file.

Position generation interpolates by distance along saved street geometry; there
are no runtime geocoding or routing API calls. Timing and GPS samples are synthetic,
not measured traffic or real journeys. PostgreSQL point x is latitude and y is
longitude, matching the app's existing convention. Other caller-supplied locations
retain straight-line interpolation.

The actor pool reuses at least five drivers, or enough for the selected concurrency
(up to ten), and 30 riders. Requests, trips, and positions accumulate. Assignment
is serialized with a database lock, prevents duplicate use of a driver/rider, and
enforces the run's concurrency limit. Sampling sleeps occur outside connection
checkouts, so workers share a five-connection simulator pool alongside the
web server without increasing the database role’s ten-connection limit.

## Run and stop

The UI starts a detached Rails task in the server's environment, inside the app
container when using Docker. A process-held file lock prevents overlapping batches.
No separate job service or Docker socket is required. Run CLI tasks in the same
environment as the server (`docker compose exec app` for Docker) so Stop all can
identify and stop their process. Output and errors go to
`log/simulator.log`. Reloading the page does not stop the task.

**Stop all** cancels the process, all workers, and pending jitter waits. After it
exits, unfinished simulator trips and their requests/positions are removed in a
transaction. Completed trips and ratings, actor pools, locations, and unrelated
app data remain. Driver counters update through model callbacks. The live map and
count-growth baseline reset. If the process cannot be identified or stopped, data
cleanup is refused. No completion times or ratings are fabricated.

Equivalent CLI invocation from the repository:

```sh
docker compose exec -e SIM_CONCURRENCY=3 -e SIM_INTERVAL=5 -e SIM_JITTER=30 \
  app sh -c 'export PGPASSWORD="$RIDESHARE_DB_PASSWORD"; bin/rails "simulate:app_activity[10]"'
```

For host Rails, use `SIM_CONCURRENCY=3 SIM_INTERVAL=5 SIM_JITTER=30` before
`bin/rails 'simulate:app_activity[10]'`, with the same database configuration.
`SIM_SEED` seeds random choices; concurrent scheduling changes their order.
`SIM_RIDERS` sets the rider pool size (at least the concurrency). For short CLI
smoke runs, `SIM_DURATION=2 SIM_INTERVAL=1 SIM_JITTER=0` overrides the demo duration.
`SIM_SQL_LOG=1` enables SQL logs.

## Dashboard

The page polls committed state every second (five seconds when hidden). Active
drivers sort first; idle drivers are yellow and active drivers green. The
[Leaflet](https://leafletjs.com/) map frames the whole demo area. Each active trip
has its own color, a full street-route line, numbered position pins, and matching
ride-card border. 🚩 marks pickup and 🏁 destination; timers show elapsed time and
estimated time remaining from the run's configured duration. Overlapping icons
are slightly offset for visibility; stored coordinates are unchanged.

Click a completed trip number to inspect its saved positions; **Back to live**
restores active trips. The latest 15 completed rides are available, with three
initially visible. Extra active cards scroll within their panel. Database-wide
counts include unrelated data and add read load as tables grow; growth resets on
reload or Stop all. Leaflet assets load from unpkg and tiles from OpenStreetMap,
requiring internet with attribution displayed, without an API key or paid account.
The dashboard and control endpoints are development-only and use Rails CSRF
protection. Tests exercise the workload and controls against the test database.

## PgHero

Open `/pghero/live_queries` on the same Rails server. PgHero uses the Rails primary
connection (`rideshare_development` in Docker). Live Queries shows SQL currently
executing, not a query history: short simulator inserts may finish between
refreshes. Use the Queries page for aggregated workload statistics when query
stats are enabled.
