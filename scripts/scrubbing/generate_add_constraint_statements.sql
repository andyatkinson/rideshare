CREATE OR REPLACE FUNCTION generate_add_constraint_statements()
RETURNS text AS $$

DECLARE
  select_stmt text;

BEGIN
  SELECT string_agg('ALTER TABLE '||nspname||'.'||relname||' ADD CONSTRAINT '||conname||' '|| pg_get_constraintdef(pg_constraint.oid)||';', '')
  INTO select_stmt
  FROM pg_constraint
  INNER JOIN pg_class ON conrelid=pg_class.oid
  INNER JOIN pg_namespace ON pg_namespace.oid=pg_class.relnamespace
  WHERE nspname = 'public'
  AND relname = 'users';

  RETURN select_stmt;
END;
$$ LANGUAGE plpgsql;
