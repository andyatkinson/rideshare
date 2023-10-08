SELECT
  'CREATE SEQUENCE ' || schemaname || '.' || sequencename ||
  ' INCREMENT ' || increment_by ||
  ' MINVALUE ' || min_value ||
  ' MAXVALUE ' || max_value ||
  ' START ' || start_value || 
  ';'
FROM pg_sequences
WHERE
  schemaname = 'rideshare'  -- adjust this for your schema if necessary
  AND sequencename = 'users_id_seq';  -- replace with your sequence name
