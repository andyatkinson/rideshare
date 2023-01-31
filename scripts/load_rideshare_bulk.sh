# https://www.citusdata.com/blog/2016/10/12/count-performance/
cat << EOF > randgen.sql
COPY (
    SELECT
      (random()*100000000)::integer AS n,
      md5(random()::text) AS s
    FROM
      generate_series(1,10000000)
  ) TO STDOUT;
EOF

psql --dbname rideshare_development --quiet --file randgen.sql | \
psql --dbname rideshare_development --command "COPY items (n, s) FROM STDIN"
