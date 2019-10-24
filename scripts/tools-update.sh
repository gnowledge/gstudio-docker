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


#filename=$(basename $(ls  /mnt/update_*.tar.gz |  head -n 1));
#update_patch="${filename%.*.*}";
#update_patch="update_patch-beb6af2-r2.1-20171229"
#patch=$(basename $(tar -tf /mnt/patch-*.tar.gz |  head -n 1));
patch="update-patch-c0463c5-r6-20190718";

#echo -e "\n${cyan}copy updated patch from /mnt/${update_patch}/tools-updates/setup-software/* to /home/core/setup-software/  ${reset}";
#sudo rsync -avzPh /mnt/${update_patch}/tools-updates/setup-software/*  /home/core/setup-software/;

#echo -e "\n${cyan}remove /home/core/setup-software/Tools/biomechanic ${reset}";
#sudo rm -rf /home/core/setup-software/Tools/biomechanic;

# code to execute script git-offline-tools-update.sh inside the container
echo -e "\n${cyan}Update various tools offline ${reset}";
docker exec -it gstudio /bin/sh -c "/bin/bash /home/docker/code/${patch}/tools-updates/git-offline-tools-update.sh";


#copying the chrome version 69 and firefox version 65.0.1 for windows and ubuntu
echo -e "\n${cyan}Copying the chromev69 folder from patch folder to setup-software ${reset}";
sudo rsync -avPhz /mnt/update-patch-r6/${patch}/tools-updates/chrome_v69 /home/core/setup-software/i2c-softwares/Browsers/ ;

echo -e "\n${cyan}Copying the firefox_v65.0.1 folder from patch folder to setup-software ${reset}";
sudo rsync -avPhz /mnt/update-patch-r6/${patch}/tools-updates/firefox_v65.0.1 /home/core/setup-software/i2c-softwares/Browsers/ ;

#copying the libre office version 6.1.5.2 for ubuntu
echo -e "\n${cyan}Copying the LibreOffice_6.1.5.2_Linux_x86-64_deb folder from patch folder to setup-software ${reset}";
sudo rsync -avPhz /mnt/update-patch-r6/${patch}/tools-updates/LibreOffice_6.1.5.2_Linux_x86-64_deb /home/core/setup-software/i2c-softwares/LibreOffice/ ;

#copying the scratch version 1.4.0.6 for ubuntu
echo -e "\n${cyan}Copying the scratch_1.4.0.6_dfsg1-5_all.deb package from patch folder to setup-software ${reset}";
sudo rsync -avPhz /mnt/update-patch-r6/${patch}/tools-updates/scratch_1.4.0.6_dfsg1-5_all.deb /home/core/setup-software/i2c-softwares/Scratch/ ;

#installing google chrome version 69 
echo -e "\n${cyan}Installing Google Chrome Version 69 ${reset}";
sudo dpkg -i /home/core/setup-software/i2c-softwares/Browsers/chrome_v69/google-chrome-stable_v69_amd64.deb;


