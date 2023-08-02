 ALTER TABLE public.trip_requests ADD CONSTRAINT fk_rails_c17a139554 FOREIGN KEY (rider_id) REFERENCES users(id);ALTER TABLE public.trips ADD CONSTRAINT fk_rails_e7560abc33 FOREIGN KEY (driver_id) REFERENCES users(id);

