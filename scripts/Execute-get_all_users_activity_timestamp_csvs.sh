#!/bin/bash
echo "Script started"
# Variable definations
day_of_week=$(date +%A);  # (0..6); 0 is Sunday, 5 is Friday
day_of_month=$(date +%d); # (1-28 for Feb and 1-30 / 1-31 for the other months); day 
month=$(date +%B);        # (1-12)Month; 1 is January and 2 is February
sleeping_time="10m";

# If 2nd and 4th Friday trigger the script inside docker container (after sleeping time to give enough time to start container and services inside it). 
# Else pint date and necessary variables.  
if ([ ${day_of_week} == "Friday" -a ${day_of_month} -ge 8 -a ${day_of_month} -le 14 ] || [ ${day_of_week} == "Friday" -a ${day_of_month} -ge 22 -a ${day_of_month} -le 28 ]); then # || [ ${day_of_week} == "Sunday" -a ${day_of_month} -ge 22 -a ${day_of_month} -le 28 ] || []); then
    echo "Trigger script (Before sleeping : '$(date)') {Sleeping time: ${sleeping_time}in}";    
    sleep ${sleeping_time};
    echo "Trigger script (Before sleeping : '$(date)') {Sleeping time: ${sleeping_time}in}";    
    docker exec gstudio /bin/sh -c "echo \"execfile('/home/docker/code/gstudio/doc/deployer/get_all_users_activity_timestamp_csvs.py')\" |/usr/bin/python /home/docker/code/gstudio/gnowsys-ndf/manage.py shell";
else
    echo "Script not Triggered (Date: '$(date)') : ${day_of_week} : ${month} : ${day_of_month} :";
fi

exit 0;
