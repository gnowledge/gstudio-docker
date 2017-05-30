#!/bin/bash

# Mrunal : 20161123 : below part is added by Mrunal as suggested by Nagarjuna, Ulhas and Kedar

# Following variables are used to store the color codes for displaying the content on terminal
# red="\033[0;31m" ;
# green="\033[0;32m" ;
# brown="\033[0;33m" ;
# blue="\033[0;34m" ;
# cyan="\033[0;36m" ;
# reset="\033[0m" ;

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

filename=$(basename $(ls -d /home/docker/code/update_* |  head -n 1));
update_patch="${filename%.*.*}";

# git offline update docker code - started

#git_commit_no_docker="173dc666efc203926415cb2a7d02eda9ab4d9171";             # Earlier commit no
git_commit_no_docker="e72e9a0f64f73a92c06422ab0ea6ff3774326abd";              # Commit on 30-05-2017

echo -e "\n${cyan}change the directory to /home/docker/code/ ${reset}"
cd /home/docker/code/

echo -e "\n${cyan}fetching git details from /home/docker/code/${update_patch}/code-updates/gstudio-docker ${reset}"
git fetch /home/docker/code/${update_patch}/code-updates/gstudio-docker 

echo -e "\n${cyan}merging till specified commit number (${git_commit_no_docker}) from /home/docker/code/${update_patch}/code-updates/gstudio-docker ${reset}"
git merge $git_commit_no_docker

# git offline update docker code - ended


# git offline update gstudio code - started

#git_commit_no_gstudio="f0b3b9e38e2ad7bbac69509005a22f4f0e7ac1f4";             # Earlier commit no
git_commit_no_gstudio="437665e586b010710e8844ae5511912904622a34";              # Commit on 26-05-2017

echo -e "\n${cyan}change the directory to /home/docker/code/gstudio ${reset}"
cd /home/docker/code/gstudio/

echo -e "\n${cyan}fetching git details from /home/docker/code/${update_patch}/code-updates/gstudio ${reset}"
git fetch /home/docker/code/${update_patch}/code-updates/gstudio 

echo -e "\n${cyan}merging till specified commit number (${git-commit-no}) from /home/docker/code/${update_patch}/code-updates/gstudio ${reset}"
git merge $git_commit_no_gstudio

# git offline update gstudio code - ended


# prefix and suffix double quotes " in server code - started

# get server id (Remove single quote {'} and Remove double quote {"})
ss_id=`echo  $(echo $(more /home/docker/code/gstudio/gnowsys-ndf/gnowsys_ndf/server_settings.py | sed 's/.*=//g')) | sed "s/'//g" | sed 's/"//g'`

# update server id
sed -e "/GSTUDIO_INSTITUTE_ID/ s/=.*/='${ss_id}'/" -i  /home/docker/code/gstudio/gnowsys-ndf/gnowsys_ndf/server_settings.py;

# prefix and suffix double quotes " in server code - ended


# collectstatic - started

echo -e "\n${cyan}change the directory to /home/docker/code/gstudio ${reset}"
cd /home/docker/code/gstudio/gnowsys-ndf/

echo -e "\n${cyan}change the directory to /home/docker/code/gstudio ${reset}"
fab update_data

echo -e "\n${cyan}collectstatic ${reset}"
echo yes | python manage.py collectstatic

# collectstatic - ended


# set newly updated crontab - started

echo -e "\n${cyan}Applying newly updated cron jobs in crontab ${reset}"
crontab /home/docker/code/confs/mycron

# set newly updated crontab - ended
