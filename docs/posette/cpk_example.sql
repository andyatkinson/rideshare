CREATE TABLE accounts (
  id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name text UNIQUE NOT NULL
);

-- single column primary key
CREATE TABLE orders (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  account_id INT NOT NULL,
  CONSTRAINT fk_account_id
    FOREIGN KEY (account_id)
    REFERENCES accounts(id)
);

-- Alternative for FK
CREATE TABLE orders (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  account_id INT NOT NULL REFERENCES accounts(id)
);

-- Drop single column PK
ALTER TABLE orders DROP CONSTRAINT orders_pkey;

-- Add CPK
ALTER TABLE orders
ADD CONSTRAINT orders_pkey_cpk
PRIMARY KEY (id, account_id);

-- Create with CPK
CREATE TABLE orders (
  id BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
  account_id INT NOT NULL,
  CONSTRAINT orders_pkey_cpk
    PRIMARY KEY (id, account_id)
);
