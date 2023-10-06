INSERT INTO users_copy(id, first_name, last_name, email, type, created_at, updated_at, password_digest, trips_count, drivers_license_number, searchable_full_name)
(
  SELECT
    id,
    scrub_text(first_name),
    scrub_text(last_name),
    scrub_email(email),
    type,
    created_at,
    updated_at,
    password_digest,
    trips_count,
    scrub_text(drivers_license_number),
    searchable_full_name
  FROM users
) ON CONFLICT DO NOTHING;
