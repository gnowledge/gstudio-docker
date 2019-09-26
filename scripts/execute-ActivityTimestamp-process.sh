#!/bin/bash

# Runs the activity time stamp process,
# the same process runs on 2nd and 4th Friday of the every month, automatically, once the machine starts.
# This activity takes longer time to complete, 
# so one who starts the execution should wait till the process gets completed. 

docker exec gstudio /bin/sh -c "echo \"execfile('/home/docker/code/gstudio/doc/deployer/get_all_users_activity_timestamp_csvs.py')\" |/usr/bin/python /home/docker/code/gstudio/gnowsys-ndf/manage.py shell";
