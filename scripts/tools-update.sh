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


filename=$(basename $(ls -r /mnt/update_*.tar.gz |  head -n 1));
update_patch="${filename%.*.*}";

echo -e "\n${cyan}copy updated patch from /mnt/${update_patch}/tools-update/setup-software/Tools to /home/core/setup-software/  ${reset}";
sudo rsync -avzPh /mnt/${update_patch}/tools-update/setup-software/Tools  /home/core/setup-software/;

echo -e "\n${cyan}remove /home/core/setup-software/Tools/biomechanic ${reset}";
sudo rm -rf /home/core/setup-software/Tools/biomechanic;


