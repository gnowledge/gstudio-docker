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


# Mrunal : below part is added by Mrunal as suggested by Nagarjuna
echo -e "\n${cyan}***   Learning Studio - DOER Edition (April 2016)   ***${reset}\n" ;
echo -e "${cyan}      school server installation      ${reset}\n" ;
echo -e "\n${brown}Note : \nThis installation is a one-time or infrequently used process.${reset}" ;
echo -e "${brown}It uses a terminal-console which may show many details during installations.${reset}" ;
echo -e "${brown}This is normal. Please let the installation proceed.${reset}\n" ;
sleep 5
docker start webserver
echo -e "\n"
echo -e "\n"

sleep 5

echo -e "\n${cyan}Name the disk where do you want to install the server? ${reset}" ;
echo -e "${brown}(For example 'sda' or 'sdb' or 'sdc') ${reset}"
echo -e "${brown}{if you are not sure and want to exit simply type enter} ${reset}" ;
check_disk_h=`lsblk | grep SIZE`
check_disk_d=`lsblk | grep disk`
echo -e "\n${purple}$check_disk_h ${reset}"
echo -e "${blue}$check_disk_d ${reset}\n"
echo -e -n "${cyan}disk name : ${reset}"

read disk_i ;

if [[ "$disk_i" == "" ]]; then

    echo -e "\n${brown}No input. Hence exiting. Please try again later. ${reset}" ;
    exit

else 

    echo -e "\n${green}Disk entered is $disk_i ${reset}" ;
    check_disk=`lsblk | grep $disk_i | grep disk | wc -l`
    if [[ "$check_disk" != "1" ]]; then
	echo -e "\n${red}Invalid input. Hence exiting. Please try again later. ${reset}" ;
	exit
    fi

    echo -e "\n${red}Caution: \nIt will format $disk_i disk ${reset}";
    echo -e "${red}Are you sure you want to proceed? ${reset}" ;
    echo -e -n "${cyan}Y/N : ${reset}"

    read part_format_i
    if [[ "$part_format_i" == "" ]]; then

	echo -e "\n${brown}No input. Hence exiting. Please try again later. ${reset}" ;
	exit

    elif  [[ "$part_format_i" == "n" ]] || [[ "$part_format_i" == "N" ]] || [[ "$part_format_i" == "no" ]] || [[ "$part_format_i" == "No" ]] || [[ "$part_format_i" == "NO" ]]; then

	echo -e "\n${red}Invalid input is '$part_format_i'. Hence exiting. Thank you. ${reset}" ;
	exit

    elif  [[ "$part_format_i" == "y" ]] || [[ "$part_format_i" == "Y" ]] || [[ "$part_format_i" == "yes" ]] || [[ "$part_format_i" == "Yes" ]] || [[ "$part_format_i" == "YES" ]]; then

	echo -e "\n${green}Input is '$part_format_i'. Continuing the process. ${reset}" ;

    else

	echo -e "\n${red}Input is '$part_format_i'. Oops!!! Something went wrong. ${reset}"

    fi
    
fi

echo -e "\n${cyan}Installing coreos, the host operating system to /dev/$disk_i ${reset}"

sudo /home/core/setup-software/coreos/coreos-install.sh -d /dev/$disk_i -C stable -c /home/core/setup-software/coreos/cloud-config.yaml -b http://localhost/setup-software/coreos/mirror 

echo -e "\n${cyan}Successfully installed coreos, the host operating system to /dev/$disk_i ${reset}"

exit
