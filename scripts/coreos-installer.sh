#!/bin/bash


# Following variables are used to store the color codes for displaying the content on terminal
red="\033[0;91m" ;
green="\033[0;32m" ;
brown="\033[0;33m" ;
blue="\033[0;34m" ;
cyan="\033[0;36m" ;
reset="\033[0m" ;

black="\033[0;30m" ;
red="\033[0;31m" ;
green="\033[0;32m" ;
brown="\033[0;33m" ;
blue="\033[0;34m" ;
purple="\033[0;35m" ;
cyan="\033[0;36m" ;
#="\033[0;37m" ;
#="\033[0;38m" ;
#="\033[0;39m" ;
#="\033[0;40m" ;


echo -e "${cyan}Where do you want to install coreos ${reset}" ;
echo -e "${cyan}(For example 'sda1' or 'sda8' or 'sdb2' must be entered and hit Enter key of Keyboard) ${reset}"
echo -e "${cyan}{if you are not sure please do not proceed. Without input hit enter } ${reset}" ;
read part_i ;
echo -e "\n${green}Partion entered is $part_i ${reset}" ;
if [[ "$part_i" == "" ]]; then
    echo -e "\nNo input. Hence exiting. Thank you. Please try again later." ;
    exit
else 
    check_part=`lsblk | grep $part_i | wc -l`
    if [[ "$check_part" != "1" ]]; then
	echo -e "\nInvalid input. Hence exiting. Thank you. Please try again later." ;
	exit
    fi
    echo -e "\n${red}Caution: It will format $part_i partion ${reset}";
    echo -e "${red}Are you sure you want to proceed? ${reset}" ;
    echo -e -n "${cyan}yes/no : ${reset}"
    read part_format_i
    if [[ "$part_format_i" == "" ]]; then
	echo -e "\nNo input. Hence exiting. Thank you. Please try again later." ;
	exit
    elif  [[ "$part_format_i" == "n" ]] || [[ "$part_format_i" == "N" ]] || [[ "$part_format_i" == "no" ]] || [[ "$part_format_i" == "No" ]] || [[ "$part_format_i" == "NO" ]]; then
	echo -e "\nInput is '$part_format_i'. Hence exiting. Thank you." ;
	exit
    elif  [[ "$part_format_i" == "y" ]] || [[ "$part_format_i" == "Y" ]] || [[ "$part_format_i" == "yes" ]] || [[ "$part_format_i" == "Yes" ]] || [[ "$part_format_i" == "YES" ]]; then
	echo -e "\nInput is '$part_format_i'. Continuing the process." ;
    else
	echo -e "\nInput is '$part_format_i'. Oops!!! Something went wrong."
    fi
    
fi
exit
