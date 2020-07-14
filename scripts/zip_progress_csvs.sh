#!/bin/bash

#File creation : Shivani Dixit


#Prerequisite : The folder structure of the backup taken in the hard disk must be /home/core/2019/<state-code>/<school-code>/gstudio


#Description : This script creates a zip of the "gstudio-exported-users-analytics-csvs" folder in the mounted hard disk.


#Steps to run the script : 1. Connect the hard disk which has the data
#                          2. Mount it. Command for mounting "sudo mount <device> /mnt"  (Ex: sudo mount /dev/sdb1 /mnt).
#                          3. Run the bash script using "sudo bash zip_progress_csvs.sh".
#                          4. The script will ask for the state code. Enter according to the instructions there and your requirements.


function zip_progress_csvs() {

  cd /mnt/ ;
  
  ##Enter the state code
  read -p  "Please enter the state code (ct, tg, mz or rj): " state_code

  ##If state code entered is right
  if [ $state_code == ct ] || [ $state_code == tg ] || [ $state_code == rj ] || [ $state_code == mz ]; then
    ##Creation of the folder structure
    sudo mkdir backup_${state_code}_progress_csvs; 
    cd /mnt/backup_${state_code}_progress_csvs/ ;   
    ls /mnt/home/core/2019/${state_code}/ > ${state_code}_folder_names.txt;
    xargs -I {} mkdir -p "{}/gstudio" < ${state_code}_folder_names.txt;
    sudo rm -r /mnt/backup_${state_code}_progress_csvs/${state_code}_folder_names.txt;

    ##Code To sync the "gstudio-exported-users-analytics-csvs" folder.
    for ((i=1; i<=300; i++))
    do 
       id="${state_code}$i"
       cd /mnt/home/core/2019/${state_code}/ ;
       if [ -d *$id ]; then
          sudo rsync -avPhz /mnt/home/core/2019/${state_code}/*${id}/gstudio/gstudio-exported-users-analytics-csvs /mnt/backup_${state_code}_progress_csvs/*${id}/gstudio/ ;
       fi
    done

    ##Code to zip the folder
    cd /mnt/ ;
    sudo zip -r backup_${state_code}_progress_csvs.zip backup_${state_code}_progress_csvs ;
  
  ##If state code entered is wrong  
  else
    echo -e "\e[1;31mERROR:You have entered the wrong code!!! \e[0m"
    echo "Terminating the script."
    exit
  fi
}

zip_progress_csvs | tee zip_progress_csvs.log ;   #logs stored in this file
