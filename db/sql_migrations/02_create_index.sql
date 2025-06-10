create index concurrently if not exists idx_trips_id_created_at
on trips (id, created_at);
