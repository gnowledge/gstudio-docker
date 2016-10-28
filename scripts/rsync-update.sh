#!/bin/bash

#Mrunal : Copy files to respective locations 
echo -e "Process started"
#docker cp Create-Server-symlink-base-backup-files-dir.sh rsync-testing:/home/docker/code/scripts/
#docker cp backup.sh rsync-testing:/home/docker/code/scripts/

# Git pull docker code
docker exec -it gstudio /bin/sh -c "cd /home/docker/code/ && git pull https://github.com/mrunal4/gstudio-docker.git"

# Git pull gstudio app code
docker exec -it gstudio /bin/sh -c "cd /home/docker/code/gstudio/ && git pull https://github.com/gnowledge/gstudio.git"

#docker exec -it gstudio /bin/sh -c "cd /home/docker/code/gstudio/gnowsys-ndf && /usr/bin/python /home/docker/code/gstudio/gnowsys-ndf/manage.py fillCounter"
echo -e "Process ended"


