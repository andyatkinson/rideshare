docker exec -it db01 /bin/bash

# https://cloud.google.com/community/tutorials/setting-up-postgres-hot-standby
createuser -U postgres repuser -P -c 5 --replication
