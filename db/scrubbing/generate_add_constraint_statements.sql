CREATE OR REPLACE FUNCTION generate_add_constraint_statements()
RETURNS TABLE(stmt text) AS $$

DECLARE
  v_table_name text;
  v_statement text;
BEGIN

  FOR v_table_name IN (SELECT tablename FROM pg_tables WHERE schemaname = 'rideshare' AND tablename IN ('users')) -- could add more tables in future
  LOOP
    SELECT string_agg('ALTER TABLE '||nspname||'.'||relname||' ADD CONSTRAINT '||conname||' '|| pg_get_constraintdef(pg_constraint.oid)||';', '')
    INTO v_statement
    FROM pg_constraint
    INNER JOIN pg_class ON conrelid=pg_class.oid
    INNER JOIN pg_namespace ON pg_namespace.oid=pg_class.relnamespace
    WHERE nspname = 'rideshare'
    AND relname = v_table_name;

    stmt := v_statement;

    RETURN NEXT;
  END LOOP; -- end loop

END; -- end BEGIN
$$ LANGUAGE plpgsql;
