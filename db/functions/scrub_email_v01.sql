CREATE OR REPLACE FUNCTION scrub_email(email_address varchar(255)) RETURNS varchar(255) AS $$
BEGIN
RETURN
  -- take random MD5 text that is the same
  -- length as the first part of the email address
  -- EXCEPT when it's less than 5 chars, since we might
  -- have a collision. In that case use 5: greatest(length,6)
  CONCAT(
    substr(
      md5(random()::text),
      0,
      greatest(length(split_part(email_address, '@', 1)) + 1, 6)
    ),
    '@',
    split_part(email_address, '@', 2)
  );
END;
$$ LANGUAGE plpgsql;
