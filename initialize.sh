#!/bin/bash

#--------------------------------------------------------------------------------------------------------------#
# File name   : git-pull.sh
# File creation : Mrunal M. Nachankar : Mon, 07-09-2015 12:15:AM 
# Description :
#               get updated additional schema STs, ATs and RTs
#				start mongod
#				syncdb
#				create superuser
#				create or update gstudio schema in mongodb
#				Check git diff
#
# Last Modification : Mrunal M. Nachankar : Mon, 07-09-2015 12:15:AM 
#				property_order_reset
#				Sync_existing
#				Snapshot
#				git pull
#				smtpd - localhost
#--------------------------------------------------------------------------------------------------------------#


echo "[run] start mongod"
mongod &
sleep 60

echo "[run] go to the code folder"
cd /home/docker/code/gstudio/gnowsys-ndf/

echo "[run] git-pull" 													# Mrunal M. Nachankar : Mon, 07-09-2015 12:15:AM 
sh /home/docker/code/git-pull.sh 										# Mrunal M. Nachankar : Mon, 07-09-2015 12:15:AM 

echo "[run] Git Pull completed "

echo "[run] syncdb"
python manage.py syncdb --noinput

echo "[run] create superuser"
echo "from django.contrib.auth.models import User
if not User.objects.filter(username='admin').count():
    User.objects.create_superuser('administrator', 'admin@example.com', 'changeit')
" | python manage.py shell

# the above script is suggested by
# https://github.com/novapost/docker-django-demo

echo "[run] get updated additional schema STs, ATs and RTs"
cp /home/docker/code/gstudio/doc/schema_directory/* /home/docker/code/gstudio/gnowsys-ndf/gnowsys_ndf/ndf/management/commands/schema_files/

echo "[run] create or update gstudio schema in mongodb"
python manage.py filldb
python manage.py create_schema STs_run1.csv
python manage.py create_schema ATs.csv
python manage.py create_schema RTs.csv
python manage.py create_schema STs_run2.csv
#python manage.py filldb      											# Mrunal M. Nachankar : Mon, 07-09-2015 12:15:AM 

echo "[run] property_order_reset"										# Mrunal M. Nachankar : Mon, 07-09-2015 12:15:AM 
echo "execfile('property_order_reset.py')" | python manage.py shell		# Mrunal M. Nachankar : Mon, 07-09-2015 12:15:AM 

echo "[run] Sync_existing"												# Mrunal M. Nachankar : Mon, 07-09-2015 12:15:AM 
python manage.py sync_existing_documents								# Mrunal M. Nachankar : Mon, 07-09-2015 12:15:AM 

echo "[run] Snapshot"													# Mrunal M. Nachankar : Mon, 07-09-2015 12:15:AM 
python manage.py Sync_Snapshot_feild									# Mrunal M. Nachankar : Mon, 07-09-2015 12:15:AM 

echo "[run] smtpd.sh"													# Mrunal M. Nachankar : Mon, 07-09-2015 12:15:AM 
sh /home/docker/code/smtpd.sh 											# Mrunal M. Nachankar : Mon, 07-09-2015 12:15:AM 

supervisord -n

