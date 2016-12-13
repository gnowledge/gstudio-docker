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

update_patch="update_nov_16";

# git offline update docker code - started

#git_commit_no_docker="20c14df4325c2e419b552b6c749aeb09ce344e5b";             # Earlier commit no
git_commit_no_docker="45142a82d9d83b2e0cd5e80e80ca46e67a1c0f9b";              # Commit on 13-12-2016

echo -e "\n${cyan}change the directory to /home/docker/code/ ${reset}"
cd /home/docker/code/

echo -e "\n${cyan}fetching git details from /home/docker/code/${update_patch}/gstudio-docker ${reset}"
git fetch /home/docker/code/${update_patch}/gstudio-docker 

echo -e "\n${cyan}merging till specified commit number (${git_commit_no_docker}) from /home/docker/code/${update_patch}/gstudio-docker ${reset}"
git merge $git_commit_no_docker

# git offline update docker code - ended


# git offline update gstudio code - started

#git_commit_no_gstudio="6651f64e922192459f128f44d953b2c1a44cd654";             # Earlier commit no
git_commit_no_gstudio="7fc544830a8229931e01cf8841ad06d22f8cb6f6";              # Commit on 13-12-2016

echo -e "\n${cyan}change the directory to /home/docker/code/gstudio ${reset}"
cd /home/docker/code/gstudio/

echo -e "\n${cyan}fetching git details from /home/docker/code/${update_patch}/gstudio ${reset}"
git fetch /home/docker/code/${update_patch}/gstudio 

echo -e "\n${cyan}merging till specified commit number (${git-commit-no}) from /home/docker/code/${update_patch}/gstudio ${reset}"
git merge $git_commit_no_gstudio

# git offline update gstudio code - ended


# prefix and suffix double quotes " in server code - started

# get server id 
ss_id=`echo $(more /home/docker/code/gstudio/gnowsys-ndf/gnowsys_ndf/server_settings.py | sed 's/.*=//')`

# update server id
sed -e "/GSTUDIO_INSTITUTE_ID/ s/=.*/='${ss_id}'/" -i  /home/docker/code/gstudio/gnowsys-ndf/gnowsys_ndf/server_settings.py;

# prefix and suffix double quotes " in server code - ended


# collectstatic - started

echo -e "\n${cyan}change the directory to /home/docker/code/gstudio ${reset}"
cd /home/docker/code/gstudio/gnowsys-ndf/

echo -e "\n${cyan}collectstatic ${reset}"
echo yes | python manage.py collectstatic

# collectstatic - ended
