#!/bin/bash

# Following variables are used to store the color codes for displaying the content on terminal
black="\033[0;90m" ;
red="\033[0;91m" ;
green="\033[0;92m" ;
brown="\033[0;93m" ;
blue="\033[0;94m" ;
purple="\033[0;95m" ;
cyan="\033[0;96m" ;
grey="\033[0;97m" ;
white="\033[0;98m" ;
reset="\033[0m" ;

# for filename 

#filename=$(basename $(ls -dr /home/docker/code/patch-*/ |  head -n 1));
#patch="${filename%.*.*}"; 
#patch="patch-7a6c2ac-r5-20190221";    #earlier patch
#patch="patch-26eaf18-r5-20190320";    #latest patch
patch="update-patch-c0463c5-r6-20190718";

# Code to fix the image link started
echo -e "\n${cyan}change the directory to /data/ ${reset}";
cd /data/;

#code to copy the images inside media started

echo -e "\n${cyan}Copying the images ${reset}";
sudo rsync -avPhz data-updates/05dcae904d485b9750d7fde5f4c05579259ed39e7195525913372f05270ef.png media/6/6/1;
sudo rsync -avPhz data-updates/7162a4d5f721315b4ca4d9b304ccbacf9c5ac6584d9c5ce80d273cc0d03c4.png media/c/2/8;
sudo rsync -avPhz data-updates/aa678b02f2c3a95bd6e44be64c6f27bb395e0a9c5960b83fa6670dad29d37.jpg media/c/2/9;

#code to copy the images inside media ended

#changing the directory

echo -e "\n${cyan}change the directory to /home/docker/code/gstudio/gnowsys-ndf/ ${reset}";
cd /home/docker/code/gstudio/gnowsys-ndf;

# running the python file inside the python shell 

echo -e "\n${cyan}running 'fix_absolute_imagelinks.py' file in the python shell";
echo "execfile('/home/docker/code/gstudio/doc/release-scripts/fix_absolute_imagelinks.py')" | python manage.py shell;

#Code to fix the image link ended

