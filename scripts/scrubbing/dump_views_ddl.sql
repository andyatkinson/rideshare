SELECT 'CREATE VIEW ' || viewname || ' AS ' || definition
FROM pg_views
WHERE schemaname = 'rideshare'  -- adjust the schema if your view is in another schema
AND viewname = 'search_results';-- replace with your view name

SELECT
  'CREATE MATERIALIZED VIEW ' || matviewname || ' AS ' || definition || ';' ||
  COALESCE(E'\n\nREFRESH MATERIALIZED VIEW ' || matviewname || ' WITH ' || 
  CASE
    WHEN matviewname IN (SELECT conname FROM pg_constraint WHERE contype = 'p') THEN 'NO DATA;' 
    ELSE 'DATA;' 
  END, '')
FROM pg_matviews
WHERE schemaname = 'rideshare'  -- adjust the schema if your view is in another schema
AND matviewname = 'fast_search_results';  -- replace with your materialized view name
