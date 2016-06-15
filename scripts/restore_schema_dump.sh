#!/bin/bash

echo "[run] restoring schema_dump starting"

echo "[run] restore rcs_repo"
cp -v /home/docker/code/schema_dump/rcs_repo/* /data/rcs_repo/

echo "[run] restore mongo data"
cp -v /home/docker/code/schema_dump/db/* /data/db/

echo "[run] restore mongo data"
echo "psql
	postgres_restore < postgres_dump.sql;" | sudo su - postgres ;   

echo "[run] restoring schema_dump ending"
