#!/bin/bash

# Following variables are used to store the color codes for displaying the content on terminal
# red="\033[0;31m" ;
# green="\033[0;32m" ;
# brown="\033[0;33m" ;
# blue="\033[0;34m" ;
# cyan="\033[0;36m" ;
# reset="\033[0m" ;

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

echo -e "\n${cyan}Please be ready with the following details: ${reset}" ;
echo -e "\n${cyan}\t School server id ${reset}" ;

echo -e "\n${cyan}Please (re)insert the (Learning Studio - DOER edition) pen drive.${reset}"

sleep 5

for (( i=1; i<5; i++ )); 
do

      check_disk=`lsblk | grep sdb9 | wc -l`

      if [[ "$check_disk" != "1" ]]; then
            sleep 5;
            echo -e "\nWaiting for the pen drive.";
      elif [[ "$check_disk" == "1" ]]; then
            break
      fi

      if [[ $i == 4 ]]; then
            echo -e "\nPen drive not found. Retry installation.";
            exit;
      fi

done




echo -e "\n${cyan}Please provide the School server id? (Example Mizoram school 23 will have mz23 and Telangana 24 school - te824) ${reset}" ;
echo -e -n "School server id: "
read ss_id


echo -e "\n${cyan}Name the disk for source of installation media? ${reset}" ;
echo -e "${brown}(For example 'sda' or 'sdb' or 'sdc') ${reset}" ;
echo -e "${brown}{if you are not sure and want to exit simply type enter} ${reset}" ;
check_disk_h=`lsblk | grep SIZE`
check_disk_d=`lsblk | grep disk`
echo -e "\n${purple}$check_disk_h ${reset}" ;
echo -e "${blue}$check_disk_d ${reset}\n" ;
echo -e -n "${cyan}disk name : ${reset}" ;

read disk_t ;
disk_t_ck=`lsblk | grep $disk_t`

if [[ "$disk_t" == "" ]]; then

  echo -e "\n${brown}No input. Hence exiting. Please try again later. ${reset}" ;
  exit

elif [[ "$disk_t_ck" == "" ]]; then

  echo -e "\n${brown}Invalid input. Hence exiting. Please try again later. ${reset}" ;
  exit

elif [[ "$disk_t_ck" != "" ]]; then


  echo -e "${cyan}mounting /dev/${disk_t} in /mnt ${reset}"
  sudo mount /dev/${disk_t}9 /mnt

  echo -e "\n${cyan}copy softwares from /mnt/home/core/setup-software /mnt/home/core/install-to-disk.sh /mnt/home/core/user-csvs /mnt/home/core/display-pics /mnt/home/core/data to /home/core/ ${reset}"
  sudo cp -av /mnt/home/core/setup-software /mnt/home/core/install-to-disk.sh /mnt/home/core/user-csvs /mnt/home/core/display-pics /mnt/home/core/data /home/core/

  echo -e "\n${cyan}umount /mnt${reset}"
  sudo umount /mnt
  
  echo -e "\n${cyan}loading /home/core/setup-software/gstudio/school-server-master-v1-20160626-080144.tar docker image ${reset}"
  echo -e "${brown}caution : it may take long time ${reset}"
  docker load < /home/core/setup-software/gstudio/school-server-master-v1-20160626-080144.tar

  echo -e "\n${cyan}creating school server instance (docker container) ${reset}"
  #docker run -itd -h gstudio.net --restart=always -v /home/core/data:/data -v /home/core/backups:/backups -v /home/core/schema-dump:/home/docker/code/schema-dump -v /home/core/setup-software:/softwares -p 8025:25 -p 8022:22 -p 80:80 -p 443:443  -p 8000:8000-p 8017:27017 -p 8143:143 -p 8587:587 --name=gstudio  school-server-master:v1-20160626-080144
  docker run -itd -h $ss_id --restart=always -v /home/core/data:/data -v /home/core/backups:/backups -v /home/core/setup-software:/softwares -p 8022:22 -p 8025:25 -p 80:80 -p 443:443 -p 8000:8000 -p 8017:27017 -p 8143:143 -p 8587:587 --name=gstudio  school-server-master:v1-20160626-080144


  echo -e "\n${cyan}loading /home/core/setup-software/ka-lite/kal3.tar docker image ${reset}"
  echo -e "${brown}caution : it may take long time ${reset}"
  docker load < /home/core/setup-software/ka-lite/kal3.tar

  echo -e "\n${cyan}creating school server instance (docker container) ${reset}"
  echo -e "docker run -itd -h -v /home/core/ka-lite:/var/ka-lite/.kalite/content -p 8008:8008  --name=ka-lite  gnowgi:kal3"
  docker run -itd  -h ka-lite -v /home/core/ka-lite:/var/ka-lite/.kalite/content -p 8008:8008  --name=ka-lite  gnowgi:kal3


  echo -e "\n${cyan}loading /home/core/setup-software/syncthing/syncthing.tar docker image ${reset}"
  echo -e "${brown}caution : it may take long time ${reset}"
  docker load < /home/core/setup-software/syncthing/syncthing.tar

  echo -e "\n${cyan}creating school server instance (docker container) ${reset}"
  echo -e "docker run -d --restart=always  -v /home/core/backups:/srv/backups  -v /srv/syncthing:/srv/config  -p 22000:22000  -p 21025:21025/udp  -p 8080:8080  --name=syncthing  joeybaker/syncthing"
  docker run -d --restart=always  -v /home/core/backups:/srv/backups  -v /srv/syncthing:/srv/config  -p 22000:22000  -p 21025:21025/udp  -p 8080:8080  --name=syncthing  joeybaker/syncthing

  docker exec -it gstudio /bin/sh -c "/bin/echo GSTUDIO_INSTITUTE_ID = ${ss_id} > /home/docker/code/gstudio/gnowsys-ndf/gnowsys_ndf/server_settings.py"

  docker restart gstudio

  sleep 60

  docker cp display-pics gstudio:/home/docker/code/
  docker cp user-csvs/${ss_id}_users.csv gstudio:/home/docker/code/user-csvs/

  docker exec -it gstudio /bin/sh -c "/usr/bin/python /home/docker/code/gstudio/gnowsys-ndf/manage.py sync_users /home/docker/code/user-csvs/${ss_id}_users.csv"

  echo -e "\n${cyan}start docker at startup ${reset}"
  sudo systemctl enable docker

  sudo chmod -R 755 /home/core/data/media/*

fi

exit
