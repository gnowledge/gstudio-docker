#!/bin/bash

# Script for git pull
# Default branch name is master

branch_name="$1";
if [[ "$1" == "" ]]; then
    echo -e 'Please provide the branch names like: \n   1. master \n   2. alpha \n   3. mongokit \n   4. dlkit  \n';
    read branch_name ;
fi
    
echo -e "USER input : $branch_name";
branch_name="alpha";


udate="$(date +%Y%m%d-%H%M%S)"
mkdir -p /home/docker/code/git-update/$udate


echo "Server update (git) starting"

echo "[run] enabling maintenance templete"
mv /home/docker/code/maintenance/maintenance.disable /home/docker/code/maintenance/maintenance.enable

echo "[run] go to the code folder - gstudio"
cd /home/docker/code/gstudio/

echo "[run] Execute git logs (before)"
git log >> /home/docker/code/git-update/$udate/git-update-before.log

echo "[run] Execute git status"
git status

echo "[run] Execute git diff"
git diff

echo "[run] Execute git stash"
git stash




echo "[run] Git Pull started"

echo "[run] Execute git pull"
git pull origin $branch_name 

echo "[run] Git Pull completed"


echo "[run] Execute git stash"
git stash apply

echo "[run] Execute git stash drop"
git stash drop

echo "[run] Execute git status"
git status

echo "[run] Execute git diff"
git diff


echo "[run] go to the code folder - gstudio/gnowsys-dev"
cd /home/docker/code/gstudio/gnowsys-ndf/

# echo "[run] get updated additional schema STs, ATs and RTs"
# cp -v /home/docker/code/gstudio/doc/schema_directory/* /home/docker/code/gstudio/gnowsys-ndf/gnowsys_ndf/ndf/management/commands/schema_files/

# echo "[run] create or update gstudio schema in mongodb"
# python manage.py syncdb                                                    # Mrunal M. Nachankar : Mon, 22-02-2016 01:00:PM : "--noinput" argument not needed as by now we have a default user as administrator 
# python manage.py filldb
# python manage.py create_schema STs_run1.csv
# python manage.py create_schema ATs.csv
# python manage.py create_schema RTs.csv
# python manage.py create_schema STs_run2.csv


echo "[run] fab update_data"										# Mrunal M. Nachankar : Mon, 05-03-2017 06:06:AM 
fab update_data	   # Mrunal M. Nachankar : Mon, 05-03-2017 06:06:AM 


echo "[run] property_order_reset"										# Mrunal M. Nachankar : Mon, 07-09-2015 12:15:AM 
echo "execfile('property_order_reset.py')" | python manage.py shell	   # Mrunal M. Nachankar : Mon, 07-09-2015 12:15:AM 

echo "[run] create_auth_objs.py" ;							   # Mrunal M. Nachankar : Mon, 07-09-2015 12:15:AM 
echo "execfile('../doc/deployer/create_auth_objs.py')" | python manage.py shell ;	   # Mrunal M. Nachankar : Mon, 07-09-2015 12:15:AM 

echo "[run] Sync_existing"						   # Mrunal M. Nachankar : Mon, 07-09-2015 12:15:AM 
python manage.py sync_existing_documents				   # Mrunal M. Nachankar : Mon, 07-09-2015 12:15:AM 


echo "[run] Execute git logs (after)"
git log >> /home/docker/code/git-update/$udate/git-update-after.log


echo "[run] Bower install"
bower install --allow-root

echo "[run] collectstatic"
echo yes | python manage.py collectstatic


echo "[run] enabling maintenance templete"
mv /home/docker/code/maintenance/maintenance.enable /home/docker/code/maintenance/maintenance.disable

echo "Server update (git) finished successfully"
