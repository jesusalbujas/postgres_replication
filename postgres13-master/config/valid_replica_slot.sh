#!/bin/sh

##
# English
# This file can be used to verify the replication connection. 
# This is validated by checking if the 'active' column is set to true (t) or false (f).
##

## 
# Español
# Este archivo se puede utilizar para verificar la conexión de la replicación. 
# La validación se realiza comprobando si la columna 'active' tiene el valor verdadero (t) o falso (f).
##

# Do not modify this container name!
CONTAINER_NAME="DB_POSTGRESQL_V4_MAIN"

# Postgres User of Replication
POSTGRES_USER="postgres_replicator"

docker exec ${CONTAINER_NAME} psql -c "SELECT * FROM pg_replication_slots" -p 5432 -U ${POSTGRES_USER} -d postgres