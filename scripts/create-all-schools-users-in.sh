#!/bin/bash

#--------------------------------------------------------------------#
# Create all users of all school csvs provided 
# File name    : create-all-schools-users.sh
# File version : 1.0
# Created by   : Mr. Mrunal M. Nachankar
# Created on   : 10-08-2016 09:22:AM
# Modified by  : None
# Modified on  : Not yet
# Description  : This file is used for creating all the users of all the csv files placed in the directory. 
#                Execute Command with each filename path (Element of an array) as an argument to sync_users command
#--------------------------------------------------------------------#

FILE_NAMES=( `ls /home/docker/code/user-csvs/*_users.csv` );
#echo "File names are: ${FILE_NAMES[@]} and Timestamp: $DateTime_STAMP2";
#echo "array : Len of array ${#FILE_NAMES[@]} : Len of first ${#FILE_NAMES} : Array ${FILE_NAMES[@]}"; # : Testing purpose printing

echo "File names selected for user creation: ${FILE_NAMES[@]}"
echo "No of files: ${#FILE_NAMES[@]}"

# : Execute Command with each filename path (Element of an array) as an argument to sync_users command
for ss_id in "${FILE_NAMES[@]}";
do
#    echo "ss_id = $ss_id"; # : Testing purpose printing
    if [[ $ss_id != "" ]]; then
		echo "File name : $ss_id";
		cd /home/docker/code/gstudio/gnowsys-ndf;
		python manage.py sync_users ${ss_id};
    else
		echo "Found a blank entry in file name. Hence skipping this enrty and continuing the process. Filename : $ss_id."
    fi
done

echo "Finished processing, Please verify the users in website' s admin panel. ";


