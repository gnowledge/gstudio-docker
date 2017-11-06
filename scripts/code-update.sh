#!/bin/bash

# Following variables are used to store the color codes for displaying the content on terminal
black="\033[0;90m" ;
red="\033[0;91m" ;
green="\033[0;92m" ;
brown="\033[0;93m" ;
blue="\033[0;94m" ;
purple="\033[0;95m" ;
cyan="\033[0;96m" ;
grey="\033[0;97m" ;
white="\033[0;98m" ;
reset="\033[0m" ;


filename=$(basename $(ls  /mnt/update_*.tar.gz |  head -n 1));
update_patch="${filename%.*.*}";
update_patch="update_patch-ffe433b-r2.1-20171107"

echo -e "\n${cyan}copy updated patch from /mnt/home/core/${update_patch} to /home/docker/code/ in gstudio container ${reset}";
sudo docker cp /mnt/${update_patch} gstudio:/home/docker/code/;

echo -e "\n${cyan}Update offline patch ${reset}";
docker exec -it gstudio /bin/sh -c "/bin/bash /home/docker/code/${update_patch}/code-updates/git-offline-update.sh";

# echo -e "\n${cyan}Cleaning up qbank hardcoded file names - offline patch ${reset}";
# docker exec -it gstudio /bin/sh -c "/usr/bin/python /home/docker/code/${update_patch}/code-updates/gstudio-docker/scripts/cleaning-up-qbank-hardcoded-file-names.py";

echo -e "\n${cyan}copy updated patch from /mnt/${update_patch}/code-updates/backup-old-server-data.sh to /home/core/ ${reset}";
sudo cp /mnt/${update_patch}/code-updates/backup-old-server-data.sh /home/core/;

echo -e "\n${cyan}Restart gstudio container ${reset}";
sudo docker restart gstudio;