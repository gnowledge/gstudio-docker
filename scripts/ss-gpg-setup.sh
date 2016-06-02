#!/bin/bash

# # Following variables are used to store the color codes for displaying the content on terminal
# red="\033[0;91m" ;
# green="\033[0;32m" ;
# brown="\033[0;33m" ;
# blue="\033[0;34m" ;
# cyan="\033[0;36m" ;
# reset="\033[0m" ;
# echo='echo -e' ;



# $echo "\n${blue}Enter your Full name. (Example: Mrunal Nachankar) ${reset}" ;
# read install_user_fullname

# $echo "\n${blue}Enter your State name. (Example: Maharashtra) ${reset}" ;
# read install_state_name

# $echo "\n${blue}Enter your School name. (Example: Kendriya Vidyalaya Karanja) ${reset}" ;
# read install_school_name

# $echo "\n${blue}Enter your School id. (Example: 001, 002 or 0025)${reset}" ;
# read install_school_id

# # Assembling full school id
# install_state_name_init=${install_state_name,,} # ${a,,} - lowercase and ${a^^} - uppercase 
# install_state_name_init=${install_state_name_init:0:3}
# $echo "${install_state_name_init}"
# install_full_school_id=${install_state_name_init}${install_school_id}
# $echo "${install_full_school_id}"

# $echo "\n${blue}Enter your Full School id. (Example: m001, m002 or m0025)${reset}" ;
# read install_full_school_id

# $echo "\n${blue}Enter your email id. (Example: m001-ss@gnowledge.org) ${reset}" ;
# read install_email_id

# $echo "\n${blue} $install_user_fullname : $install_state_name : $install_school_name : $install_school_id : $install_email_id ${reset}" ;



# exit

# # Mrunal : 20160131-2130 : Take user input as School id (small letter of initials of state and school no in 3 digit)
# echo "Please provide the id of School" ;
# echo "(For example Rajasthan state and school 001 'r001' must be entered and hit Enter key of Keyboard)" ;
# read sch_id ;
# echo "School id entered is $sch_id" ;

# # Mrunal : 20160131-2130 : 
# if [[ "${sch_id}" =~ [a-z]{1}[0-9]{3} ]]; then
#     echo "School id doesn't match the criteria. Hence exiting please restart / re-run the script again." ;
#     exit ;
# else
#     echo "School id matches the criteria. Continuing the process." ;
# fi
