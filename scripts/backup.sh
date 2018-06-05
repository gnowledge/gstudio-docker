#!/bin/bash


#--------------------------------------------------------------------#
# Backup of gstudio 
# File name    : Backup-script-mrunal.sh
# File version : 2.0
# Created by   : Mr. Mrunal M. Nachankar
# Created on   : 26-06-2014 12:04:AM
# Modified by  : Mr. Mrunal M. Nachankar
# Modified on  : Sun Jun  3 20:00:46 IST 2018
# Description  : This file is used for taking backup of gstudio
#                1. Check for backup directory - If don't exist please create the same.
#					1.1	Backup directory : /home/glab/rcs-db-backup/<yyyy-mm-dd> i.e for 26th June 2015 it will be "/home/glab/rcs-db-backup/2015-06-26"
#					1.2 In backup directory we will have 2 sub directories "rcs" for rcs repo backup and "mongodb" for mongodb database backup (mongodb dump)
#				 2. Take backup of rcs via cp (copy -rv) command
#				 3. Take backup of mongodb via mongodbdump command
#				 4. Create a compressed file (TAR File - tar.bz2)
#				 5. Optional - Move the backup directory to /tmp/ after successful creation of tar.bz2 file
#--------------------------------------------------------------------#

sleep 60;     # To start mongo

# get current year
cur_year=`date +"%Y"`

# platform name
platform="gstudio"

# get server id (Remove single quote {'} and Remove double quote {"})
ss_id=`echo  $(echo $(more /home/docker/code/gstudio/gnowsys-ndf/gnowsys_ndf/server_settings.py | grep -w GSTUDIO_INSTITUTE_ID | sed 's/.*=//g')) | sed "s/'//g" | sed 's/"//g'`

# get state code
state_code=${ss_id:0:2};

# get server code (Remove single quote {'} and Remove double quote {"})
ss_code=`echo  $(echo $(more /home/docker/code/gstudio/gnowsys-ndf/gnowsys_ndf/server_settings.py | grep -w GSTUDIO_INSTITUTE_ID_SECONDARY | sed 's/.*=//g')) | sed "s/'//g" | sed 's/"//g'`

# get server name (Remove single quote {'} and Remove double quote {"})
ss_name=`echo  $(echo $(more /home/docker/code/gstudio/gnowsys-ndf/gnowsys_ndf/server_settings.py | grep -w GSTUDIO_INSTITUTE_NAME | sed 's/.*=//g')) | sed "s/'//g" | sed 's/"//g'`

syncthing_base_directory="/backups/syncthing";
syncthing_year_directory="${syncthing_base_directory}/${cur_year}";
syncthing_variable_directory="${cur_year}/${state_code}/${ss_code}-${ss_id}/${platform}";
syncthing_sync_content_source="/data/gstudio-exported-users-analytics-csvs  /data/gstudio_tools_logs  /data/activity-timestamp-csvs  /home/docker/code/gstudio/gnowsys-ndf/gnowsys_ndf/server_settings.py  /home/docker/code/gstudio/gnowsys-ndf/gnowsys_ndf/local_settings.py  /data/git-commit-details.log  /data/system-heartbeat  /data/qbank/qbank_data.tar.gz"
syncthing_sync_content_destination="${syncthing_base_directory}/${syncthing_variable_directory}";

# ---------------------------------- x ---------------------------------- 

echo -e "\nPostgres backup file exist. So performing incremental backup \n".
if [ ! -d /data/postgres-dump ]; then
    mkdir /data/postgres-dump
fi
echo "pg_dumpall > pg_dump_all.sql;" | sudo su - postgres ;   

mv /var/lib/postgresql/pg_dump_all.sql /data/postgres-dump/

# ---------------------------------- x ---------------------------------- 

echo -e "\nBackup /home/docker/code/gstudio/gnowsys-ndf/qbank-lite/webapps/CLIx/datastore/studentResponseFiles in /data/assessment-media/ \n" 
rsync -avzPh   /home/docker/code/gstudio/gnowsys-ndf/qbank-lite/webapps/CLIx/datastore/studentResponseFiles  /data/assessment-media/

echo -e "\nBackup local_settings.py(/home/docker/code/gstudio/gnowsys-ndf/gnowsys_ndf/local_settings.py) and server_settings.py(/home/docker/code/gstudio/gnowsys-ndf/gnowsys_ndf/server_settings.py) in /data/ \n" 
rsync -avzPh /home/docker/code/gstudio/gnowsys-ndf/gnowsys_ndf/local_settings.py /home/docker/code/gstudio/gnowsys-ndf/gnowsys_ndf/server_settings.py  /data/

# ---------------------------------- x ---------------------------------- 

# Add soft link for analytics progressCSV file
if [[ ! -L /softwares/gstudio-exported-users-analytics-csvs ]]; then
    ln -s /data/gstudio-exported-users-analytics-csvs  /softwares/gstudio-exported-users-analytics-csvs
fi

# Add soft link for gstudio_tools_logs file
if [[ ! -L /softwares/gstudio_tools_logs ]]; then
    ln -s /data/gstudio_tools_logs  /softwares/gstudio_tools_logs
fi

# Add soft link for activity-timestamp-csvs file
if [[ ! -L /softwares/activity-timestamp-csvs ]]; then
    ln -s /data/activity-timestamp-csvs  /softwares/activity-timestamp-csvs
fi

# Add soft link for assessment-media file
if [[ ! -L /softwares/assessment-media/studentResponseFiles ]]; then
    if [[ ! -d /softwares/assessment-media ]]; then
        mkdir -p /softwares/assessment-media
    fi
    ln -s /home/docker/code/gstudio/gnowsys-ndf/qbank-lite/webapps/CLIx/datastore/studentResponseFiles  /softwares/assessment-media/studentResponseFiles
fi

# Add soft link for qbank_data.tar.gz file
if [[ ! -L /softwares/qbank_data.tar.gz ]]; then
    if [[ -f /data/qbank/qbank_data.tar.gz ]]; then
        ln -s /data/qbank/qbank_data.tar.gz  /softwares/qbank_data.tar.gz
    else
        echo -e "Source file not found. {Source filename: /data/qbank/qbank_data.tar.gz}"
    fi
fi

# ---------------------------------- x ---------------------------------- 

# log commit details - in /data/git-commit-details.log - started
echo -e "\nDate : $(date) \n" > /data/git-commit-details.log

echo -e "\n\nDetails of gstudio-docker \n" 2>&1 | tee -a /data/git-commit-details.log
cd /home/docker/code/

echo -e "\ngstudio-docker : $(pwd) \n" 2>&1 | tee -a /data/git-commit-details.log
$(pwd)

echo -e "\ngstudio-docker : git branch \n" 2>&1 | tee -a /data/git-commit-details.log
git branch 2>&1 | tee -a /data/git-commit-details.log

echo -e "\ngstudio-docker : git log - latest 5 commits \n" 2>&1 | tee -a /data/git-commit-details.log
git log -n 5 2>&1 | tee -a /data/git-commit-details.log

echo -e "\ngstudio-docker : git status \n" 2>&1 | tee -a /data/git-commit-details.log
git status 2>&1 | tee -a /data/git-commit-details.log

echo -e "\ngstudio-docker : git diff \n" 2>&1 | tee -a /data/git-commit-details.log
git diff 2>&1 | tee -a /data/git-commit-details.log


echo -e "\n\nDetails of gstudio \n" 2>&1 | tee -a /data/git-commit-details.log
cd /home/docker/code/gstudio/

echo -e "\ngstudio : $(pwd) \n" 2>&1 | tee -a /data/git-commit-details.log
$(pwd)

echo -e "\ngstudio : git branch \n" 2>&1 | tee -a /data/git-commit-details.log
git branch 2>&1 | tee -a /data/git-commit-details.log

echo -e "\ngstudio : git log - latest 5 commits \n" 2>&1 | tee -a /data/git-commit-details.log
git log -n 5 2>&1 | tee -a /data/git-commit-details.log

echo -e "\ngstudio : git status \n" 2>&1 | tee -a /data/git-commit-details.log
git status 2>&1 | tee -a /data/git-commit-details.log

echo -e "\ngstudio : git diff \n" 2>&1 | tee -a /data/git-commit-details.log
git diff 2>&1 | tee -a /data/git-commit-details.log


echo -e "\n\nDetails of OpenAssessmentsClient \n" 2>&1 | tee -a /data/git-commit-details.log
cd /home/docker/code/OpenAssessmentsClient/

echo -e "\n'OpenAssessmentsClient' - strategy adopted for updating oac and oat is as follows: \n
- Building 'oac' and 'oat' locally from 'gnowledge/OpenAssessmentsClient' with 'clixserver' branch. \n
- Testing it locally and packaging oac, oat as a replacement. \n
- This decision is taken because building oac and oat is network dependent operation and sometimes build doesn't happen smoothly. \n\n" 2>&1 | tee -a /data/git-commit-details.log

# echo -e "\nOpenAssessmentsClient : $(pwd) \n" 2>&1 | tee -a /data/git-commit-details.log
# $(pwd)

# echo -e "\nOpenAssessmentsClient : git branch \n" 2>&1 | tee -a /data/git-commit-details.log
# git branch 2>&1 | tee -a /data/git-commit-details.log

# echo -e "\nOpenAssessmentsClient : git log - latest 5 commits \n" 2>&1 | tee -a /data/git-commit-details.log
# git log -n 5 2>&1 | tee -a /data/git-commit-details.log

# echo -e "\nOpenAssessmentsClient : git status \n" 2>&1 | tee -a /data/git-commit-details.log
# git status 2>&1 | tee -a /data/git-commit-details.log

# echo -e "\nOpenAssessmentsClient : git diff \n" 2>&1 | tee -a /data/git-commit-details.log
# git diff 2>&1 | tee -a /data/git-commit-details.log


echo -e "\n\nDetails of qbank-lite \n" 2>&1 | tee -a /data/git-commit-details.log
cd /home/docker/code/gstudio/gnowsys-ndf/qbank-lite/

echo -e "\nqbank-lite : $(pwd) \n" 2>&1 | tee -a /data/git-commit-details.log
$(pwd)

echo -e "\nqbank-lite : git branch \n" 2>&1 | tee -a /data/git-commit-details.log
git branch 2>&1 | tee -a /data/git-commit-details.log

echo -e "\nqbank-lite : git log - latest 5 commits \n" 2>&1 | tee -a /data/git-commit-details.log
git log -n 5 2>&1 | tee -a /data/git-commit-details.log

echo -e "\nqbank-lite : git status \n" 2>&1 | tee -a /data/git-commit-details.log
git status 2>&1 | tee -a /data/git-commit-details.log

echo -e "\nqbank-lite : git diff \n" 2>&1 | tee -a /data/git-commit-details.log
git diff 2>&1 | tee -a /data/git-commit-details.log


echo -e "\nDate : $(date) \n" >> /data/git-commit-details.log
# log commit details - in /data/git-commit-details.log - ended

if [[ ! -d ${syncthing_sync_content_destination} ]]; then
    mkdir -p ${syncthing_sync_content_destination};
fi


if [[ ! -f /${syncthing_base_directory}/.stfolder ]]; then
    touch  /${syncthing_base_directory}/.stfolder;
fi

if [[ ! -f /${syncthing_base_directory}/.stignore ]]; then
    touch  /${syncthing_base_directory}/.stignore;
fi


if [[ ! -f /${syncthing_year_directory}/.stfolder ]]; then
    touch  /${syncthing_year_directory}/.stfolder;
fi

if [[ ! -f /${syncthing_year_directory}/.stignore ]]; then
    touch  /${syncthing_year_directory}/.stignore;
fi

if [[ ! -f /${syncthing_year_directory}/.gnupg ]]; then
    rsync -avPh /root/.gnupg  /${syncthing_year_directory}/.gnupg;
fi

# ---------------------------------- x ---------------------------------- 

echo -e "\nCopy content for syncing via syncthing"
rsync -avzPh ${syncthing_sync_content_source}  ${syncthing_sync_content_destination}/;

echo -e "\nCopy content for syncing via syncthing also in /softwares"
rsync -avzPh ${syncthing_base_directory} /softwares/;

# ---------------------------------- x ---------------------------------- 

echo -e "\nCreate tar file of the syncthing content"
cd /backups/
tar -cvzf ${ss_code}-${ss_id}-syncthing.tar.gz syncthing 

# Add soft link for analytics tar.gz file
if [[ ! -L /softwares/${ss_code}-${ss_id}-syncthing.tar.gz ]]; then
    ln -s /backups/${ss_code}-${ss_id}-syncthing.tar.gz  /softwares/${ss_code}-${ss_id}-syncthing.tar.gz
fi

# Ref: https://stackoverflow.com/questions/9981570/copying-tarring-files-that-have-been-modified-in-the-last-14-days
echo -e "\nCreate tar file of the analytics csvs for last 24hrs, last 7days and last 30days"
cd  /softwares/syncthing/${syncthing_variable_directory}/
echo "tar cvzf  ${ss_code}-${ss_id}-progressCSV.tar gstudio-exported-users-analytics-csvs   ;    /softwares/syncthing/${syncthing_variable_directory} ; $(pwd)"
tar cvzf  ${ss_code}-${ss_id}-progressCSV.tar.gz gstudio-exported-users-analytics-csvs
if [[ ! -L /softwares/${ss_code}-${ss_id}-progressCSV.tar.gz ]]; then
    ln -s /softwares/syncthing/${syncthing_variable_directory}/${ss_code}-${ss_id}-progressCSV.tar.gz  /softwares/${ss_code}-${ss_id}-progressCSV.tar.gz
fi
cd  /softwares/syncthing/${syncthing_variable_directory}/
find gstudio-exported-users-analytics-csvs -name "*.csv" -mtime  0  -print | xargs tar cvzf ${ss_code}-${ss_id}-progressCSV-last-24hrs.tar.gz
if [[ ! -L /softwares/${ss_code}-${ss_id}-progressCSV-last-24hrs.tar.gz ]]; then
    ln -s /softwares/syncthing/${syncthing_variable_directory}/${ss_code}-${ss_id}-progressCSV-last-24hrs.tar.gz  /softwares/${ss_code}-${ss_id}-progressCSV-last-24hrs.tar.gz
fi
find gstudio-exported-users-analytics-csvs -name "*.csv" -mtime -7  -print | xargs tar cvzf ${ss_code}-${ss_id}-progressCSV-last-7days.tar.gz
if [[ ! -L /softwares/${ss_code}-${ss_id}-progressCSV-last-7days.tar.gz ]]; then
    ln -s /softwares/syncthing/${syncthing_variable_directory}/${ss_code}-${ss_id}-progressCSV-last-7days.tar.gz  /softwares/${ss_code}-${ss_id}-progressCSV-last-7days.tar.gz
fi
find gstudio-exported-users-analytics-csvs -name "*.csv" -mtime -30 -print | xargs tar cvzf ${ss_code}-${ss_id}-progressCSV-last-30days.tar.gz
if [[ ! -L /softwares/${ss_code}-${ss_id}-progressCSV-last-30days.tar.gz ]]; then
    ln -s /softwares/syncthing/${syncthing_variable_directory}/${ss_code}-${ss_id}-progressCSV-last-30days.tar.gz  /softwares/${ss_code}-${ss_id}-progressCSV-last-30days.tar.gz
fi

# ---------------------------------- x ---------------------------------- 

echo -e "\nCreate tar file of the gstudio_tools_logs content"
cd /data/
tar -cvzf ${ss_code}-${ss_id}-gstudio_tools_logs.tar.gz gstudio_tools_logs 

# Add soft link for analytics tar.gz file
if [[ ! -L /softwares/${ss_code}-${ss_id}-gstudio_tools_logs.tar.gz ]]; then
    ln -s /data/${ss_code}-${ss_id}-gstudio_tools_logs.tar.gz  /softwares/${ss_code}-${ss_id}-gstudio_tools_logs.tar.gz
fi

# ---------------------------------- x ---------------------------------- 

echo -e "\nCreate tar file of the activity-timestamp-csvs content"
cd /data/
tar -cvzf ${ss_code}-${ss_id}-activity-timestamp-csvs.tar.gz activity-timestamp-csvs 

# Add soft link for activity-timestamp tar.gz file
if [[ ! -L /softwares/${ss_code}-${ss_id}-activity-timestamp-csvs.tar.gz ]]; then
    ln -s /data/${ss_code}-${ss_id}-activity-timestamp-csvs.tar.gz  /softwares/${ss_code}-${ss_id}-activity-timestamp-csvs.tar.gz
fi

# ---------------------------------- x ---------------------------------- 

echo -e "\nCreate tar file of the assessment-media content"
cd /data/
tar -cvzf ${ss_code}-${ss_id}-assessment-media.tar.gz assessment-media 

# Add soft link for assessment-media tar.gz file
if [[ ! -L /softwares/${ss_code}-${ss_id}-assessment-media.tar.gz ]]; then
    ln -s /data/${ss_code}-${ss_id}-assessment-media.tar.gz  /softwares/${ss_code}-${ss_id}-assessment-media.tar.gz
fi

# ---------------------------------- x ---------------------------------- 
