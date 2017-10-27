#!/bin/bash


#--------------------------------------------------------------------#
# Backup of gstudio 
# File name    : Backup-script-mrunal.sh
# File version : 1.0
# Created by   : Mr. Mrunal M. Nachankar
# Created on   : 26-06-2014 12:04:AM
# Modified by  : None
# Modified on  : Not yet
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

# echo -e "\nBenchmark backup file exist. So performing incremental backup \n".
# mkdir /data/benchmark-dump
# cd /data/benchmark-dump
# mongodump --db gstudio-mongodb --collection Benchmarks --out .

# echo -e "\nCounter backup file exist. So performing incremental backup \n".
# if [ ! -d /data/counters-dump ]; then
#     mkdir /data/counters-dump
# fi
# cd /data/counters-dump
# mongodump --db gstudio-mongodb --collection Counters --out .

echo -e "\nPostgres backup file exist. So performing incremental backup \n".
if [ ! -d /data/postgres-dump ]; then
    mkdir /data/postgres-dump
fi
echo "pg_dumpall > pg_dump_all.sql;" | sudo su - postgres ;   

mv /var/lib/postgresql/pg_dump_all.sql /data/postgres-dump/


# if [[ "$(ls -ltr /backups/incremental/*full*.gpg | wc -l)" -le "2" ]]; then
#     echo -e "\n Full backup files does not exist. So performing full backup \n".
#     cd /home/docker/code/duplicity/
#     ./duplicity-backup.sh --full
# elif [[ "$(ls -ltr /backups/incremental/*full*.gpg | wc -l)" -ge "3" ]]; then
#     echo -e "\n Full backup file exist. So performing incremental backup \n".
#     cd /home/docker/code/duplicity/
#     ./duplicity-backup.sh --backup
# fi


# change directory and fillcounter
# cd /home/docker/code/gstudio/gnowsys-ndf/
# python manage.py fillCounter

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

if [[ -d /backups/rsync/$ss_id ]]; then
    rm -rf /backups/rsync/$ss_id
elif [[ -d /backups/rsync/${ss_code}-${ss_id} ]]; then
    rm -rf /backups/rsync/${ss_code}-${ss_id}
elif [[ ! -d /backups/rsync/${cur_year}/${state_code}/${ss_code}-${ss_id}/${platform}/gstudio-exported-users-analytics-csvs ]]; then
    mkdir -p /backups/rsync/${cur_year}/${state_code}/${ss_code}-${ss_id}/${platform}/gstudio-exported-users-analytics-csvs
fi

if [[ -d /backups/syncthing/$ss_id ]]; then
    rm -rf /backups/syncthing/$ss_id /tmp/
elif [[ -d /backups/syncthing/${ss_code}-${ss_id} ]]; then
    rm -rf /backups/syncthing/${ss_code}-${ss_id}
elif [[ ! -d /backups/syncthing/${cur_year}/${state_code}/${ss_code}-${ss_id}/${platform}/gstudio-exported-users-analytics-csvs ]]; then
    mkdir -p /backups/syncthing/${cur_year}/${state_code}/${ss_code}-${ss_id}/${platform}/gstudio-exported-users-analytics-csvs
fi

if [[ -d /backups/$ss_id ]]; then
    rm -rf /backups/$ss_id
elif [[ -d /backups/${ss_code}-${ss_id} ]]; then
    rm -rf /backups/${ss_code}-${ss_id}
elif [[ ! -d /backups/${cur_year}/${state_code}/${ss_code}-${ss_id}/${platform}/gstudio-exported-users-analytics-csvs ]]; then
    mkdir -p /backups/${cur_year}/${state_code}/${ss_code}-${ss_id}/${platform}/gstudio-exported-users-analytics-csvs
fi

if [[ ! -d /root/Sync ]]; then
    mkdir -p /root/Sync
fi


if [[ -d /tmp/$ss_id ]]; then
    rm -rf /tmp/$ss_id 
elif [[ -d /tmp/${ss_code}-${ss_id} ]]; then
    rm -rf /tmp/${ss_code}-${ss_id}
elif [[ ! -d /tmp/${cur_year}/${state_code}/${ss_code}-${ss_id}/${platform}/gstudio-exported-users-analytics-csvs ]]; then
    mkdir -p /tmp/${cur_year}/${state_code}/${ss_code}-${ss_id}/${platform}/gstudio-exported-users-analytics-csvs
fi
# mkdir /tmp/${cur_year}/${state_code}/${ss_code}-${ss_id}/${platform}/gstudio-exported-users-analytics-csvs/
rsync -avzPh  /data/gstudio-exported-users-analytics-csvs  /home/docker/code/gstudio/gnowsys-ndf/gnowsys_ndf/server_settings.py /data/git-commit-details.log /data/system-heartbeat  /tmp/${cur_year}/${state_code}/${ss_code}-${ss_id}/${platform}/

cd /tmp/

echo -e "\nCreate tar file of the analytics csvs"
tar -cvzf ${ss_code}-${ss_id}.tar.gz ${cur_year} 

echo -e "\nBackup gstudio-exported-users-analytics-csvs (Qunatitative research data / analytics data) - via rsync in process please be patient"
#rsync -avzPh  /data/media /data/rcs-repo /data/benchmark-dump /data/counters-dump /data/gstudio-exported-users-analytics-csvs  /backups/rsync/$ss_id/
rsync -avzPh  /tmp/${ss_code}-${ss_id}.tar.gz  /backups/rsync/${ss_code}-${ss_id}/

#echo -e "\nBackup user analytics - via rsync in process please be patient"
#rsync -avzPh  /data/gstudio-exported-users-analytics-csvs  /backups/syncthing/$ss_id/

cp -av /root/.gnupg /backups/rsync/${cur_year}/${state_code}/${ss_code}-${ss_id}/${platform}/gstudio-exported-users-analytics-csvs/

touch /backups/${cur_year}/${state_code}/${ss_code}-${ss_id}/${platform}/gstudio-exported-users-analytics-csvs/.stfolder
touch /backups/${cur_year}/${state_code}/${ss_code}-${ss_id}/${platform}/gstudio-exported-users-analytics-csvs/.stignore
touch /backups/rsync/${cur_year}/${state_code}/${ss_code}-${ss_id}/${platform}/gstudio-exported-users-analytics-csvs/.stfolder
touch /backups/rsync/${cur_year}/${state_code}/${ss_code}-${ss_id}/${platform}/gstudio-exported-users-analytics-csvs/.stignore

touch /root/Sync/.stfolder
touch /root/Sync/.stignore
chmod +rx /root/Sync/*

#chmod 644 /backups/incremental/*
chmod +rx /backups/rsync/*


touch /backups/syncthing${cur_year}/${state_code}/${ss_code}-${ss_id}/${platform}/gstudio-exported-users-analytics-csvs/.stfolder
touch /backups/syncthing${cur_year}/${state_code}/${ss_code}-${ss_id}/${platform}/gstudio-exported-users-analytics-csvs/.stignore

#chmod 644 /backups/incremental/*
chmod +x /backups/syncthing/*

# Remove old analytics tar.gz file
if [[ -f /backups/rsync/${ss_id}/${ss_id}.tar.gz ]]; then
    rm /backups/rsync/${ss_id}/${ss_id}.tar.gz
fi

if [[ -L /softwares/${ss_id}/${ss_id}.tar.gz ]]; then
    rm /softwares/${ss_id}/${ss_id}.tar.gz
fi

# Add soft link for analytics tar.gz file
if [[ ! -L /softwares/${ss_code}-${ss_id}.tar.gz ]]; then
    ln -s /backups/rsync/${ss_code}-${ss_id}/${ss_code}-${ss_id}.tar.gz  /softwares/${ss_code}-${ss_id}.tar.gz
fi

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



echo -e "\nBackup /home/docker/code/gstudio/gnowsys-ndf/qbank-lite/webapps/CLIx/datastore/* in /data/assessment-media/ \n" 
rsync -avzPh   /home/docker/code/gstudio/gnowsys-ndf/qbank-lite/webapps/CLIx/datastore/*  /data/assessment-media/

echo -e "\nBackup local_settings.py(/home/docker/code/gstudio/gnowsys-ndf/gnowsys_ndf/local_settings.py) and server_settings.py(/home/docker/code/gstudio/gnowsys-ndf/gnowsys_ndf/server_settings.py) in /data/ \n" 
rsync -avzPh /home/docker/code/gstudio/gnowsys-ndf/gnowsys_ndf/local_settings.py /home/docker/code/gstudio/gnowsys-ndf/gnowsys_ndf/server_settings.py  /data/
