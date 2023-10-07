SELECT
    'ALTER TABLE ' || nsp.nspname || '.' || cls.relname ||
    ' ADD CONSTRAINT ' || conname ||
    ' FOREIGN KEY (' || STRING_AGG(att.attname, ', ') OVER(PARTITION BY conname) || ')' ||
    ' REFERENCES ' || refnsp.nspname || '.' || refcls.relname ||
    ' (' || STRING_AGG(refatt.attname, ', ') OVER(PARTITION BY conname) || ')'
    || CASE
        WHEN confupdtype = 'c' THEN ' ON UPDATE CASCADE'
        WHEN confupdtype = 'n' THEN ' ON UPDATE SET NULL'
        WHEN confupdtype = 'd' THEN ' ON UPDATE SET DEFAULT'
        ELSE ''
    END ||
    CASE
        WHEN confdeltype = 'c' THEN ' ON DELETE CASCADE'
        WHEN confdeltype = 'n' THEN ' ON DELETE SET NULL'
        WHEN confdeltype = 'd' THEN ' ON DELETE SET DEFAULT'
        ELSE ''
    END || ';'
FROM pg_constraint con
JOIN pg_class cls ON con.conrelid = cls.oid
JOIN pg_namespace nsp ON cls.relnamespace = nsp.oid
JOIN pg_class refcls ON con.confrelid = refcls.oid
JOIN pg_namespace refnsp ON refcls.relnamespace = refnsp.oid
JOIN pg_attribute att ON att.attnum = ANY(con.conkey) AND att.attrelid = con.conrelid
JOIN pg_attribute refatt ON refatt.attnum = ANY(con.confkey) AND refatt.attrelid = con.confrelid
WHERE refcls.relname = 'users'  -- replace with your table name
AND refnsp.nspname = 'rideshare'  -- replace with your schema if different
GROUP BY
  conname, nsp.nspname, cls.relname, refnsp.nspname,
  refcls.relname, confupdtype,
  confdeltype, att.attname, refatt.attname;
