#!/bin/bash
#--------------------------------------------------------------------#
# Copy extra software packages for CLIx student platform in coreos / ubuntu 
# File name    : copy-softwares.sh
# File version : 1.0
# Created by   : Mr. Mrunal M. Nachankar
# Created on   : Mon Apr 30 01:13:01 IST 2018
# Modified by  : None
# Modified on  : Not yet
# Description  : This file is used for copying the extra software packages for CLIx student paltform in coreos / ubuntu.
# Important    : None
# Future scope : 1. Make code more streamlined.
# References   : None
#--------------------------------------------------------------------#

source ./mrulogger.sh

SCRIPT_ENTRY

setup_progress_status_filename="/home/core/copy-softwares-setup_progress_status_value";

function COPY_EXTRA_SOFTWARE_PACKAGES(){
    
    # Check whether "/" is mounted from inserted disk or not...
    CHECK_IF_ROOT_MOUNTED_FROM_USB_DISK "$BASH_SOURCE";

    # Step 1 : Copy tar file
    GET_SETUP_PROGRESS "$setup_progress_status_filename";

    if [ "$setup_progress_status" == "0" ] || [ "$setup_progress_status" == "" ]; then
        CHECK_CORRECT_USB_DISK "$BASH_SOURCE";
        
        INFO "Setup progress status value: $setup_progress_status. Hence copying extra software packages (Copy tar file)." "$BASH_SOURCE" "green";
        
    #    source_path="/mnt/home/core/setup-software/Tools /mnt/home/core/setup-software/coreos /mnt/home/core/setup-software/i2c-softwares /mnt/home/core/setup-software/syncthing ";
        source_path="/mnt/home/core/setup-software/extra_software_packages.tar.bz2";
        destination_path="/home/core/setup-software/" ;
        INFO "Copy extra softwares from $source_path to $destination_path" "$BASH_SOURCE" "green";
        RSYNC_CONTENT "$source_path" "$destination_path";
    	if [ "${command_status_value}" == "Successful" ]; then
            INFO "Copying of extra softwares finished successfully." "" "green";
            UMOUNT_PARTITION "/dev/$selected_usb_disk" "/mnt/";
	
            SET_SETUP_PROGRESS "$setup_progress_status_filename" "1";
    	elif [ "${command_status_value}" == "Failed" ]; then
            CRITICAL "Copying of extra softwares doesn't finish successfully.";
	    exit 1;
    	else
            CRITICAL "Error: Oops something went wrong. Contact system administator or CLIx technical team - Mumbai.";
            exit 1;
    	fi
    else
        CRITICAL "Setup progress step value is ${setup_progress_status}, hence continuing with the process skipping the step 1." "$BASH_SOURCE";
#        exit 1;
    fi


    # Step 2 : Untar file
    GET_SETUP_PROGRESS "$setup_progress_status_filename";

    if [ "$setup_progress_status" == "1" ]; then
        INFO "Setup progress status value: $setup_progress_status. Hence contining to untar the tar file." "$BASH_SOURCE" "green";
        
        INFO "Untar the extra_software_packages.tar.bz2 (tar file)" "$BASH_SOURCE" "green";
        cd /home/core/setup-software/ ;
        sudo tar xvjf extra_software_packages.tar.bz2
	echo "mrunal"
	CHECK_COMMAND_STATUS; 
    	if [ "${command_status_value}" == "Successful" ]; then
            INFO "Untaring of extra softwares tar finished successfully." "" "green";	
            SET_SETUP_PROGRESS "$setup_progress_status_filename" "2";
    	elif [ "${command_status_value}" == "Failed" ]; then
            CRITICAL "Copying of extra softwares doesn't finish successfully.";
	    exit 1;
    	else
            CRITICAL "Error: Oops something went wrong. Contact system administator or CLIx technical team - Mumbai.";
            exit 1;
    	fi
	
    else
        CRITICAL "Setup progress step value is ${setup_progress_status}, hence continuing with the process skipping the step 2." "$BASH_SOURCE";
 #       exit 1;
    fi

    if [ "$setup_progress_status" -ge "2" ]; then
        INFO "It seems nothing to do. Either everything finished successfully or something failed.\nPlease verify manually" "$BASH_SOURCE" "yellow"; 
    fi
}

#**************************** Copying process starts from here ********************************#

COPY_EXTRA_SOFTWARE_PACKAGES;

#**************************** Copying process ends here ********************************#

SCRIPT_ENTRY

exit 0;
