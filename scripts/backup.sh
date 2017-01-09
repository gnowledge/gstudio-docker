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

echo -e "\nCounter backup file exist. So performing incremental backup \n".
mkdir /data/counters-dump
cd /data/counters-dump
mongodump --db gstudio-mongodb --collection Counters --out .

echo -e "\nPostgres backup file exist. So performing incremental backup \n".
mkdir /data/postgres-dump
echo "pg_dumpall > pg_dump_all.sql;
" | sudo su - postgres ;   

mv /var/lib/postgresql/pg_dump_all.sql /data/postgres-dump


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
cd /home/docker/code/gstudio/gnowsys-ndf/
python manage.py fillCounter

ss_id=`echo $(more /home/docker/code/gstudio/gnowsys-ndf/gnowsys_ndf/server_settings.py | sed 's/.*=//')`
ss_id1=`echo $ss_id | sed "s/'//g"`

mkdir -p /backups/rsync/$ss_id1

echo -e "\nBackup via rsync in process please be patient"
rsync -avzPh  /data/media /data/rcs-repo /data/benchmark-dump /data/counters-dump /data/gstudio-exported-users-analytics-csvs  /backups/rsync/$ss_id1/       # /backups/db/ /backups/incremental/

#cp -av /root/.gnupg /backups/incremental/
cp -av /root/.gnupg /backups/rsync/

touch /backups/.stfolder
touch /backups/rsync/.stfolder

#chmod 644 /backups/incremental/*
chmod 644 /backups/rsync/*
