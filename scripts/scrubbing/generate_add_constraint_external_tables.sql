CREATE OR REPLACE FUNCTION generate_add_con_external()
RETURNS text AS $$

DECLARE
  select_stmt text;

BEGIN
  SELECT string_agg('ALTER TABLE '||nspname||'.'||relname||' ADD CONSTRAINT '||conname||' '|| pg_get_constraintdef(pg_constraint.oid)||';', '')
  INTO select_stmt
  FROM pg_constraint
  JOIN pg_class ON conrelid=pg_class.oid
  JOIN pg_namespace n ON n.oid = pg_constraint.connamespace
  WHERE confrelid = 'public.users'::regclass;

  RETURN select_stmt;
END;
$$ LANGUAGE plpgsql;
