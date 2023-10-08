-- assumes the sequence was already created
ALTER SEQUENCE rideshare.users_id_seq
OWNED BY rideshare.users.id;

ALTER TABLE rideshare.users
ALTER COLUMN id
SET DEFAULT nextval('users_id_seq'::regclass);
