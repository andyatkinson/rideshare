-- replace email_address with random text that is the same
-- length as the unique portion of an email address
-- before the "@" symbol.
-- Make the minimum length 5 characters to avoid
-- MD5 text generation collisions
CREATE OR REPLACE FUNCTION scrub_email(email_address varchar(255)) RETURNS varchar(255) AS $$
SELECT
CONCAT(
  SUBSTR(
    MD5(RANDOM()::text),
    0,
    GREATEST(LENGTH(SPLIT_PART(email_address, '@', 1)) + 1, 6)
  ),
  '@',
  SPLIT_PART(email_address, '@', 2)
);
$$ LANGUAGE SQL;
