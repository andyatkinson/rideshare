-- Reverse all the DEFAULT PRIVILEGES ....or
-- https://stackoverflow.com/a/54078230/126688

-- Simpler solution:
-- https://dba.stackexchange.com/a/155356/272968

REASSIGN OWNED BY owner TO postgres;
DROP OWNED BY owner;
