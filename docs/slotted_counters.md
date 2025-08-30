# Slotted Counters

A Rider can track its trip_requests.

```rb
# https://github.com/evilmartians/activerecord-slotted_counters
has_slotted_counter :trip_requests
```

Increment counter manually
```
rideshare(dev)> Rider.increment_counter(:trip_requests_count, rider.id)
  TRANSACTION (9.1ms)  BEGIN
   (2.3ms)  INSERT INTO "slotted_counters" ("counter_name","associated_record_type","associated_record_id","slot","count","created_at","updated_at") VALUES ('trip_requests_count', 'Rider', 20200, 86, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP) ON CONFLICT ("associated_record_id","associated_record_type","counter_name","slot") DO UPDATE SET count = slotted_counters.count + EXCLUDED.count RETURNING "id"
  TRANSACTION (0.3ms)  COMMIT
```

Access:
```
rider.trip_requests_count
```

## Why the "slot"?
By having a limit of rand(100), there are up to 100 possible records representing the total count.

A slot keeps a counter, and its counter is updated on increment. This distributes the updates and avoids locking the same row.
