#!/bin/bash

# Generating csv reports of gstudio groupwise user analystics

/usr/bin/python /home/docker/code/gstudio/gnowsys-ndf/manage.py export_users_analytics

#ln -s /data/gstudio-exported-users-analytics-csvs /softwares/gstudio-exported-users-analytics-csvs

