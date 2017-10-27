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
	#filename=$(basename $(ls  /mnt/update_*.tar.gz |  head -n 1));
	#update_patch="${filename%.*.*}";
	update_patch="update_patch-1597e41-r2-20170929"

	echo -e "\n${cyan}patch directory name : ${update_patch} and this update shell file name is $(readlink -f $0) ${reset}"

	echo -e "\n${cyan}change directory /mnt/pd ${reset}"
	cd /mnt/pd

	echo -e "\n${cyan}copy from /mnt/pd/patch-r2* /mnt/pd/update_patch-1597e41-r2-20170929.tar.gz* /mnt/pd/update_patch-06a676e-r2.1-20171013.tar.gz /mnt/pd/README-update.md to /mnt/ ${reset}"
	rsync -avzPh /mnt/pd/patch-r2* /mnt/pd/update_patch-1597e41-r2-20170929.tar.gz* /mnt/pd/update_patch-06a676e-r2.1-20171013.tar.gz /mnt/pd/README-update.md /mnt/

	echo -e "\n${cyan}change directory /mnt/ ${reset}"
	cd /mnt/

	echo -e "\n${cyan}Applying code updates - patch-r2 ${reset}"
	sudo bash patch-r2.sh

    echo -e "\n${cyan}Patch 2 update finished ${reset}"

	echo -e "\n${cyan}Applying code updates ${reset}"
	sudo bash ${update_patch}/code-updates/code-update.sh

	echo -e "\n${cyan}Applying code updates - patch-r2.1 ${reset}"
	sudo bash patch-r2.1.sh

	echo -e "\n${cyan}Patch 2.1 update finished ${reset}"

}   

apply_patch |   tee /mnt/patch-r2-tg-teachers.log;