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
# Last Modification : Mrunal M. Nachankar : Mon, 07-09-2015 12:15:AM 
#				starting most of the services - mongodb, cron, postgresql, postfix, ssh
#				create deafult database and user to access postgres
#				Replaced username='admin' with username='administrator' 
#				git pull
#				smtpd - localhost
#--------------------------------------------------------------------------------------------------------------#

# Executing script as sourcing because we need to set GNUM_ARC variable from /home/docker/code/scripts/numa-arch-check.sh. Soc that we can use it here
. /home/docker/code/scripts/numa-arch-check.sh ;
echo "numa arch : " $GNUM_ARC ;

if [ $GNUM_ARC == "NO" ]; then
    echo "[run] start mongod";
    mongod  --config /home/docker/code/confs/mongod.conf & 
elif [ $GNUM_ARC == "YES" ]; then
    echo "[run] start mongod with numactcl";
    numactl --interleave=all mongod  --config /home/docker/code/confs/mongod.conf & 
else
    echo "No idea about arch hence starting normally.";
    echo "[run] start mongod";
    mongod  --config /home/docker/code/confs/mongod.conf & 
fi
sleep 60;

echo "Starting cron service {Crontab}" ;
/usr/sbin/cron ;

#echo "[run] start postgresql" ;     # Used for postgres db
#/etc/init.d/postgresql start ;      # Used for postgres db

echo "[run] start postfix" ;
/etc/init.d/postfix start ;

echo "[run] start ssh" ;
/etc/init.d/ssh start ;

echo "[run] go to the code folder" ;
cd /home/docker/code/gstudio/gnowsys-ndf/ ;

echo "[run] git-pull started" ;					    			# Mrunal M. Nachankar : Mon, 07-09-2015 12:15:AM 
#bash /home/docker/code/git-pull.sh ;						# Mrunal M. Nachankar : Mon, 07-09-2015 12:15:AM 
echo "[run] git-pull completed" ;

echo "[run] create deafult database and user to access postgres" ;
echo "psql
CREATE DATABASE gstudio_psql;
CREATE USER glab WITH PASSWORD 'Gstudi02)1^';
ALTER ROLE glab SET client_encoding TO 'utf8';
ALTER ROLE glab SET default_transaction_isolation TO 'read committed';
ALTER ROLE glab SET timezone TO 'UTC';
GRANT ALL PRIVILEGES ON DATABASE gstudio_psql TO glab;
" | sudo su - postgres ;   

echo "[run] syncdb" ;
python manage.py syncdb --noinput ;

echo "[run] create superuser" ;
echo "from django.contrib.auth.models import User
if not User.objects.filter(username='administrator').count():
    User.objects.create_superuser('administrator', 'admin@example.com', 'changeit')
" | python manage.py shell ;

# the above script is suggested by
# https://github.com/novapost/docker-django-demo

echo "[run] get updated additional schema STs, ATs and RTs" ;
cp -v /home/docker/code/gstudio/doc/schema_directory/* /home/docker/code/gstudio/gnowsys-ndf/gnowsys_ndf/ndf/management/commands/schema_files/ ;

echo "[run] create or update gstudio schema in mongodb" ;
python manage.py filldb ;
python manage.py create_schema STs_run1.csv ; 
python manage.py create_schema ATs.csv ;
python manage.py create_schema RTs.csv ; 
python manage.py create_schema STs_run2.csv ;
#python manage.py filldb ;     						   # Mrunal M. Nachankar : Mon, 07-09-2015 12:15:AM : Suggested by Rachna/GN

echo "[run] property_order_reset" ;							   # Mrunal M. Nachankar : Mon, 07-09-2015 12:15:AM 
echo "execfile('property_order_reset.py')" | python manage.py shell ;	   # Mrunal M. Nachankar : Mon, 07-09-2015 12:15:AM 

echo "[run] create_auth_objs.py" ;							   # Mrunal M. Nachankar : Mon, 07-09-2015 12:15:AM 
echo "execfile('../doc/deployer/create_auth_objs.py')" | python manage.py shell ;	   # Mrunal M. Nachankar : Mon, 07-09-2015 12:15:AM 

echo "[run] Sync_existing" ;						   # Mrunal M. Nachankar : Mon, 07-09-2015 12:15:AM 
python manage.py sync_existing_documents ;				   # Mrunal M. Nachankar : Mon, 07-09-2015 12:15:AM 

echo "[run] Snapshot" ;							   # Mrunal M. Nachankar : Mon, 07-09-2015 12:15:AM 
#python manage.py Sync_Snapshot_feild ;					   # Mrunal M. Nachankar : Mon, 07-09-2015 12:15:AM 

echo "[run] smtpd.sh" ;							   # Mrunal M. Nachankar : Mon, 07-09-2015 12:15:AM 
bash /home/docker/code/scripts/smtpd.sh ; 						   # Mrunal M. Nachankar : Mon, 07-09-2015 12:15:AM 

echo "[run] generate-self-certified-certificate-ssl..sh" ;				   # Mrunal M. Nachankar : Mon, 07-09-2015 12:15:AM 
bash /home/docker/code/scripts/generate-self-certified-certificate-ssl.sh ; 		   # Mrunal M. Nachankar : Mon, 07-09-2015 12:15:AM 

echo "[run] school server gpg setup" ;
bash /home/docker/code/scripts/ss-gpg-setup.sh

echo "[run] supervisord" ;
supervisord -n ;

