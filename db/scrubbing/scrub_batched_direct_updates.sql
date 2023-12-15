CREATE OR REPLACE PROCEDURE SCRUB_BATCHES()
LANGUAGE PLPGSQL
AS $$
DECLARE
  current_id INT := (SELECT MIN(id) FROM users);
  max_id INT := (SELECT MAX(id) FROM users);
  batch_size INT := 1000;
  rows_updated INT;
BEGIN
  WHILE current_id <= max_id LOOP
    -- the UPDATE by `id` range
    UPDATE users
    SET email = SCRUB_EMAIL(email)
    WHERE id >= current_id
    AND id < current_id + batch_size;

    GET DIAGNOSTICS rows_updated = ROW_COUNT;

    COMMIT;
    RAISE NOTICE 'current_id: % - Number of rows updated: %',
    current_id, rows_updated;

    current_id := current_id + batch_size + 1;
  END LOOP;
END;
$$;

-- Call the Procedure
CALL SCRUB_BATCHES();
