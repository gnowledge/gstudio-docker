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
# Last Modification : Mrunal M. Nachankar : Mon, 20-11-2017 12:15:PM 
#				move the places of logs
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
#sleep 60;

echo "Starting cron service {Crontab}" ;
/usr/sbin/cron ;

echo "[run] start postgresql" ;     # Used for postgres db
/etc/init.d/postgresql start ;      # Used for postgres db
#/etc/init.d/postgresql status ;      # Used for postgres db

echo "[run] start postfix" ;
/etc/init.d/postfix start ;

echo "[run] start ssh" ;
/etc/init.d/ssh start ;

echo "[run] start memcache" ;
/etc/init.d/memcached start

echo "[run] start rabbitmq-server" ;
/etc/init.d/rabbitmq-server start 

echo "[run] go to the code folder" ;
cd /home/docker/code/gstudio/gnowsys-ndf/ ;

echo "[run] start celery"
export C_FORCE_ROOT="true"
python manage.py celeryd -f /var/log/celeryd.log  -l INFO &

# echo "[run] git-pull started" ;					    			# Mrunal M. Nachankar : Mon, 07-09-2015 12:15:AM 
# #bash /home/docker/code/git-pull.sh ;						# Mrunal M. Nachankar : Mon, 07-09-2015 12:15:AM 
# echo "[run] git-pull completed" ;

# echo "[run] create deafult database and user to access postgres" ;
# echo "psql
#         CREATE DATABASE gstudio_psql;
#         CREATE USER glab WITH PASSWORD 'Gstudi02)1^';
#         ALTER ROLE glab SET client_encoding TO 'utf8';
#         ALTER ROLE glab SET default_transaction_isolation TO 'read committed';
#         ALTER ROLE glab SET timezone TO 'UTC';
#         GRANT ALL PRIVILEGES ON DATABASE gstudio_psql TO glab;
#         " | sudo su - postgres ;   

# sleep 60;

# echo "[run] syncdb" ;
# python manage.py syncdb --noinput ;

# echo "[run] create superuser" ;
# echo "from django.contrib.auth.models import User
# if not User.objects.filter(username='administrator').count():
#     User.objects.create_superuser('administrator', 'admin@example.com', 'changeit')
# " | python manage.py shell ;

# # the above script is suggested by
# # https://github.com/novapost/docker-django-demo

# echo "[run] get updated additional schema STs, ATs and RTs" ;
# cp -v /home/docker/code/gstudio/doc/schema_directory/* /home/docker/code/gstudio/gnowsys-ndf/gnowsys_ndf/ndf/management/commands/schema_files/ ;

# echo "[run] create or update gstudio schema in mongodb" ;
# python manage.py filldb ;
# python manage.py create_schema STs_run1.csv ; 
# python manage.py create_schema ATs.csv ;
# python manage.py create_schema RTs.csv ; 
# python manage.py create_schema STs_run2.csv ;

# echo "[run] property_order_reset" ;							   # Mrunal M. Nachankar : Mon, 07-09-2015 12:15:AM 
# echo "execfile('property_order_reset.py')" | python manage.py shell ;	   # Mrunal M. Nachankar : Mon, 07-09-2015 12:15:AM 

# echo "[run] create_auth_objs.py" ;							   # Mrunal M. Nachankar : Mon, 07-09-2015 12:15:AM 
# echo "execfile('../doc/deployer/create_auth_objs.py')" | python manage.py shell ;	   # Mrunal M. Nachankar : Mon, 07-09-2015 12:15:AM 

# echo "[run] Sync_existing" ;						   # Mrunal M. Nachankar : Mon, 07-09-2015 12:15:AM 
# python manage.py sync_existing_documents ;				   # Mrunal M. Nachankar : Mon, 07-09-2015 12:15:AM 


echo "[run] logout_all_users" ;							   # Mrunal M. Nachankar : Mon Apr  9 16:32:09 IST 2018 
echo "execfile('../doc/deployer/logout_all_users.py')" | python manage.py shell ;	   # Mrunal M. Nachankar : Mon Apr  9 16:32:09 IST 2018 

echo "[run] smtpd.sh" ;							   # Mrunal M. Nachankar : Mon, 07-09-2015 12:15:AM 
bash /home/docker/code/scripts/smtpd.sh ; 						   # Mrunal M. Nachankar : Mon, 07-09-2015 12:15:AM 

echo "[run] generate-self-certified-certificate-ssl..sh" ;				   # Mrunal M. Nachankar : Mon, 07-09-2015 12:15:AM 
bash /home/docker/code/scripts/generate-self-certified-certificate-ssl.sh ; 		   # Mrunal M. Nachankar : Mon, 07-09-2015 12:15:AM 

echo "[run] school server gpg setup" ;
bash /home/docker/code/scripts/ss-gpg-setup.sh

echo "[run] start qbank-lite" ;							   # Mrunal M. Nachankar : Mon, 07-09-2015 12:15:AM 
bash /home/docker/code/scripts/start-qbank.sh ; 						   # Mrunal M. Nachankar : Mon, 07-09-2015 12:15:AM 

# applying host entry (clixserver)
/usr/bin/rsync -avzPh /etc/hosts /tmp/
/bin/sed -i ' 1 s/.*/& clixserver/' /tmp/hosts
#/usr/bin/rsync -avzPh /tmp/hosts /etc/
/bin/cp /tmp/hosts /etc/

# nginx-app logs
if [[ -f /var/log/nginx/school.server.org.error.log ]] && [[ -f /var/log/nginx/school.server.org.access.log ]] ; then
    # files present in new location (/data/nginx-logs/) copy files appending ".old" to the filenames 
    if [[ -f /data/nginx-logs/school.server.org.error.log ]] && [[ -f /data/nginx-logs/school.server.org.access.log ]] ; then
        echo -e "\nWarning: (nginx-app logs) - Files found on both the locations. Please check nginx-app.conf for the logs paths." ;
        mv -v /var/log/nginx/school.server.org.error.log* /data/nginx-logs/school.server.org.error.log.old
        mv -v /var/log/nginx/school.server.org.access.log* /data/nginx-logs/school.server.org.access.log.old
    # files absent in new location (/data/nginx-logs/) copy files with the exact filenames
    elif [[ ! -f /data/nginx-logs/school.server.org.error.log ]] && [[ ! -f /data/nginx-logs/school.server.org.access.log ]] ; then
        echo -e "\nInfo: (nginx-app logs) - File found in old location and hence moving it to new location." ;
        if [[ -d /data/nginx-logs ]]; then
            echo -e "\nInfo: (nginx-app logs) - Directory already exists" ;    
        elif [[ ! -d /data/nginx-logs ]]; then
            echo -e "\nInfo: (nginx-app logs) - Directory doesn't exists. Hence creating it." ;
            mkdir -p /data/nginx-logs ;
        fi
        mv -v /var/log/nginx/school.server.org.error.log* /data/nginx-logs/
        mv -v /var/log/nginx/school.server.org.access.log* /data/nginx-logs/
    else
        echo -e "\nError: (nginx-app logs) - Oops something went wrong (/data/nginx-logs/*.logs). Contact system administator or CLIx technical team - Mumbai." ;
    fi
elif [[ ! -f /var/log/nginx/school.server.org.error.log ]] && [[ ! -f /var/log/nginx/school.server.org.access.log ]] ; then
    echo -e "\nInfo: (nginx-app logs) - Files doesn't exists. No action taken." ;
else
    echo -e "\nError: (nginx-app logs) - Oops something went wrong (/var/log/nginx/*.logs). Contact system administator or CLIx technical team - Mumbai." ;
fi

# nginx logs
if [[ -f /var/log/nginx/error.log ]] && [[ -f /var/log/nginx/access.log ]] ; then
    # files present in new location (/data/nginx-logs/) copy files appending ".old" to the filenames 
    if [[ -f /data/nginx-logs/error.log ]] && [[ -f /data/nginx-logs/access.log ]] ; then
        echo -e "\nWarning: (nginx logs) - Files found on both the locations(error.log and access.log). Please check nginx-app.conf for the logs paths." ;
        mv -v /var/log/nginx/error.log* /data/nginx-logs/error.log.old
        mv -v /var/log/nginx/access.log* /data/nginx-logs/access.log.old
    # files absent in new location (/data/nginx-logs/) copy files with the exact filenames
    elif [[ ! -f /data/nginx-logs/error.log ]] && [[ ! -f /data/nginx-logs/access.log ]] ; then
        echo -e "\nInfo: (nginx logs) - File found in old location and hence moving it to new location." ;
        if [[ -d /data/nginx-logs ]]; then
            echo -e "\nInfo: (nginx logs) - Directory already exists" ;    
        elif [[ ! -d /data/nginx-logs ]]; then
            echo -e "\nInfo: (nginx logs) - Directory doesn't exists. Hence creating it." ;
            mkdir -p /data/nginx-logs ;
        fi
        mv -v /var/log/nginx/error.log* /data/nginx-logs/
        mv -v /var/log/nginx/access.log* /data/nginx-logs/
    else
        echo -e "\nError: (nginx logs) - Oops something went wrong (/data/nginx-logs/*.logs). Contact system administator or CLIx technical team - Mumbai." ;
    fi
elif [[ ! -f /var/log/nginx/error.log ]] && [[ ! -f /var/log/nginx/access.log ]] ; then
    echo -e "\nInfo: (nginx logs) - Files doesn't exists. No action taken." ;
else
    echo -e "\nError: (nginx logs) - Oops something went wrong (/var/log/nginx/*.logs). Contact system administator or CLIx technical team - Mumbai." ;
fi

echo "[run] supervisord" ;
supervisord -n ;