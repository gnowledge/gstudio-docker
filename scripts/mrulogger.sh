#!/bin/bash
#--------------------------------------------------------------------#
# Logging and useful functions for bash 
# File name    : mrulogger.sh
# File version : 1.0
# Created by   : Mr. Mrunal M. Nachankar
# Created on   : Thu Jan 18 00:54:21 IST 2018
# Modified by  : None
# Modified on  : Not yet
# Description  : This file is used for having logging and useful functions for bash.
# Important    : 1. Change / Add / Fill your detail in "Fill in your details here" block.
#                2. Color code are used. Add more to it if needed
#                3. LOG_LEVEL is set to 5 by default to have everything logged in.
#                4. Watchout for different parameters for LOG functions".
# Future scope : 1. Documentation improvements.
#                2. Cutdown the on number of lines.
#                3. Have more no of valiadation code.
#                4. Handle usage / command line arguments crisply
# References   : 1. 
#                2. http://www.goodmami.org/2011/07/04/Simple-logging-in-BASH-scripts.html
#--------------------------------------------------------------------#

exec 3>&2 # logging stream (file descriptor 3) defaults to STDERR

################ Colored output details here ################ 
# Following variables are used to store the color codes for displaying the content on terminal
#Ref: https://misc.flogisoft.com/bash/tip_colors_and_formatting
reset="\e[0m" ;
black="\e[38;5;0m" ;
red="\e[38;5;1m" ;
green="\e[38;5;2m" ;
yellow="\e[38;5;3m" ;
blue="\e[38;5;4m" ;
purple="\e[38;5;5m" ;
cyan="\e[38;5;6m" ;
grey="\e[38;5;245m" ;
white="\e[38;5;256m" ;
brown="\e[38;5;94m" ;
light_green="\e[38;5;119m" ;
pink="\e[38;5;199m" ;
orange="\e[38;5;208m" ;
olive="\e[38;5;100m" ;
orange="\e[38;5;208m" ;
#############################################################


################# Fill in your details here ################# 
# Levels defined for different type of messages
CRITICAL_LEVEL=0;           
ERROR_LEVEL=1;
WARNING_LEVEL=2;
INFO_LEVEL=3;
FUNCTION_NAME_LEVEL=4;
SCRIPT_NAME_LEVEL=5;

# Set Type of logs to print on screen as well as log in file
# Highest numebr will have all types of logs and lowest will have only mentioned
# if LOG_LEVEL=0, then CRITICAL_LEVEL
# if LOG_LEVEL=1, then CRITICAL_LEVEL + ERROR_LEVEL
# if LOG_LEVEL=2, then CRITICAL_LEVEL + ERROR_LEVEL + WARNING_LEVEL
# if LOG_LEVEL=3, then CRITICAL_LEVEL + ERROR_LEVEL + WARNING_LEVEL + INFO_LEVEL
# if LOG_LEVEL=4, then CRITICAL_LEVEL + ERROR_LEVEL + WARNING_LEVEL + INFO_LEVEL + FUNCTION_NAME_LEVEL
# if LOG_LEVEL=5, then CRITICAL_LEVEL + ERROR_LEVEL + WARNING_LEVEL + INFO_LEVEL + FUNCTION_NAME_LEVEL + SCRIPT_NAME_LEVEL
LOG_LEVEL=5;
#############################################################


declare selected_usb_disk; 
declare i n;

################ Log file details are here ################## 
# Set the filename
SCRIPT_LOG=$(pwd)/$0.log;
# Set the filename
if [ -f $SCRIPT_LOG ]; then
    echo -e "${green}$SCRIPT_LOG already exist.${reset}";                                  # Use echo here as it is called at startup
else
    touch $SCRIPT_LOG;
    echo -e "${green}$SCRIPT_LOG doesn't exist. Hence created a blank file.${reset}";      # Use echo here as it is called at startup
fi
#############################################################


################ Functions written are here ################# 
function SCRIPT_ENTRY(){
    local source_filename="; {SOURCE SCRIPT name: $2} ";
    CHECK_FOR_EMPTY_SOURCE;
    script_name=`basename "$0"`; 
    script_name="{SCRIPT name:""${script_name%.*}""}";
    timeAndDate=`date`;
    log_msg="\n${grey}[$timeAndDate] [SCRIPT_ENTRY]   [ $script_name $source_filename] ${reset}";
    LOG_PRINT $SCRIPT_NAME_LEVEL $log_msg;
}

function SCRIPT_EXIT(){
    local source_filename="; {SOURCE SCRIPT name: $2} ";
    CHECK_FOR_EMPTY_SOURCE;
    script_name=`basename "$0"`;
    script_name="{SCRIPT name:""${script_name%.*}""}";
    log_msg="\n${grey}[$timeAndDate] [SCRIPT_EXIT]    [ $script_name  $source_filename] ${reset}";
    LOG_PRINT $SCRIPT_NAME_LEVEL $log_msg;
}

#  ---   x   ---

function FUNCTION_ENTRY(){
    local function_name="{FUNCTION name: ${FUNCNAME[1]}}";
    local source_filename="; {SOURCE SCRIPT name: $2} ";
    CHECK_FOR_EMPTY_SOURCE;
    script_name=`basename "$0"`;
    script_name="{SCRIPT name:""${script_name%.*}""}";
    timeAndDate=`date`;
    log_msg="\n${grey}[$timeAndDate] [FUNCTION_ENTRY] [ $script_name $function_name $source_filename] ${reset}";
    LOG_PRINT $FUNCTION_NAME_LEVEL $log_msg;
}

function FUNCTION_EXIT(){
    local function_name="; {FUNCTION name: ${FUNCNAME[1]}}";
    local source_filename="; {SOURCE SCRIPT name: $2} ";
    CHECK_FOR_EMPTY_SOURCE;
    script_name=`basename "$0"`;
    script_name="{SCRIPT name:""${script_name%.*}""}";
    timeAndDate=`date`;
    log_msg="\n${grey}[$timeAndDate] [FUNCTION_EXIT]  [ $script_name $function_name $source_filename] ${reset}";
    LOG_PRINT $FUNCTION_NAME_LEVEL $log_msg;
}

#  ---   x   ---

function INFO(){
    local function_name="; {FUNCTION name: ${FUNCNAME[1]}}";
    local msg="$1";
    local source_filename="; {SOURCE SCRIPT name: $2} ";
    CHECK_FOR_EMPTY_SOURCE;
    script_name=`basename "$0"`;
    timeAndDate=`date`;
    if [ "$3" == "" ] || [ "$#" -le "2" ]; then
        font_color="olive"; 
    else
        eval font_color=$3;
    fi
#    log_msg="\n${cyan}[$timeAndDate] [INFO MSG]       [$script_name $function_name] $msg  $source_filename ${reset}" 
    log_msg="\n${grey}[$timeAndDate] [INFO MSG]       [ $script_name $function_name $source_filename] \n${!font_color}$msg ${reset}";
    LOG_PRINT $INFO_LEVEL $log_msg;
}

function WARNING(){
    local function_name="; {FUNCTION name: ${FUNCNAME[1]}}";
    local msg="$1";
    local source_filename="; {SOURCE SCRIPT name: $2} ";
    CHECK_FOR_EMPTY_SOURCE;
    script_name=`basename "$0"`;
    timeAndDate=`date`;
    log_msg="\n${grey}[$timeAndDate] [WARNING MSG]    [ $script_name $function_name $source_filename] \n${yellow}$msg ${reset}";
    LOG_PRINT $WARNING_LEVEL $log_msg
}

function ERROR(){
    local function_name="; {FUNCTION name: ${FUNCNAME[1]}}";
    local msg="$1";
    local source_filename="; {SOURCE SCRIPT name: $2} ";
    CHECK_FOR_EMPTY_SOURCE;
    script_name=`basename "$0"`;
    timeAndDate=`date`;
    log_msg="\n${grey}[$timeAndDate] [ERROR MSG]      [ $script_name $function_name $source_filename] \n${orange}$msg ${reset}";
    LOG_PRINT $ERROR_LEVEL $log_msg;
}

function CRITICAL(){
    local function_name="; {FUNCTION name: ${FUNCNAME[1]}}";
    local msg="$1";
    local source_filename="; {SOURCE SCRIPT name: $2} ";
    CHECK_FOR_EMPTY_SOURCE;
    script_name=`basename "$0"`;
    timeAndDate=`date`;
    log_msg="\n${grey}[$timeAndDate] [CRITICAL MSG]   [ $script_name $function_name $source_filename] \n${red}$msg ${reset}";
    LOG_PRINT $CRITICAL_LEVEL $log_msg;
}

#  ---   x   ---

function LOG_PRINT(){
    local function_name="{FUNCTION name: ${FUNCNAME[1]}}";
    if [ "$LOG_LEVEL" == "" ]; then
        LOG_LEVEL=0;
    fi
    if [ "$LOG_LEVEL" -ge "$1" ]; then
        # Expand escaped characters, wrap at 70 chars, indent wrapped lines
#        echo -e "$log_msg" | fold -w70 -s | sed '2~1s/^/  /' ;
        echo -e "$same_line_input_echo_argument" "$log_msg" | tee -a $SCRIPT_LOG ;
#        echo -e "$log_msg"  >&3;                     #Working - only prints in log file
    fi
}

#  ---   x   ---

function GET_INPUTS(){
    local function_name="; {FUNCTION name: ${FUNCNAME[1]}}";
    local msg="$1";
    local source_filename="; {SOURCE SCRIPT name: $2} ";
    CHECK_FOR_EMPTY_SOURCE;
    timeAndDate=`date`;
    if [ "$3" == "" ] || [ "$#" -le "2" ]; then
        font_color="olive"; 
    else
        eval font_color=$3;
    fi
    log_msg="\n${grey}[$timeAndDate] [GET_INPUTS]       [ $script_name $function_name $source_filename] \n${!font_color}$msg ${brown}";
#    log_msg="\n${olive}[$timeAndDate] [GET_INPUTS]     [ $script_name $function_name $source_filename] \n$msg  ${reset}";
    same_line_input_echo_argument="-n";
    LOG_PRINT $INFO_LEVEL $log_msg;
    read input
    echo -e ${reset};
    same_line_input_echo_argument="";
    CHECK_COMMAND_STATUS;
    if [ "${command_status_value}" == "Successful" ]; then
        if [ "${input}" == "" ]; then
            CRITICAL "Invalid input. Value entered is '$input'. Please try again.";
            exit;
        else
            INFO "Input has some value. Value entered is '$input'" "" "green"; 
        fi
    else
        ERROR "Oops something went wrong.";
    fi
}

#  ---   x   ---

# Check if source is empty 
function CHECK_FOR_EMPTY_SOURCE(){
    if [[ "$source_filename" == "; {SOURCE SCRIPT name: } " ]]; then
        source_filename="";
    fi
}

# Check for command execution status (Correct execution returns 0 else the error code. Hence print sucess/failed message with return value{response code})
function CHECK_COMMAND_STATUS(){
    cmd_status_val=$?;
    if [ $cmd_status_val -eq 0 ]; then
#    	local function_name="{FUNCTION name: ${FUNCNAME[1]}}";
        INFO "Command execution successful. (Execution value: $cmd_status_val)" "" "green";
        command_status_value="Successful";  
    else
        ERROR "Command execution failed. (Execution value: $cmd_status_val)";
        command_status_value="Failed";
    fi
#    local function_name="{FUNCTION name: ${FUNCNAME[1]}}";

} 

# Fetch all connected USB disknames
function GET_USB_DISKNAMES(){
    i=0;
    
    # Store list of disknames in an arrary
    all_disknames=($(lsblk | grep disk  | awk '{print $1}'));

    # for each disknames
    for ((d=0; d<${#all_disknames[@]}; d++));
    do
        # Find connected disknames from all disk names 1 by 1
        find /dev/disk/by-id/ -lname "*${all_disknames[$d]}" | grep usb ; 
        if [ $? -eq 0 ]; then
            # Store list of USB disknames in an arrary
            usb_disknames[$i]="${all_disknames[$d]}";
            ((i++));
        fi
    done
}
# Check whether "/" is mounted from inserted disk or not...
function CHECK_IF_ROOT_MOUNTED_FROM_USB_DISK(){
    # Fetch all connected USB disknames
    GET_USB_DISKNAMES;

    # for each USB disknames
    for ((d=0; d<${#usb_disknames[@]}; d++));
    do
        df -h | grep -w / | grep "${usb_disknames[$d]}";         
        if [ $? -eq 0 ]; then
            GET_INPUTS "'\' (root patition) is mounted from connected USB disk.\nIdeally it should not be the case.\nPlease consult before going ahead.\n\nDo you want to continue?(Y/N)";
            eval continue_root_mounted_from_usb_disk=$input;
            if [[ "$continue_root_mounted_from_usb_disk" == "" ]]; then
                CRITICAL "No input. Hence exiting. Please try again later.\n" "";
                exit;
            elif  [[ "$continue_root_mounted_from_usb_disk" == "n" ]] || [[ "$continue_root_mounted_from_usb_disk" == "N" ]] || [[ "$continue_root_mounted_from_usb_disk" == "no" ]] || [[ "$continue_root_mounted_from_usb_disk" == "No" ]] || [[ "$continue_root_mounted_from_usb_disk" == "NO" ]]; then
                INFO "Input is '$continue_root_mounted_from_usb_disk'. Hence exiting. Thank you.\n" "" "pink";
                exit;
            elif  [[ "$continue_root_mounted_from_usb_disk" == "y" ]] || [[ "$continue_root_mounted_from_usb_disk" == "Y" ]] || [[ "$continue_root_mounted_from_usb_disk" == "yes" ]] || [[ "$continue_root_mounted_from_usb_disk" == "Yes" ]] || [[ "$continue_root_mounted_from_usb_disk" == "YES" ]]; then
                INFO "Input is '$continue_root_mounted_from_usb_disk'. Continuing the process.\n" "" "green";
                break;
            else
                CRITICAL "Input is '$continue_root_mounted_from_usb_disk'. Oops!!! Something went wrong.\n" "";
                exit;
            fi
        fi
    done    
}

# Check whether inserted disk is correct or not...
function CHECK_CORRECT_USB_DISK(){
    if [ ! -z "$selected_usb_disk" ]; then
        lsblk | grep part | grep "$selected_usb_disk";
        if [ $? -eq 0 ]; then
            MOUNT_PARTITION "/dev/$selected_usb_disk" "/mnt/";
            if [ -d "/mnt/home/core/data" ] && [ -d "/mnt/home/core/setup-software" ]; then
                correct_usb_disk="Found";
                INFO "We found that you have already selected ${usb_disknames[$d]}$i partition and also detected required files for installations in the same. Hence continuing the process." "" "green";
                return 0;           # To directly exit this function
            fi
        fi
    fi

    # Fetch all connected USB disknames
    GET_USB_DISKNAMES;

    if [ ${#usb_disknames[@]} -eq 0 ]; then
        for (( n=1; n<=5; n++ )); 
        do
            GET_USB_DISKNAMES;
            if [ ${#usb_disknames[@]} -eq 0 ]; then
                    sleep 5;
                    INFO "Waiting for the installer (pen drive / portable HDD). (Try $n of 5)" "" "orange";
                    if [[ $n == 5 ]]; then
                            CRITICAL "Installer (pen drive / portable HDD) not found. Retry installation.";
                            disk_status="Not_found";
                            #exit;       # For testing comment here
                    fi
            elif [ ${#usb_disknames[@]} -gt 0 ]; then
                    INFO "Disk found. Verifying the disk.";
                    disk_status="Found";
                    break
            fi
        done
    fi 
    correct_usb_disk="NotFound";
    # for each USB disknames
    for ((d=0; d<${#usb_disknames[@]}; d++));
    do
        for i in {1,2,3,9}; 
        do
            # Check whether partition exist
            lsblk | grep part | grep ${usb_disknames[$d]}$i;
            if [ $? -eq 0 ]; then
                MOUNT_PARTITION "/dev/${usb_disknames[$d]}$i" "/mnt/";
                if [ -d "/mnt/home/core/data" ] && [ -d "/mnt/home/core/setup-software" ]; then
                    correct_usb_disk="Found";
                    INFO "We have detected required files for installations in ${usb_disknames[$d]}$i partition of ${usb_disknames[$d]} disk." "" "green";
                    GET_INPUTS "Is this your installer disk?(Y/N)";
                    eval continue_root_mounted_from_usb_disk=$input;
                    if [[ "$continue_root_mounted_from_usb_disk" == "" ]]; then
                        CRITICAL "No input. Hence exiting and continuing with the process." "";
                    elif  [[ "$continue_root_mounted_from_usb_disk" == "n" ]] || [[ "$continue_root_mounted_from_usb_disk" == "N" ]] || [[ "$continue_root_mounted_from_usb_disk" == "no" ]] || [[ "$continue_root_mounted_from_usb_disk" == "No" ]] || [[ "$continue_root_mounted_from_usb_disk" == "NO" ]]; then
                        INFO "Input is '$continue_root_mounted_from_usb_disk'. Hence exiting. Thank you." "" "pink";
                    elif  [[ "$continue_root_mounted_from_usb_disk" == "y" ]] || [[ "$continue_root_mounted_from_usb_disk" == "Y" ]] || [[ "$continue_root_mounted_from_usb_disk" == "yes" ]] || [[ "$continue_root_mounted_from_usb_disk" == "Yes" ]] || [[ "$continue_root_mounted_from_usb_disk" == "YES" ]]; then
                        INFO "Input is '$continue_root_mounted_from_usb_disk'. Continuing the process." "" "green";
                        #UMOUNT_PARTITION "/dev/${usb_disknames[$d]}$i" "/mnt/";
                        correct_usb_disk="FoundAndContinue";
                        selected_usb_disk="${usb_disknames[$d]}$i";
                        break;
                    else
                        CRITICAL "Input is '$continue_root_mounted_from_usb_disk'. Oops!!! Something went wrong." "";
                    fi
                fi
                UMOUNT_PARTITION "/dev/${usb_disknames[$d]}$i" "/mnt/";
            fi
        done
    done
    if [ "$correct_usb_disk" == "Found" ]; then
        CRITICAL "Disk was having required files for installations. But you have denied for continuing the installation process with this disk.\nHence please insert correct disk and try again later.";
        correct_usb_disk="NotFound";
        exit;
    elif [ "$correct_usb_disk" == "FoundAndContinue" ]; then
        echo "";
    else
        CRITICAL "This disk is not disk we are looking for. Please insert correct disk and try again.";
        correct_usb_disk="NotFound";
        exit;
    fi
}

function MOUNT_PARTITION(){
    UMOUNT_PARTITION  "$1" "$2" "$3";
    if [ -z mount_options ]; then
        mount_options="";
    fi
    INFO "mounting $1 in $2" "" "cyan"; 
#    sudo mount $mount_options $mount_source $mount_destination;
    sudo mount $3 $1 $2;
}
function UMOUNT_PARTITION(){
    if [ -z mount_options ]; then
        mount_options="";
    fi
    INFO "unmounting $1 in $2" "" "cyan"; 
#    sudo umount $mount_options $mount_source $mount_destination;
    sudo umount $3 $1 $2;
}

function CHECK_FILE_EXISTENCE(){
    local filename="$1";
    if [[ -f $filename ]]; then
        INFO "File ($filename) already exists." "" "green";
        file_existence_status="Present";
    elif [[ ! -f $filename ]]; then
        INFO "File ($filename) doesn't exists." "" "yellow";
        file_existence_status="Not_Present";
        if [[ "$2" == "create" ]]; then
            touch $filename;
            if [ "$?" == "0" ]; then
                INFO "File ($filename) doesn't exists. Got signal to create the same. Hence created successfully." "" "green";
                directory_existence_status="Present";
            else
                INFO "File ($filename) doesn't exists. Got signal to create the same. Unfortunately failed to create." "" "yellow";
            fi
        fi
    else
        ERROR "Error: Oops something went wrong. Contact system administator or CLIx technical team - Mumbai. ($filename)" "" "orange";
    fi  
}

function CHECK_DIRECTORY_EXISTENCE(){
    directoryname="$1";
    if [[ -d $directoryname ]]; then
        INFO "Directory ($directoryname) already exists." "" "green";
        directory_existence_status="Present";
    elif [[ ! -d $directoryname ]]; then
        INFO "Directory ($directoryname) doesn't exists." "" "yellow";
        directory_existence_status="Not_Present";
        if [[ "$2" == "create" ]]; then
            mkdir -p $directoryname;
            if [ "$?" == "0" ]; then
                INFO "Directory ($directoryname) doesn't exists. Got signal to create the same. Hence created successfully." "" "green";
                directory_existence_status="Present";
            else
                INFO "Directory ($directoryname) doesn't exists. Got signal to create the same. Unfortunately failed to create." "" "yellow";
            fi
        fi
    else
        ERROR "Error: Oops something went wrong. Contact system administator or CLIx technical team - Mumbai. ($directoryname)" "" "orange";
    fi  
}

# This function will check the type of content (file, directory or No idea)
function TYPE_OF_CONTENT(){
    # Type of content
    #  D=Directory
    #  F=File
    #  L=Soft link
    #  N=No idea
    content="$1";
    if [[ -d $content ]]; then
        INFO "$content is a directory" "" "green";
        content_type="D";
    elif [[ -f $content ]]; then
        INFO "$content is a file" "" "green";
        content_type="F";
    elif [[ -L $content ]]; then
        INFO "$content is a soft link" "" "green";
        content_type="L";
    else
        INFO "$content is not valid" "" "green";
        content_type="N";
        #exit 1;
    fi
}


# This function will validate, copy the content increamentally from source to destination. (Can take care partial copy)
#   + Directory existence 
#   + Data integrity
#   + In case of partial copy rsync will handle it
function RSYNC_CONTENT(){
    CHECK_DIRECTORY_EXISTENCE "$destination_path" "create"
    
    if [ "$directory_existence_status" == "Present" ]; then
        INFO "Destination directory exists. Hence proceeding to check for the source content." "" "green";
	
        TYPE_OF_CONTENT "$source_path";
    	if [ "$content_type" == "F" ] || [[ "$source_path" =~ "." ]] ; then
            
	    CHECK_FILE_EXISTENCE "$source_path"
            
    	    if [ "$file_existence_status" == "Present" ]; then
                INFO "Source file exists. Hence proceeding to copy the content." "" "green";
	        
                INFO "copy clix-server data and necessary files from $source_path to $destination_path. \nThis may take time, please be patient. (Approx 15-30 min depending on the system performance)" "" "green";
                sudo rsync -avPh "$1" "$source_path" "$destination_path";      # For testing comment here
    	        CHECK_COMMAND_STATUS;
            elif  [ "$file_existence_status" == "Not_Present" ]; then
                CRITICAL "Source file doesn' t exists. Hence skipping the process of copying the content and continuing with the process";
                exit 1;                                   		       # For continuing please comment herer 
            else
                CRITICAL "Error: Oops something went wrong. Contact system administator or CLIx technical team - Mumbai.";
                exit 1;
            fi
    	elif [ "$content_type" == "D" ] || [[ "$source_path" != *"."* ]]; then
            
	    CHECK_DIRECTORY_EXISTENCE "$source_path"
            
    	    if [ "$directory_existence_status" == "Present" ]; then
                INFO "Source directory exists. Hence proceeding to copy the content." "" "green";
	        
                INFO "copy clix-server data and necessary files from $source_path to $destination_path. \nThis may take time, please be patient. (Approx 15-30 min depending on the system performance)" "" "green";
                sudo rsync -avPh "$1" "$source_path" "$destination_path";      # For testing comment here
    	        CHECK_COMMAND_STATUS;
            elif  [ "$directory_existence_status" == "Not_Present" ]; then
                CRITICAL "Source directory doesn' t exists. Hence skipping the process of copying the content and continuing with the process";
                exit 1;
            else
                CRITICAL "Error: Oops something went wrong. Contact system administator or CLIx technical team - Mumbai.";
                exit 1;
            fi
	else
            CRITICAL "Error: Oops something went wrong. Contact system administator or CLIx technical team - Mumbai.";
            exit 1;
        fi
    elif  [ "$directory_existence_status" == "Not_Present" ]; then
        CRITICAL "Destination directory doesn' t exists. Hence skipping the process of copying the content and continuing with the process";
        exit 1;
    else
        CRITICAL "Error: Oops something went wrong. Contact system administator or CLIx technical team - Mumbai.";
        exit 1;
    fi
}

function CHECK_FOR_ALREADY_LOADED_DOCKER_IMAGE(){       #docker_load_validation
    #echo "docker_image_name:$docker_image_name"        # For testing uncomment here
    docker images | grep $docker_image_grep_name;
    CHECK_COMMAND_STATUS;
    if [ "${command_status_value}" == "Successful" ]; then
        INFO "$docker_image_name docker image already loaded." "" "green";
    elif [ "${command_status_value}" == "Failed" ]; then
        CRITICAL "$docker_image_name docker image is not loaded." "";
        LOADING_DOCKER_IMAGE;
    else
        CRITICAL "Error: Oops something went wrong. Contact system administator or CLIx technical team - Mumbai.";
        exit 1;
    fi
}

function LOADING_DOCKER_IMAGE(){                        #docker_load
    CHECK_FILE_EXISTENCE $docker_image_path;
    if [ "$file_existence_status" == "Present" ]; then
        INFO "Loading $docker_image_name docker image" "" "green";
        WARNING "caution : it may take long time";
        docker load < $docker_image_path;                   # For testing comment here
        CHECK_COMMAND_STATUS;
        if [ "${command_status_value}" == "Successful" ]; then
            INFO "$docker_image_name docker image loaded successfully." "" "green";
        else
            CRITICAL "$docker_image_name docker image could not be loaded.\nPlease try again" "";
            exit 1;
        fi
    elif [ "$file_existence_status" == "Not_Present" ]; then
        CRITICAL "$docker_image_path docker image tar file could not be located/found.\nPlease try again" "";
        echo "0" > $setup_progress_status_filename;
        exit 1;
    else
        CRITICAL "Error: Oops something went wrong. Contact system administator or CLIx technical team - Mumbai.";
        exit 1;
    fi
}

function CHECK_FOR_ALREADY_STARTED_DOCKER_CONTAINER(){
    docker ps -a | grep $docker_container_name; # >> /dev/null
    CHECK_COMMAND_STATUS;
    if [ "${command_status_value}" == "Successful" ]; then
        INFO "$docker_image_name docker container already started." "" "green";
    elif [ "${command_status_value}" == "Failed" ]; then
        STARTING_DOCKER_CONTAINER;
    else
        CRITICAL "Error: Oops something went wrong. Contact system administator or CLIx technical team - Mumbai.";
        exit 1;
    fi
}

function STARTING_DOCKER_CONTAINER(){
    INFO "Running $docker_container_name docker container" "" "green";
    WARNING "caution : it may take long time";
#    docker run $docker_flag $docker_volumes $docker_ports --name="$docker_container_name" $docker_image_name;      # For testing comment here
    CHECK_FILE_EXISTENCE $docker_compose_filename;
    if [ "$file_existence_status" == "Present" ]; then
        INFO "Loading $docker_container_name docker container" "" "green";
        WARNING "caution : it may take long time";
        docker-compose -f $docker_compose_filename up -d;
        CHECK_COMMAND_STATUS;
        if [ "${command_status_value}" == "Successful" ]; then
            INFO "$docker_container_name docker container started successfully." "" "green";
        else
            CRITICAL "$docker_container_name docker container could not be started.\nPlease try again" "";
            exit 1;
        fi
    elif [ "$file_existence_status" == "Not_Present" ]; then
        CRITICAL "$docker_compose_filename docker-compose file could not be located/found.\nPlease try again" "";
        echo "0" > $setup_progress_status_filename;
        exit 1;
    else
        CRITICAL "Error: Oops something went wrong. Contact system administator or CLIx technical team - Mumbai.";
        exit 1;
    fi
    
}

function GET_SETUP_PROGRESS(){
    CHECK_FILE_EXISTENCE $1 "create";
    setup_progress_status=$(more $1);
    INFO "Setup progress status value:${setup_progress_status}" "" "blue";
}
function SET_SETUP_PROGRESS(){
    CHECK_FILE_EXISTENCE $1 "create";
    echo -e "$2" > $1;
    setup_progress_status=$(more $1);
    INFO "Setup progress status value:${setup_progress_status}" "" "blue";
}

function SET_LANGUAGE(){
    state_code="$1";
    if [ ${state_code} == "ct" ] || [ ${state_code} == "rj" ]; then
        INFO "State code is ${state_code}. Hence setting hi as language." "" "cyan"
        language="hi";
    elif [ ${state_code} == "mz" ]; then
        INFO "State code is ${state_code}. Hence setting en as language." "" "cyan"
        language="en";
    elif [ ${state_code} == "tg" ]; then
        INFO "State code is ${state_code}. Hence setting te as language." "" "cyan"
        language="te";
    else
        CRITICAL "Error: Oops something went wrong. Contact system administator or CLIx technical team - Mumbai. ($directoryname)";
        exit 1;
    fi  
}


#############################################################



################ Usage block details are here ############### 
# This is for handling command line arguments(in this case OPTIONS) passed while executing the file
# usage message will be displayed when invalid argument is passed or invalid value for the argument is passed to provide help text.
usage() {
    echo -e "${cyan}Usage:\n  $0 [OPTIONS] \nOptions: \n  -h      : display this help message \n  -l      : log / verbosity level (0-5) \n  -f FILE : redirect logging to FILE instead of STDERR. Please provide full path${reset}"
}

while getopts ":hl:loglevel:f:" opt; do
    case "$opt" in
       h)  usage; exit 0 ;;
       l)  LOG_LEVEL=$OPTARG ;;
       f)  SCRIPT_LOG=$OPTARG ;;
#       l) exec 3>>$OPTARG ;;
       \?) echo -e "${red}Invalid options: -$OPTARG ${reset}"; usage; exit 1 ;;
       :)  echo -e "${red}Invalid options argument(value): -$OPTARG requires an argument ${reset}"; usage; exit 1 ;;
       \*) echo -e "${red}Invalid options: $1 ${reset}"; usage; exit 1 ;;
    esac
done
shift $((OPTIND -1))                # Here i need to come back : https://dustymabe.com/2013/05/17/easy-getopt-for-a-bash-script/ 
while getopts ":hl:loglevel:f:" opt; do
    case "$opt" in
       h)  usage; exit 0 ;;
       "l"|"loglevel")  LOG_LEVEL=$OPTARG ;;
       f)  SCRIPT_LOG=$OPTARG ;;
#       l) exec 3>>$OPTARG ;;
       \?) echo -e "${red}Invalid options: -$OPTARG ${reset}"; usage; exit 1 ;;
       :)  echo -e "${red}Invalid options argument(value): -$OPTARG requires an argument ${reset}"; usage; exit 1 ;;
       \*) echo -e "${red}Invalid options: $1 ${reset}"; usage; exit 1 ;;
    esac
done
shift $((OPTIND -1))                # This 

#############################################################
