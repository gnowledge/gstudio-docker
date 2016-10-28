#!/bin/bash

#Mrunal : Copy files to respective locations 
echo -e "Process started"
docker cp Create-Server-symlink-base-backup-files-dir.sh rsync-testing:/home/docker/code/scripts/
docker cp backup.sh rsync-testing:/home/docker/code/scripts/
echo -e "Process ended"


