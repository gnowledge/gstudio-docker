#!/bin/bash


#--------------------------------------------------------------------#
# Backup of gstudio 
# File name    : git-log-details.sh
# File version : 1.0
# Created by   : Mr. Mrunal M. Nachankar
# Created on   : 26-06-2014 12:04:AM
# Modified by  : None
# Modified on  : Not yet
# Description  : This file is used for taking backup of gstudio
#                1. Capture git log details
#				 2. Take backup of rcs via cp (copy -rv) command
#				 3. Take backup of mongodb via mongodbdump command
#				 4. Create a compressed file (TAR File - tar.bz2)
#				 5. Optional - Move the backup directory to /tmp/ after successful creation of tar.bz2 file
#--------------------------------------------------------------------#


# log commit details  - started
echo -e "\nDate : $(date) \n" 

echo -e "\n\nDetails of gstudio-docker \n" 
cd /home/docker/code/

echo -e "\ngstudio-docker : $(pwd) \n" 
echo -e $(pwd)

echo -e "\ngstudio-docker : git branch \n" 
git branch 

echo -e "\ngstudio-docker : git log - latest 10 commits \n" 
git log -n 10 

echo -e "\ngstudio-docker : git status \n" 
git status 

echo -e "\ngstudio-docker : git diff \n" 
git diff 


echo -e "\n\nDetails of gstudio \n" 
cd /home/docker/code/gstudio/

echo -e "\ngstudio : $(pwd) \n" 
echo -e $(pwd)

echo -e "\ngstudio : git branch \n" 
git branch 

echo -e "\ngstudio : git log - latest 10 commits \n" 
git log -n 10 

echo -e "\ngstudio : git status \n" 
git status 

echo -e "\ngstudio : git diff \n" 
git diff 


echo -e "\n\nDetails of OpenAssessmentsClient \n" 
cd /home/docker/code/OpenAssessmentsClient/

echo -e "\n'OpenAssessmentsClient' - strategy adopted for updating oac and oat is as follows: \n
- Building 'oac' and 'oat' locally from 'gnowledge/OpenAssessmentsClient' with 'clixserver' branch. \n
- Testing it locally and packaging oac, oat as a replacement. \n
- This decision is taken because building oac and oat is network dependent operation and sometimes build doesn't happen smoothly. \n\n" 

# echo -e "\nOpenAssessmentsClient : $(pwd) \n" 
# echo -e $(pwd)

# echo -e "\nOpenAssessmentsClient : git branch \n" 
# git branch 

# echo -e "\nOpenAssessmentsClient : git log - latest 10 commits \n" 
# git log -n 10 

# echo -e "\nOpenAssessmentsClient : git status \n" 
# git status 

# echo -e "\nOpenAssessmentsClient : git diff \n" 
# git diff 


echo -e "\n\nDetails of qbank-lite \n" 
cd /home/docker/code/gstudio/gnowsys-ndf/qbank-lite/

echo -e "\nqbank-lite : $(pwd) \n" 
echo -e $(pwd)

echo -e "\nqbank-lite : git branch \n" 
git branch 

echo -e "\nqbank-lite : git log - latest 10 commits \n" 
git log -n 10 

echo -e "\nqbank-lite : git status \n" 
git status 

echo -e "\nqbank-lite : git diff \n" 
git diff 



echo -e "\npip freeze \n" 
pip freeze

echo -e "\nps aux\n"
ps aux

echo -e "\nFiles inside /data/updates_archives \n" 
ls -ltrh /data/updates_archives


echo -e "\nDate : $(date) \n" 
# log commit details - ended




echo -e "\nBackup server_settings.py(/home/docker/code/gstudio/gnowsys-ndf/gnowsys_ndf/server_settings.py) in /data/ \n" 
rsync -avzPh /home/docker/code/gstudio/gnowsys-ndf/gnowsys_ndf/server_settings.py /data/
