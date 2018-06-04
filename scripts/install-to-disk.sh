#!/bin/bash

source ./mrulogger.sh;

SCRIPT_ENTRY ;

function install-to-disk(){

    sudo dmesg -n1;

    # Mrunal : below part is added by Mrunal as suggested by Nagarjuna
    INFO "\n\n\n***   CLIx Server Installer - Release Version May 2018   ***\n\n
        School server installation      \n\n
    Note : \nThis installation is a one-time or infrequently used process.
    It uses a terminal-console which may show many details during installation.
    This is normal. Please let the installation proceed.\n" "$BASH_SOURCE" "cyan";
    
    sleep 5
    
    INFO "\n${cyan}Starting clix ${reset}" "$BASH_SOURCE" "cyan";
    docker start gstudio
    INFO "\n\n\n" "$BASH_SOURCE" "cyan";
    
    sleep 5

    check_disk_h=`lsblk | grep TYPE`
    check_disk_d=`lsblk | grep disk`
    GET_INPUTS "Name the disk where do you want to install the server?
    (For example 'sda' or 'sdb' or 'sdc')
    {if you are not sure and want to exit simply type enter}
    \n$check_disk_h \n$check_disk_d
    \ndisk name (with help of above information) :" "$BASH_SOURCE" "olive";

    eval disk_i=$input;
    if [[ "$disk_i" == "" ]]; then

        CRITICAL "No input. Hence exiting. Please try again later." "$BASH_SOURCE";
        exit;

    else 

        INFO "Disk entered is $disk_i \n" "$BASH_SOURCE" "green";
        check_disk=`lsblk | grep $disk_i | grep disk | wc -l`
        if [[ "$check_disk" != "1" ]]; then
            CRITICAL "Invalid input. Hence exiting. Please try again later." "$BASH_SOURCE";
            exit;
        fi

        GET_INPUTS "\nCaution: \nIt will format $disk_i disk \nAre you sure you want to proceed?\nY/N :" "$BASH_SOURCE" "red";

        eval part_format_i=$input;
        if [[ "$part_format_i" == "" ]]; then

            CRITICAL "No input. Hence exiting. Please try again later.\n" "$BASH_SOURCE";
            exit;

        elif  [[ "$part_format_i" == "n" ]] || [[ "$part_format_i" == "N" ]] || [[ "$part_format_i" == "no" ]] || [[ "$part_format_i" == "No" ]] || [[ "$part_format_i" == "NO" ]]; then

            INFO "Input is '$part_format_i'. Hence exiting. Thank you.\n" "$BASH_SOURCE" "pink";
            exit;

        elif  [[ "$part_format_i" == "y" ]] || [[ "$part_format_i" == "Y" ]] || [[ "$part_format_i" == "yes" ]] || [[ "$part_format_i" == "Yes" ]] || [[ "$part_format_i" == "YES" ]]; then

            INFO "Input is '$part_format_i'. Continuing the process.\n" "$BASH_SOURCE" "green";

        else

            CRITICAL "Input is '$part_format_i'. Oops!!! Something went wrong.\n" "$BASH_SOURCE";
            exit;
        fi
        
    fi

    INFO "Installing coreos, the host operating system to /dev/$disk_i \n" "$BASH_SOURCE" "cyan";
    sudo /home/core/setup-software/coreos/coreos-install -d /dev/$disk_i -C stable -c /home/core/setup-software/coreos/cloud-config.yaml -V 1010.5.0 -b http://localhost/softwares/coreos/mirror ;

}

install-to-disk  |   tee install-to-disk.log;
SCRIPT_EXIT;
exit;
