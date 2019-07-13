#!/bin/bash
#This script is used to execute various ".py" files in python shell 

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

##code for setting default language started

# get server id (Remove single quote {'} and Remove double quote {"})
ss_id=`echo  $(echo $(more /home/docker/code/gstudio/gnowsys-ndf/gnowsys_ndf/server_settings.py | grep -w GSTUDIO_INSTITUTE_ID | sed 's/.*=//g')) | sed "s/'//g" | sed 's/"//g'`;
#ss_id=$(more /home/docker/code/gstudio/gnowsys-ndf/gnowsys_ndf/server_settings.py | sed -n '/.*=/{p;q;}' | sed 's/.*= //g' | sed "s/'//g" | sed 's/"//g')

# Trim leading  whitespaces 
ss_id=$(echo ${ss_id##*( )});
# Trim trailing  whitespaces 
ss_id=$(echo ${ss_id%%*( )});


echo -e "\n${cyan}change the directory to /home/docker/code/gstudio ${reset}";
cd /home/docker/code/gstudio/gnowsys-ndf/;

# Variables related to "set_language" function (setting default language)
state_code=${ss_id:0:2};
language="No Idea";
if [ ${state_code} == "ct" ] || [ ${state_code} == "rj" ]; then
    echo -e "\n${cyan}State code is ${state_code}. Hence setting hi as language.${reset}"
    language="hi";
elif [ ${state_code} == "mz" ]; then
    echo -e "\n${cyan}State code is ${state_code}. Hence setting en as language.${reset}"
    language="en";
elif [ ${state_code} == "tg" ]; then
    echo -e "\n${cyan}State code is ${state_code}. Hence setting te as language.${reset}"
    language="te";
else
    echo -e "\n${red}Error: Oops something went wrong. Contact system administrator or CLIx technical team - Mumbai. ($directoryname)${reset}" ;
fi  
sed -e "/GSTUDIO_PRIMARY_COURSE_LANGUAGE/ s/=.*/= u'${language}'/" -i /home/docker/code/gstudio/gnowsys-ndf/gnowsys_ndf/local_settings.py;


##code for setting default language ended


##code for execution of python files started

echo -e "\n${cyan} changing the directory to /home/docker/code/gstudio/gnowsys-ndf ${reset}";
cd /home/docker/code/gstudio/gnowsys-ndf;

# Executing rectify_faultyassessment_iframetags.py
echo -e "\n${cyan}running 'rectify_faultyassessment_iframetags.py' file in the python shell ${reset}";
echo "execfile('/home/docker/code/gstudio/doc/deployer/rectify_faultyassessment_iframetags.py')" | python manage.py shell;

# Executing release2-1_nov17.py
echo -e "\n${cyan}running 'release2-1_nov17.py' file in the python shell ${reset}";
echo "execfile('/home/docker/code/gstudio/doc/release-scripts/release2-1_nov17.py')" | python manage.py shell;

# Executing delete_duplicate_authors.py
echo -e "\n${cyan}running 'delete_duplicate_authors.py' file in the python shell ${reset}";
echo "execfile('/home/docker/code/gstudio/doc/deployer/delete_duplicate_authors.py')" | python manage.py shell;

#code for syncing sp99, sp100 and cc user-csvs started

echo -e "\n${cyan}To sync sp99,sp100 and cc user csvs ${reset}";
python manage.py sync_users /home/docker/code/user-csvs/sp99_users.csv;    #syncing sp99 user csvs
python manage.py sync_users /home/docker/code/user-csvs/sp100_users.csv;   #syncing sp100 user csvs
python manage.py sync_users /home/docker/code/user-csvs/cc_users.csv;      #syncing cc user csvs

#code for syncing sp99, sp100 and cc user-csvs ended

# Executing fix_for_multipletagid_toggler_modf.py
echo -e "\n${cyan}running 'fix_for_multipletagid_toggler_modf.py' file in the python shell ${reset}";
echo "execfile('/home/docker/code/gstudio/doc/release-scripts/fix_for_multipletagid_toggler_modf.py')" | python manage.py shell;

# Executing fix_stunted_transcript.py
echo -e "\n${cyan}running 'fix_stunted_transcript.py' file in the python shell ${reset}";
echo "execfile('/home/docker/code/gstudio/doc/release-scripts/fix_stunted_transcript.py')" | python manage.py shell;

# Executing fix_505error_of_enotes_upload.py
echo -e "\n${cyan}running 'fix_505error_of_enotes_upload.py' file in the python shell ${reset}";
echo "execfile('/home/docker/code/gstudio/doc/release-scripts/fix_505error_of_enotes_upload.py')" | python manage.py shell;

# Executing fix_notabletodraw_painturl.py
echo -e "\n${cyan}running 'fix_notabletodraw_painturl.py' file in the python shell ${reset}";
echo "execfile('/home/docker/code/gstudio/doc/release-scripts/fix_notabletodraw_painturl.py')" | python manage.py shell;

##code for execution of python file ended



