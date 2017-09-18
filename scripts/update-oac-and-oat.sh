#!/bin/bash


#--------------------------------------------------------------------#
# Update oac and oat for clix school server (gstudio) 
# File name    : update-oac-and-oat.sh
# File version : 1.0
# Created by   : Mr. Mrunal M. Nachankar
# Created on   : 24-05-2017 16:36:PM
# Modified by  : None
# Modified on  : Not yet
# Description  : This file is used for taking backup of gstudio
#                1. Update oac and oat for clix school server. This file will update the oac and oat directory with the new updates.
#
#
# Reference	   : https://stackoverflow.com/questions/9980186/how-to-create-a-patch-for-a-whole-directory-to-update-it
# Information  : 
#
#
# I just had this same problem - lots of advice on how to half do it. Well, here is what I did to get both the patching and unpatching to work:
#
# To Create the Patch File:
#
#     Put copies of both directories in say /tmp, so we can create the patch file, or if brave, get them side by side - in one directory.
#
#     Run an appropriate diff on the two directories, old and new:
#
#     diff -ruN orig/ new/ > file.patch
#     		# -r == recursive, so do subdirectories
#     		# -u == unified style, if your system lacks it or if recipient
#     		#       may not have it, use "-c"
#     		# -N == treat absent files as empty
#
# If a person has the orig/ directory, they can recreate the new one by running patch.
#
# To Recreate the new folder from old folder and patch file:
#
#     Move the patch file to a directory where the orig/ folder exists
#
#     This folder will get clobbered, so keep a backup of it somewhere, or use a copy.
#
#     patch -s -p0 < file.patch
#     		# -s == silent except errors
#     		# -p0 == needed to find the proper folder
#
#     At this point, the orig/ folder contains the new/ content, but still has its old name, so:
#
#     mv orig/ new/    # if the folder names are different
#
#--------------------------------------------------------------------#

# Copy patch files in setup-softwares directory
#rsync -avzPh /mnt/oac.patch /mnt/oat.patch /home/core/setup-softwares/

# fetch latest patch date and time stamp
filename=$(basename $(ls  /mnt/update_*.tar.gz |  head -n 1));
update_patch="${filename%.*.*}";
update_patch="update_patch-d548468-r2-20170918"

# Apply patches - change the directory till the patch location and apply the patches
#docker exec -it gstudio /bin/sh -c "cp -rv /home/docker/code/${update_patch}/oac-and-oat-updates/oac.patch  /softwares/  &&  cd /softwares  &&  patch  -s -p0 <  oac.patch"
#docker exec -it gstudio /bin/sh -c "cp -rv /home/docker/code/${update_patch}/oac-and-oat-updates/oat.patch  /softwares/  &&  cd /softwares  &&  patch  -s -p0 <  oat.patch"

docker exec -it gstudio /bin/sh -c "rsync -avzPh /home/docker/code/${update_patch}/oac-and-oat-updates/oac /home/docker/code/${update_patch}/oac-and-oat-updates/oat  /softwares/"
docker exec -it gstudio /bin/sh -c "rsync -avzPh /home/docker/code/${update_patch}/oac-and-oat-updates/CLIx/datastore/AssetContent/* /home/docker/code/gstudio/gnowsys-ndf/qbank-lite/webapps/CLIx/datastore/repository/AssetContent/"
docker exec -it gstudio /bin/sh -c "cd /home/docker/code/${update_patch}/oac-and-oat-updates/CLIx/ && mongorestore --drop mongodump "


# Make directories to keep of patches
sudo mkdir -p /home/core/data/updates_archives/


# Copy patch files in old patches directory
sudo rsync -avzPh /mnt/${update_patch}.tar.gz /home/core/data/updates_archives/

# As the patches are applied we can remove it now (from host system)
#rm -rf /tmp/*
#sudo mv /mnt/${update_patch} /home/core/setup-software/oac.patch /home/core/setup-software/oat.patch /tmp/
#sudo rm -rf /tmp/${update_patch} /tmp/oa*.patch

# As the patches are applied we can remove it now (from docker container)
#rm -rf /tmp/*
docker exec -it gstudio /bin/sh -c "mv /home/docker/code/${update_patch} /tmp/  &&  rm -rf /tmp/${update_patch}"

exit