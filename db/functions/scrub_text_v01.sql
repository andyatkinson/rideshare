CREATE OR REPLACE FUNCTION scrub_text(text varchar(255)) RETURNS varchar(255) AS $$
BEGIN
RETURN
  -- replace from position 0, to max(length or 6)
  substr(
    md5(random()::text),
    0,
    greatest(length(text) + 1, 6)
  );
END;
$$ LANGUAGE plpgsql;
