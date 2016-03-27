#!/bin/bash

# Script for git pull
# Default branch name is mongokit

branch_name="mongokit"

echo "[run] go to the code folder - gstudio"
cd /home/docker/code/gstudio/

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

echo "[run] Execute git status"
git status

echo "[run] Execute git diff"
git diff


echo "[run] go to the code folder - gstudio/gnowsys-dev"
cd /home/docker/code/gstudio/gnowsys-ndf/

echo "[run] get updated additional schema STs, ATs and RTs"
cp -v /home/docker/code/gstudio/doc/schema_directory/* /home/docker/code/gstudio/gnowsys-ndf/gnowsys_ndf/ndf/management/commands/schema_files/

echo "[run] create or update gstudio schema in mongodb"
python manage.py syncdb                                                    # Mrunal M. Nachankar : Mon, 22-02-2016 01:00:PM : "--noinput" argument not needed as by now we have a default user as administrator 
python manage.py filldb
python manage.py create_schema STs_run1.csv
python manage.py create_schema ATs.csv
python manage.py create_schema RTs.csv
python manage.py create_schema STs_run2.csv
#python manage.py filldb      						   # Mrunal M. Nachankar : Mon, 07-09-2015 12:15:AM : Suggested by Rachna/GN

echo "[run] property_order_reset"										# Mrunal M. Nachankar : Mon, 07-09-2015 12:15:AM 
echo "execfile('property_order_reset.py')" | python manage.py shell	   # Mrunal M. Nachankar : Mon, 07-09-2015 12:15:AM 

echo "[run] Sync_existing"						   # Mrunal M. Nachankar : Mon, 07-09-2015 12:15:AM 
python manage.py sync_existing_documents				   # Mrunal M. Nachankar : Mon, 07-09-2015 12:15:AM 
