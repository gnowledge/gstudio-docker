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

# echo -e "\n${cyan}Purge module : 590c048ea31c74012efaddb4 ${reset}";
# python manage.py purge_node 590c048ea31c74012efaddb4 y

echo -e "\n${cyan}Import module(s) or unit(s)${reset}";
module_and_units=('basic-astronomy_2017-09-15_12-34' 'linear-equations_2017-09-15_12-53' 'sound_2017-09-15_13-03' 'ecosystem_2017-09-15_13-07' 'atomic-structure_2017-09-15_13-09' 'pre-clix-survey_2017-09-15_13-13' 'post-clix-survey_2017-09-15_13-15')
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

echo -e "\n${cyan}execute python manage.py unit_assessments https://clixserver y ${reset}"
python manage.py unit_assessments https://clixserver y

echo -e "\n${cyan}execute release2_sept17.py ${reset}"
echo "execfile('../doc/deployer/release2_sept17.py')" | python manage.py shell

echo -e "\n${cyan}updating teacher' s agency type ${reset}"
python manage.py teacher_agency_type_update

echo -e "\n${cyan}collectstatic ${reset}"
echo yes | python manage.py collectstatic

# Code - schema update scripts - ended