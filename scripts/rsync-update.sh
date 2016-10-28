#!/usr/bin/bash

#Mrunal : Take git pull
echo -e "Process started"

# Git pull docker code
docker exec -it gstudio /bin/sh -c "cd /home/docker/code/ && git pull https://github.com/mrunal4/gstudio-docker.git"

# Git pull gstudio app code
docker exec -it gstudio /bin/sh -c "cd /home/docker/code/gstudio/ && git pull https://github.com/gnowledge/gstudio.git"

echo -e "Process ended"


