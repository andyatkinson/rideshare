# args = ["--set", ON_ERROR_STOP_1, "--quiet", "--no-psqlrc", "--output", File::NULL, "--file", filename]

# createdb rideshare_development;

psql --set ON_ERROR_STOP=on --quiet --no-psqlrc --output /dev/null rideshare_development --file tmp/dump_file.sql

# psql --dbname rideshare_development -c "select count(*) from users"
