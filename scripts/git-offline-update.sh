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

filename=$(basename $(ls -dr /home/docker/code/update_*/ |  head -n 1));
update_patch="${filename%.*.*}";
update_patch="update_patch-0bc4478-r2-20170806"

# git offline update docker code - started6
#git_commit_no_docker="0bc4478e856b55be10ffc7931830f4d89593ef7f";             # Earlier commit no
git_commit_no_docker="7ac1fbd86164722662d8add6fabaa26d0170dc8a";              # Commit on 06-08-2017

echo -e "\n${cyan}change the directory to /home/docker/code/ ${reset}"
cd /home/docker/code/

echo -e "\n${cyan}fetching git details from /home/docker/code/${update_patch}/code-updates/gstudio-docker ${reset}"
git fetch /home/docker/code/${update_patch}/code-updates/gstudio-docker 

echo -e "\n${cyan}merging till specified commit number (${git_commit_no_docker}) from /home/docker/code/${update_patch}/code-updates/gstudio-docker ${reset}"
git merge $git_commit_no_docker

# git offline update docker code - ended


# git offline update gstudio code - started

#git_commit_no_gstudio="536f212ff033a6a011ac28070451994f83a65954";             # Earlier commit no
git_commit_no_gstudio="2849c7f3fad5c4c25f02a4194d2354da3c25e054";              # Commit on 05-08-2017

echo -e "\n${cyan}change the directory to /home/docker/code/gstudio ${reset}"
cd /home/docker/code/gstudio/

echo -e "\n${cyan}fetching git details from /home/docker/code/${update_patch}/code-updates/gstudio ${reset}"
git fetch /home/docker/code/${update_patch}/code-updates/gstudio 

echo -e "\n${cyan}merging till specified commit number (${git-commit-no}) from /home/docker/code/${update_patch}/code-updates/gstudio ${reset}"
git merge $git_commit_no_gstudio

# git offline update gstudio code - ended


# git offline update qbank-lite code - started

#git_commit_no_qbank_lite="";             # Earlier commit no
git_commit_no_qbank_lite="1b488926a4d609dcde017e4fe7a47b8a4b541339";              # Commit on 06-08-2017

echo -e "\n${cyan}change the directory to /home/docker/code/gstudio/gnowsys-ndf/qbank-lite ${reset}"
cd /home/docker/code/gstudio/gnowsys-ndf/qbank-lite

echo -e "\n${cyan}fetching git details from /home/docker/code/${update_patch}/code-updates/qbank-lite ${reset}"
git fetch /home/docker/code/${update_patch}/code-updates/qbank-lite 

echo -e "\n${cyan}merging till specified commit number (${git-commit-no}) from /home/docker/code/${update_patch}/code-updates/qbank-lite ${reset}"
git merge $git_commit_no_qbank_lite

# git offline update qbank-lite code - ended


# git offline update OpenAssessmentsClient code - started

#git_commit_no_OpenAssessmentsClient="";             # Earlier commit no
git_commit_no_OpenAssessmentsClient="462ba9c29e6e8874386c5e76138909193e90240e";              # Commit on 05-08-2017

echo -e "\n${cyan}change the directory to /home/docker/code/OpenAssessmentsClient ${reset}"
cd /home/docker/code/OpenAssessmentsClient/

echo -e "\n${cyan}fetching git details from /home/docker/code/${update_patch}/code-updates/OpenAssessmentsClient ${reset}"
git fetch /home/docker/code/${update_patch}/code-updates/OpenAssessmentsClient 

echo -e "\n${cyan}merging till specified commit number (${git-commit-no}) from /home/docker/code/${update_patch}/code-updates/OpenAssessmentsClient ${reset}"
git merge $git_commit_no_OpenAssessmentsClient

# git offline update OpenAssessmentsClient code - ended


# prefix and suffix double quotes " in server code - started

# get server id (Remove single quote {'} and Remove double quote {"})
#ss_id=`echo  $(echo $(more /home/docker/code/gstudio/gnowsys-ndf/gnowsys_ndf/server_settings.py | sed 's/.*=//g')) | sed "s/'//g" | sed 's/"//g'`

# update server id
#sed -e "/GSTUDIO_INSTITUTE_ID/ s/=.*/='${ss_id}'/" -i  /home/docker/code/gstudio/gnowsys-ndf/gnowsys_ndf/server_settings.py;

# prefix and suffix double quotes " in server code - ended


# extra scripts - started

echo -e "\n${cyan}change the directory to /home/docker/code/gstudio ${reset}"
cd /home/docker/code/gstudio/gnowsys-ndf/

echo -e "\n${cyan}apply fab update_data ${reset}"
fab update_data

echo -e "\n${cyan}apply bower components - datatables-rowsgroup ${reset}"
rsync -avzPh /home/docker/code/${update_patch}/code-updates/datatables-rowsgroup /home/docker/code/gstudio/gnowsys-ndf/gnowsys_ndf/ndf/static/ndf/bower_components/

echo -e "\n${cyan}add few variables and there value so replace the same - local_settings ${reset}"
rsync -avzPh /home/docker/code/${update_patch}/code-updates/gstudio-docker/confs/local_settings.py.default /home/docker/code/gstudio/gnowsys-ndf/gnowsys_ndf/local_settings.py

echo -e "\n${cyan}apply requirements - copying dlkit dist-packages ${reset}"
rsync -avzPh /home/docker/code/${update_patch}/code-updates/dist-packages/dlkit* /usr/local/lib/python2.7/dist-packages/

echo -e "\n${cyan}updating teacher' s agency type ${reset}"
python manage.py teacher_agency_type_update

echo -e "\n${cyan}collectstatic ${reset}"
echo yes | python manage.py collectstatic

# extra scripts - ended


# set newly updated crontab - started

echo -e "\n${cyan}Applying newly updated cron jobs in crontab ${reset}"
crontab /home/docker/code/confs/mycron

# set newly updated crontab - ended
