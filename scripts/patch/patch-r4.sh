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

function apply_patch() {

	# fetch the filename (patch name)
	filename=$(basename $(ls  /mnt/update_*.tar.gz |  head -n 1));
	update_patch="${filename%.*.*}";
	update_patch="update_patch-c173f95-r4-20171027"

	echo -e "\n${cyan}patch directory name : ${update_patch} and this update shell file name is $(readlink -f $0) ${reset}"

	echo -e "\n${cyan}change directory /mnt/pd ${reset}"
	cd /mnt/pd

	echo -e "\n${cyan}copy from /mnt/pd/${update_patch}.tar.gz to /mnt/ ${reset}"
	rsync -avzPh /mnt/pd/${update_patch}.tar.gz /mnt/

	echo -e "\n${cyan}change directory /mnt/ ${reset}"
	cd /mnt/

	echo -e "\n${cyan}Extract the tar.gz file (${update_patch}.tar.gz) ${reset}"
	sudo tar xvzf ${update_patch}.tar.gz

	echo -e "\n${cyan}Applying code updates ${reset}"
	sudo bash ${update_patch}/code-updates/code-update.sh

	echo -e "\n${cyan}Applying data updates ${reset}"
	sudo bash ${update_patch}/data-updates/data-update.sh

	echo -e "\n${cyan}Applying tools updates ${reset}"
	sudo bash ${update_patch}/tools-updates/tools-update.sh

	echo -e "\n${cyan}Applying oac and oat updates ${reset}"
	sudo bash ${update_patch}/oac-and-oat-updates/update-oac-and-oat.sh

	echo -e "\n${cyan}Patch 4 update finished. ${reset}"

	#echo -e "\n${cyan}School server will be restarting in 10sec ${reset}"
	#sleep 10
	#sudo reboot

}   

apply_patch |   tee /mnt/patch-r4.log;