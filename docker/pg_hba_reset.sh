# Run from the "docker" directory in Rideshare
#
# Remove any existing file if exists
rm -f pg_hba.conf

echo "Getting IP address for db02..."
ip_address=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' db02)
echo "$ip_address"

entry="host    replication     replication_user $ip_address/32               md5"

echo "Generating pg_hba.conf file"
cat <<EOF >> pg_hba.conf
# TYPE  DATABASE        USER            ADDRESS                 METHOD
# Replication
$(echo "$entry")
local   all             all                                     trust
# IPv4 local connections:
host    all             all             127.0.0.1/32            trust
# IPv6 local connections:
host    all             all             ::1/128                 trust
host all all all scram-sha-256
EOF
cat pg_hba.conf
echo

echo "Copy pg_hba.conf to db01"
docker cp pg_hba.conf db01:/var/lib/postgresql/data/.
