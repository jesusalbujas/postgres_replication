#!/bin/bash

USER_REPLICATOR="postgres_replicator"
PASSWORD_REPLICATOR="replicator"

if [ "$( psql -U $POSTGRES_USER -tAc "SELECT 1 FROM pg_roles WHERE rolname='adempiere'" )" != '1' ]
then
    createuser -U postgres adempiere -dlrs
    psql -U postgres -tAc "alter user adempiere password 'adempiere@123';"
fi

# A user must be created for replication in the main postgres
psql -U postgres -tAc "CREATE USER $USER_REPLICATOR WITH REPLICATION ENCRYPTED PASSWORD '$PASSWORD_REPLICATOR';"
echo "Created User: $USER_REPLICATOR and Password: $PASSWORD_REPLICATOR"

# Maintain a copy of postgresql.conf
cp /var/lib/postgresql/data/postgresql.conf /var/lib/postgresql/data/old_postgresql.conf
echo "Maintain a copy of postgresql.conf to old_postgresql.conf"

# Remove postgresql.conf
rm /var/lib/postgresql/data/postgresql.conf
echo "Remove postgresql.conf"

# Move custom configuration
cp /tmp/postgresql/postgresql.conf /var/lib/postgresql/data/
echo "Move custom configuration"

# Move custom pg_hba.conf
cp /tmp/postgresql/pg_hba.conf /var/lib/postgresql/data/
echo "Move custom pg_hba.conf to /var/lib/postgresql/data/"

# Restart config of Postgres
psql -U postgres -tAc "SELECT pg_reload_conf();"
echo "Reload postgres"