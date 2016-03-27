#!/bin/bash - 

# Turn echoing off
# stty -echo

# # Read the password from the user
# echo "Please enter a password: "
# read PASSWD

# # Turn echoing back on
# stty echo

# echo -e 'Or this way \n'
# read -sp 'Please enter a password: ' PASSWD 
# echo 

sh_c="sh -c"
#sh_c="sudo -E sh -c"

LOG_DIR="$(pwd)/Pre-install_Logs";
INSTALL_LOG="pre-install-$(date +%d-%b-%Y-%I-%M-%S-%p).log"; # Mrunal : Fri Aug 28 17:38:35 IST 2015 : used for redirecting Standard_output(Normal msg)
INSTALL_LOG_FILE="$LOG_DIR/$INSTALL_LOG"; # Mrunal : Fri Aug 28 17:38:35 IST 201
#$sh_c 'rm docker-inst.lock'    | sed -e "s/^/$(date +%Y%b%d-%I%M%S%p) $   /"  2>&1 | tee -a ${INSTALL_LOG_FILE}
if [[ ! -f docker-inst.lock ]]; then
    echo "1"  | sed -e "s/^/$(date +%Y%b%d-%I%M%S%p) $   /"  2>&1 | tee -a ${INSTALL_LOG_FILE}
    $sh_c 'touch docker-inst.lock'   | sed -e "s/^/$(date +%Y%b%d-%I%M%S%p) $   /"  2>&1 | tee -a ${INSTALL_LOG_FILE}
    echo $INSTALL_LOG > docker-inst.lock 
    $sh_c 'more docker-inst.lock'      | sed -e "s/^/$(date +%Y%b%d-%I%M%S%p) $   /"  2>&1 | tee -a ${INSTALL_LOG_FILE}
    echo "2"  | sed -e "s/^/$(date +%Y%b%d-%I%M%S%p) $   /"  2>&1 | tee -a ${INSTALL_LOG_FILE}
    more ${INSTALL_LOG_FILE}
    
    su -u glab -c ./test.sh
    # line="@reboot bash /var/MStore/Mrunal/Docker/mrufinal/git-docker-gitudio/gstudio-docker/scripts/test.sh"
    # (crontab -u glab -l; echo "$line" ) | crontab -u glab -
    # sudo reboot
elif [[ -f docker-inst.lock ]]; then
    # line="@reboot bash /var/MStore/Mrunal/Docker/mrufinal/git-docker-gitudio/gstudio-docker/scripts/test.sh"
    # (crontab -u glab -l; grep -v /var/MStore/Mrunal/Docker/mrufinal/git-docker-gitudio/gstudio-docker/scripts/test.sh ) | crontab -u glab -

    $sh_c 'echo $INSTALL_LOG'      | sed -e "s/^/$(date +%Y%b%d-%I%M%S%p) $   /"  2>&1 | tee -a ${INSTALL_LOG_FILE}
    $sh_c 'INSTALL_LOG=`more docker-inst.lock`'     | sed -e "s/^/$(date +%Y%b%d-%I%M%S%p) $   /"  2>&1 | tee -a ${INSTALL_LOG_FILE}
    $sh_c 'echo $INSTALL_LOG'      | sed -e "s/^/$(date +%Y%b%d-%I%M%S%p) $   /"  2>&1 | tee -a ${INSTALL_LOG_FILE}
    $sh_c 'rm docker-inst.lock'  
    echo "4"   | sed -e "s/^/$(date +%Y%b%d-%I%M%S%p) $   /"  2>&1 | tee -a ${INSTALL_LOG_FILE}
fi
