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

echo -e "\n${cyan}change the directory to /home/docker/code/gstudio ${reset}"
cd /home/docker/code/gstudio/gnowsys-ndf/

echo -e "\n${cyan}Purge module : 590c048ea31c74012efaddb4 ${reset}";
python manage.py purge_node 590c048ea31c74012efaddb4 y

echo -e "\n${cyan}Import module(s) or unit(s)${reset}";
module_and_units=('english-beginner_2017-08-06_17-30' 'geometric-reasoning-part-i_2017-08-04_22-32' 'geometric-reasoning-part-ii_2017-08-04_22-35' 'english-elementary_2017-08-05_00-03' 'proportional-reasoning_2017-08-04_22-28' 'help-topics_17062017_2017-08-05_15-39' 'english-elementary_2017-08-06_17-17' 'health-and-disease_2017-08-05_14-22' 'english-beginner_2017-08-06_17-13')
for m_or_u_name in "${module_and_units[@]}"
do
    echo -e "\n${cyan}Import module/unit: ${m_or_u_name} ${reset}";
    python manage.py group_import /data/data_export/${m_or_u_name} y y y
    rm /home/docker/code/gstudio/gnowsys-ndf/5*
done

# Code - schema update scripts - started
echo -e "\n${cyan}change the directory to /home/docker/code/gstudio ${reset}"
cd /home/docker/code/gstudio/gnowsys-ndf/

echo -e "\n${cyan}apply fab update_data ${reset}"
fab update_data

echo -e "\n${cyan}apply bower components - datatables-rowsgroup ${reset}"
rsync -avzPh /home/docker/code/${update_patch}/code-updates/datatables-rowsgroup /home/docker/code/gstudio/gnowsys-ndf/gnowsys_ndf/ndf/static/ndf/bower_components/

echo -e "\n${cyan}updating teacher' s agency type ${reset}"
python manage.py teacher_agency_type_update

echo -e "\n${cyan}collectstatic ${reset}"
echo yes | python manage.py collectstatic

# Code - schema update scripts - ended