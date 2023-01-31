INSERT INTO users_copy(id, first_name, last_name, email, type, created_at, updated_at)
(
  SELECT id, first_name, last_name, scrub_email(email), type, created_at, updated_at
    FROM users
) ON CONFLICT DO NOTHING;


-- https://stackoverflow.com/a/23695606/126688

-- SO: back up the definition of FKs
-- https://stackoverflow.com/a/69375661/126688
