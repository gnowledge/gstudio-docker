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

#filename=$(basename $(ls  /mnt/update_*.tar.gz |  head -n 1));
#update_patch="${filename%.*.*}";
#update_patch="update_patch-beb6af2-r2.1-20171229"
#patch=$(basename $(tar -tf /mnt/patch-*.tar.gz |  head -n 1));
patch="update-patch-c0463c5-r6-20190718";

# echo -e "\n${cyan}copy updated patch from /mnt/home/core/${update_patch} to /home/docker/code/ in gstudio container ${reset}";
# sudo docker cp /mnt/${update_patch} gstudio:/home/docker/code/;

#echo -e "\n${cyan}copy updated patch from /home/docker/code./${update_patch}/data-updates/* to /data/ in gstudio container ${reset}";
#docker exec -it gstudio /bin/sh -c "rm -rf /data/data_export/*   &&   rsync -avzPh /home/docker/code/${update_patch}/data-updates/* /data/data_export/";

#echo -e "\n${cyan}Update offline patch ${reset}";
#docker exec -it gstudio /bin/sh -c "/bin/bash /home/docker/code/${update_patch}/data-updates/course-import-and-export-update.sh";

#docker exec -it gstudio /bin/sh -c "rm -rf /data/data_export/*";

## code for data update started

#for copying the help_videos folder to /data/media
echo -e "\n${cyan}Copying the help_videos folder to /data/media ${reset}";
sudo rsync -avPhz /mnt/update-patch-r6/${patch}/data-updates/help_videos /home/core/data/media/ ;

#for copying data-updates to /data folder
echo -e "\n${cyan}copying the data-updates folder to /data folder ${reset}";
docker exec -it gstudio /bin/sh -c "rsync -avPhz /home/docker/code/${patch}/data-updates /data/";

#running the images-copy.sh script
echo -e "\n${cyan}Update the data ${reset}";
docker exec -it gstudio /bin/sh -c "/bin/bash /home/docker/code/${patch}/data-updates/images-copy.sh";

#for deleting the data-updates copied earlier
echo -e "\n${cyan}Removing the data-updates folder from /data folder ${reset}";
docker exec -it gstudio /bin/sh -c "rm -rf /data/data-updates";

## code for data update ended

#echo -e "\n${cyan}Restart gstudio container ${reset}";
#sudo docker restart gstudio;
