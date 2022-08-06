
CREATE TABLE users_copy (LIKE users INCLUDING ALL);

ALTER TABLE users_copy ADD PRIMARY KEY(id);

INSERT INTO users_copy(first_name, last_name, email, type, created_at, updated_at)
(SELECT first_name, last_name, email, type, created_at, updated_at FROM users);
