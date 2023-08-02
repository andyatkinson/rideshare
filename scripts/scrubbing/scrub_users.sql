INSERT INTO users_copy(id, first_name, last_name, email, type, created_at, updated_at)
(
  SELECT
    id,
    scrub_text(first_name),
    scrub_text(last_name),
    scrub_email(email),
    type,
    created_at,
    updated_at
  FROM users
) ON CONFLICT DO NOTHING;
