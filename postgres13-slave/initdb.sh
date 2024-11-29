#!/bin/bash

MASTER_SERVER="IP_HERE"
MASTER_PORT="PORT_HERE"
MASTER_USER="postgres_replicator"
PGPASSWORD="replicator"
MASTER_SLOT="replication_slot_1"

if [ "$( psql -U $POSTGRES_USER -tAc "SELECT 1 FROM pg_roles WHERE rolname='adempiere'" )" != '1' ]
then
    createuser -U $POSTGRES_USER adempiere -dlrs
    echo "Created User: adempiere"
    psql -U $POSTGRES_USER -tAc "alter user adempiere password '$POSTGRES_PASSWORD';"
    echo "Created Password: $POSTGRES_PASSWORD"
fi

while ! pg_isready -U postgres; do
  echo "Waiting PostgreSQL..."
  sleep 2
done
echo "PostgreSQL ready. Executing script..."

# Maintain a copy of data
cp -R /var/lib/postgresql/data /var/lib/postgresql/data_old

# Remove data
rm -rf /var/lib/postgresql/data/
echo "Remove data from /var/lib/postgresql/data/"

# Execute pg basebackup
pg_basebackup -h $MASTER_SERVER -p $MASTER_PORT -D /var/lib/postgresql/data/ -U $MASTER_USER -P -v -R -X stream -C -S $MASTER_SLOT
echo "Basebackup executed successfully"