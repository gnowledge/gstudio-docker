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
echo -e "\n${cyan}\t School server name ${reset}" ;
echo -e "\n${cyan}\t School U-DISE name ${reset}" ;
echo -e "\n${cyan}\t FSP name ${reset}" ;
echo -e "\n${cyan}\t Name of the person installing and configuring the server ${reset}" ;

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


echo -e "\n${cyan}Please provide the State name? ${reset}" ;

echo -e "\n${cyan}\t 1. Chhattisgarh$ {reset}" ;
echo -e "\n${cyan}\t 2. Mizoram ${reset}" ;
echo -e "\n${cyan}\t 3. Rajasthan ${reset}" ;
echo -e "\n${cyan}\t 4. telangana ${reset}" ;
echo -e "\n${cyan}\t 5. Special interest ( for GNs , testing and clixs team use) ${reset}" ;

echo -e "\n${cyan}Example: If your state name is Mizoram please type '1' and press enter ${reset}" ;
echo -e -n "State name: "
read state-name
if [[ "${state-name}" =~ ^[[0-5]{1}$ ]]; then
    echo "State id matches the criteria. Continuing the process." ;
else
    echo "State id doesn't match the criteria. Hence exiting please restart / re-run the script again." ;
    exit;
fi


echo -e "\n${cyan}Please provide the School server id? ${reset}" ;
echo -e -n "School server id: "
read ss-id


echo -e "\n${cyan}Please provide the School server name? ${reset}" ;
echo -e -n "School server name: "
read ss-name


echo -e "\n${cyan}Please provide the School U-DISE id? ${reset}" ;
echo -e -n "School U-DISE id: "
read udise-id


echo -e "\n${cyan}Please provide the FSP name? ${reset}" ;
echo -e -n "FSP name: "
read fsp-name

echo -e "\n${cyan}Please provide the Name of the person installing and configuring the server? ${reset}" ;
echo -e -n "Name of the person installing and configuring the server: "
read installers-name

if [[ "$disk_t" == "" ]]; then

    echo -e "\n${brown}No input. Hence exiting. Please try again later. ${reset}" ;
    exit

elif [[ "$disk_t" == "1" ]]; then


echo -e "${cyan}mounting /dev/sdb9 in /mnt ${reset}"
sudo mount /dev/sdb9 /mnt

echo -e "\n${cyan}copy softwares from /mnt/home/core/setup-software to /home/core/ ${reset}"
sudo cp -av /mnt/home/core/setup-software /home/core/

echo -e "\n${cyan}umount /mnt${reset}"
sudo umount /mnt

echo -e "\n${cyan}loading /home/core/setup-software/gstudio/school-server.tar docker image ${reset}"
echo -e "${brown}caution : it may take long time ${reset}"
docker load < /home/core/setup-software/gstudio/ssmaster.tar

echo -e "\n${cyan}creating school server instance (docker container) ${reset}"
docker run -itd -h gstudio.net --restart=always -v /home/core/data:/data -v /home/core/backups:/backups -v /home/core/schema-dump:/home/docker/code/schema-dump -v /home/core/setup-software:/softwares -p 8025:25 -p 8022:22 -p 80:80 -p 443:443  -p 8000:8000-p 8017:27017 -p 8143:143 -p 8587:587 --name=gstudio  school-server-master:v2-20160606

echo -e "\n${cyan}loading /home/core/setup-software/syncthing/syncthing.tar docker image ${reset}"
echo -e "${brown}caution : it may take long time ${reset}"
docker load < /home/core/setup-software/syncthing/syncthing.tar

echo -e "\n${cyan}creating school server instance (docker container) ${reset}"
echo -e "docker run -d --restart=always  -v /home/core/data/backup:/srv/data  -v /srv/syncthing:/srv/config  -p 22000:22000  -p 21025:21025/udp  -p 8080:8080  --name syncthing  joeybaker/syncthing"
docker run -d --restart=always  -v /home/core/backups:/srv/data  -v /srv/syncthing:/srv/config  -p 22000:22000  -p 21025:21025/udp  -p 8080:8080  --name syncthing  joeybaker/syncthing

docker exec -it gstudio /bin/sh -c "/bin/echo GSTUDIO_INSTITUTE_ID = $ss-id > /home/docker/code/gstudio/gnowsys-ndf/gnowsys_ndf/server_settings.py"

echo -e "\n${cyan}start docker at startup ${reset}"
sudo systemctl enable docker

exit
