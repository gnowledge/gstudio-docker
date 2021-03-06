#!/bin/bash

#This script calls various scripts inside the gstudio container for the updation of codes

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

#for filename

#patch=$(basename $(tar -tf /mnt/patch-*.tar.gz |  head -n 1));
#update_patch="${filename%.*.*}";
#patch="patch-7a6c2ac-r5-20190221";
#patch="patch-26eaf18-r5-20190320";
patch="update-patch-c0463c5-r6-20190718";

#code to run the script named git-offline-code-update.sh inside the container started

echo -e "\n${cyan}copying updated patch from /mnt/${patch} to /home/docker/code/ in gstudio container ${reset}";
sudo rsync -avPhz /mnt/update-patch-r6/${patch} /home/core/code/ ;

echo -e "\n${cyan}Updating offline patch ${reset}";
docker exec -it gstudio /bin/sh -c "/bin/bash /home/docker/code/${patch}/code-updates/git-offline-update.sh";

#code to run the script named git-offline-code-update.sh inside the container started

#code to copy user-csvs of sp99, sp100 and cc inside the container started

val="cc";

echo -e "\n${cyan} Copying the sp99, sp100 and cc user csvs to the user-csvs folder inside the container ${reset}";
sudo rsync -avPhz /home/core/user-csvs/sp/sp99_users.csv /home/core/code/user-csvs/;       #copying sp99 user csvs
sudo rsync -avPhz /home/core/user-csvs/sp/sp100_users.csv /home/core/code/user-csvs/;      #copying sp100 user csvs
sudo rsync -avPhz /home/core/user-csvs/${val}/cc_users.csv /home/core/code/user-csvs/;     #copying cc user csvs

#code to copy user-csvs of sp99, sp100 and cc inside the container ended

# Code To change the permissions of user-csvs folder
echo -e "\n${cyan} Changing the permissions of /home/core/user-csvs folder"
sudo chown root:root /home/core/user-csvs ;
sudo chmod +xr /home/core/user-csvs ;

#code to run the script named python-files-exec.sh inside the container started

echo -e "\n${cyan}Executing the python files ${reset}";
docker exec -it gstudio /bin/sh -c "/bin/bash /home/docker/code/${patch}/code-updates/python-files-exec.sh"; 

#code to run the script named python-files-exec.sh inside the container ended


#code to copy backup-old-server-data.sh and Execute-get_all_users_activity_timestamp_csvs.sh to /home/core

echo -e "\n${cyan}Copying the scripts for old server data backup and getting all user activity timestamp csvs to /home/core";
sudo rsync -avPhz /home/core/code/scripts/backup-old-server-data.sh /home/core/ ;
sudo rsync -avPhz /home/core/code/scripts/Execute-get_all_users_activity_timestamp_csvs.sh /home/core/ ;
sudo rsync -avPhz /mnt/update-patch-r6/${patch}/code-updates/execute-ActivityTimestamp-process.sh /home/core/ ;

