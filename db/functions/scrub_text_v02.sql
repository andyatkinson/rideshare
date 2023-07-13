CREATE OR REPLACE FUNCTION scrub_text(input varchar(255)) RETURNS varchar(255) AS $$
SELECT
-- replace from position 0, to max(length or 6)
SUBSTR(
  MD5(RANDOM()::text),
  0,
  GREATEST(LENGTH(input) + 1, 6)
);
$$ LANGUAGE SQL;
