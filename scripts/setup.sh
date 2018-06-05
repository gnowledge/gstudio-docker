#!/bin/bash

#--------------------------------------------------------------------#
# setup CLIx student platform in coreos / ubuntu 
# File name    : setup.sh
# File version : 2.0
# Created by   : Mr. Mrunal M. Nachankar
# Created on   : Thu Jan 18 00:54:21 IST 2018
# Modified by  : Mr. Mrunal M. Nachankar
# Modified on  : Sun Apr 29 11:44:17 IST 2018
# Description  : This file is used for installation and setup of CLIx student paltform in coreos / ubuntu.
# Important    : 1. Change / Add / Fill your detail in "Fill in your details here" block.
#                2. Ensure mongodb is installed and configured properly.
#                3. Script is by default assuming no authentication, localhost as host and default 27017.
#                4. Files will be generated with "<db_name><collection_name>.csv".
#                5. Files will be generated in the same directory from where shell file is triggered.
# Future scope : 1. Make it compatible with arguments as laymans will not be able to edit this file.
#                2. Make it compatible to just fetch single collection of database.
#                3. Make it compatible to export in json format.
# References   : 1. https://gist.github.com/mderazon/8201991#file-mongo-dump-csv-sh
#                1.1 https://www.drzon.net/posts/export-mongodb-collections-to-csv-without-specifying-fields/
#                1.2 https://stackoverflow.com/questions/6814151/how-to-export-collection-to-csv-in-mongodb
#                2. https://gist.github.com/zubairalam/ab0a8d6a32439f74d267#file-make_csv-sh
#--------------------------------------------------------------------#

source ./mrulogger.sh

SCRIPT_ENTRY

function setup(){

    # Variables related to "copy_content_validations" function
    source_path="1";              # Holds source file / directory path for copying
    destination_path="2";         # Holds destination directory path for copying

    # Variables related to "type_of_content" function
    content="NULL";               # Holds content value (path) to be checked file, directory or something else
    content_type="NULL";          # Holds type of file


    # Variables related to "copy_content_validations" function (Data Integrity)
    filename_full=""
    filename=$(basename "$filename_full")
    extension="${filename##*.}"
    filename="${filename%.*}"

    # Variables related to "docker_load" and "docker_load_validations" function (docker load and validation)
    docker_image_path="1";
    docker_image_name="2";
    docker_image_grep_name="3";
    docker_image_loading_status="Not Idea";

    # Variables related to "docker_run" and "docker_run_validations" function (docker run and validation)
    docker_container_name="1";
    docker_container_running_status="Not Idea";

    # Variables related to "set_language" function (setting default language)
    state_code="1";
    language="Not Idea";

    setup_progress_status_filename="/home/core/setup_progress_status_value";

    source_base_path="/mnt/home/core/installation-content";

#************************ Major process realted functions starts from here ***************************#

    # Check whether "/" is mounted from inserted disk or not...
    CHECK_IF_ROOT_MOUNTED_FROM_USB_DISK "$BASH_SOURCE";


    # Step 1: copying initial files required for the setup of student CLIx platform
    GET_SETUP_PROGRESS "$setup_progress_status_filename";
    if [ "$setup_progress_status" == "0" ] || [ ! -f $setup_progress_status_filename ] || [ "$setup_progress_status" == "" ]; then
        CHECK_CORRECT_USB_DISK "$BASH_SOURCE";

        INFO "Setup progress status value: $setup_progress_status. Hence copying initial files required for the setup of student CLIx platform." "green" ;
        
        source_path="${source_base_path}/backup-old-server-data.sh";                                                         # backup-old-server-data.sh
        destination_path="/home/core/";
        INFO "Copy backup-old-server-data.sh script from $source_path to $destination_path" "$BASH_SOURCE" "green";
        RSYNC_CONTENT "$source_path" "$destination_path";

        source_path="${source_base_path}/install-to-disk.sh";                                                                # install-to-disk.sh
        destination_path="/home/core/";
        INFO "Copy install-to-disk.sh script from $source_path to $destination_path" "$BASH_SOURCE" "green";
        RSYNC_CONTENT "$source_path" "$destination_path";

        source_path="${source_base_path}/copy-softwares.sh";                                                                 # copy-softwares.sh
        destination_path="/home/core/";
        INFO "Copy copy-softwares.sh script from $source_path to $destination_path" "$BASH_SOURCE" "green";
        RSYNC_CONTENT "$source_path" "$destination_path";

        source_path="${source_base_path}/setup.sh";                                                                          # setup.sh
        destination_path="/home/core/";
        INFO "Copy setup.sh script from $source_path to $destination_path" "$BASH_SOURCE" "green";
        RSYNC_CONTENT "$source_path" "$destination_path";

        source_path="${source_base_path}/mrulogger.sh";                                                                      # mrulogger.sh
        destination_path="/home/core/";
        INFO "Copy mrulogger.sh script from $source_path to $destination_path" "$BASH_SOURCE" "green";
        RSYNC_CONTENT "$source_path" "$destination_path";

        source_path="${source_base_path}/Execute-single_school_get_MIT_activity_data.sh";                                    # Execute-single_school_get_MIT_activity_data.sh
        destination_path="/home/core/";
        INFO "Copy Execute-single_school_get_MIT_activity_data.sh script from $source_path to $destination_path" "$BASH_SOURCE" "green";
        RSYNC_CONTENT "$source_path" "$destination_path";

        source_path="${source_base_path}/mycron-host";                                                                       # mycron-host
        destination_path="/home/core/";
        INFO "Copy mycron-host cron config file from $source_path to $destination_path" "$BASH_SOURCE" "green";
        RSYNC_CONTENT "$source_path" "$destination_path";

        source_path="${source_base_path}/data";                                                                              # data
        destination_path="/home/core/";
        INFO "Copy data directory from $source_path to $destination_path" "$BASH_SOURCE" "green";
        RSYNC_CONTENT "$source_path" "$destination_path";

        source_path="${source_base_path}/code";                                                                              # code
        destination_path="/home/core/";                              
        INFO "Copy code directory from $source_path to $destination_path" "$BASH_SOURCE" "green";
        RSYNC_CONTENT "$source_path" "$destination_path";

        source_path="${source_base_path}/user-csvs";                                                                         # user-csvs
        destination_path="/home/core/";
        INFO "Copy user-csvs directory from $source_path to $destination_path" "$BASH_SOURCE" "green";
        RSYNC_CONTENT "$source_path" "$destination_path";

        source_path="${source_base_path}/display-pics";                                                                      # display-pics
        destination_path="/home/core/";
        INFO "Copy display-pics directory from $source_path to $destination_path" "$BASH_SOURCE" "green";
        RSYNC_CONTENT "$source_path" "$destination_path";

        source_path="${source_base_path}/setup-software/oac";                                                                # oac
        destination_path="/home/core/setup-software/";                              
        INFO "Copy oac and oat from $source_path to $destination_path" "$BASH_SOURCE" "green";
        RSYNC_CONTENT "$source_path" "$destination_path";

        # source_path="${source_base_path}/setup-software/oat";                                                                # oat
        # destination_path="/home/core/setup-software/";                              
        # INFO "Copy oac and oat from $source_path to $destination_path" "$BASH_SOURCE" "green";
        # RSYNC_CONTENT "$source_path" "$destination_path";

        source_path="${source_base_path}/docker-compose";                                                                    # dokcer-compose (docker-compose.yml for gstudio and syncthing)
        destination_path="/home/core/docker-compose";
        INFO "Copy user-csvs directory from $source_path to $destination_path" "$BASH_SOURCE" "green";
        RSYNC_CONTENT "$source_path" "$destination_path";

        source_path="${source_base_path}/setup-software/gstudio";                                                            # gstudio docker image
        destination_path="/home/core/setup-software/";                              
        INFO "Copy gstudio docker image from $source_path to $destination_path" "$BASH_SOURCE" "green";
        RSYNC_CONTENT "$source_path" "$destination_path";

        source_path="${source_base_path}/setup-software/syncthing";                                                          # syncthing docker image
        destination_path="/home/core/setup-software/";                              
        INFO "Copy syncthing docker image from $source_path to $destination_path" "$BASH_SOURCE" "green";
        RSYNC_CONTENT "$source_path" "$destination_path";

        UMOUNT_PARTITION "/dev/$selected_usb_disk" "/mnt/";

        SET_SETUP_PROGRESS "$setup_progress_status_filename" "1";
    else
        WARNING "Setup progress step value is ${setup_progress_status}, hence continuing with the process.\nSkipping the step 1 of copying initial files required for the setup of student CLIx platform."  "$BASH_SOURCE";
    fi


    # Step 2: loading docker image for the setup of student CLIx platform
    GET_SETUP_PROGRESS "$setup_progress_status_filename";
    if [ "$setup_progress_status" == "1" ]; then
        INFO "Setup progress status value: $setup_progress_status. Hence loading docker image for the setup of student CLIx platform." "green" ;

        # Set docker image realted variable
        docker_image_path="/home/core/setup-software/gstudio/registry.tiss.edu-school-server-dlkit-43-7b32cc4.tar";
        docker_image_name="registry.tiss.edu/school-server-dlkit:43-7b32cc4";
        docker_image_grep_name="43-7b32cc4";
        CHECK_FOR_ALREADY_LOADED_DOCKER_IMAGE;

        SET_SETUP_PROGRESS "$setup_progress_status_filename" "2";
    else
        WARNING "Setup progress step value is ${setup_progress_status}, hence continuing with the process.\nSkipping the step 2 of loading docker image for the setup of student CLIx platform."  "$BASH_SOURCE";
    fi


    # Step 3: starting the container for the setup of student CLIx platform
    GET_SETUP_PROGRESS "$setup_progress_status_filename";
    if [ "$setup_progress_status" == "2" ]; then
        INFO "Setup progress status value: $setup_progress_status. Hence starting the container for setup student CLIx platform." "green" ;

        # Set docker image realted variable
        docker_compose_filename="/home/core/docker-compose/gstudio/docker-compose.yml";
        docker_container_name="gstudio";
        CHECK_FOR_ALREADY_STARTED_DOCKER_CONTAINER;

        SET_SETUP_PROGRESS "$setup_progress_status_filename" "3";
    else
        WARNING "Setup progress step value is ${setup_progress_status}, hence continuing with the process.\nSkipping the step 3 of starting the container for setup student CLIx platform."  "$BASH_SOURCE";
    fi


    # Step 4: setting up / configuring the container for the setup of student CLIx platform
    GET_SETUP_PROGRESS "$setup_progress_status_filename";
    if [ "$setup_progress_status" == "3" ]; then
        INFO "Setup progress status value: $setup_progress_status. Hence setting up / configuring the container for the setup of student CLIx platform." "green" ;

        # Set docker image realted variable
        docker_compose_filename="/home/core/docker-compose/gstudio/docker-compose.yml";
        docker_container_name="gstudio";
        CHECK_FOR_ALREADY_STARTED_DOCKER_CONTAINER;
        docker-compose -f $docker_compose_filename up -d


        echo -e "\n${cyan}school server instance config - setting server name/id ${reset}"
        
        CHECK_FILE_EXISTENCE "/home/core/code/gstudio/gnowsys-ndf/gnowsys_ndf/server_settings.py" "create"

        # get server id (Remove single quote {'} and Remove double quote {"})
        ss_id=`echo  $(echo $(more /home/core/code/gstudio/gnowsys-ndf/gnowsys_ndf/server_settings.py | grep -w GSTUDIO_INSTITUTE_ID | sed 's/.*=//g')) | sed "s/'//g" | sed 's/"//g'`
        #ss_id=$(more /home/core/code/gstudio/gnowsys-ndf/gnowsys_ndf/server_settings.py | sed -n '/.*=/{p;q;}' | sed 's/.*= //g' | sed "s/'//g" | sed 's/"//g')

        # Trim leading  whitespaces 
        ss_id=$(echo ${ss_id##*( )})
        # Trim trailing  whitespaces 
        ss_id=$(echo ${ss_id%%*( )})

        # update server id
        if grep -Fq "GSTUDIO_INSTITUTE_ID" /home/core/code/gstudio/gnowsys-ndf/gnowsys_ndf/server_settings.py
        then
            # code if found
            sed -e "/GSTUDIO_INSTITUTE_ID/ s/=.*/='${ss_id}'/" -i  /home/core/code/gstudio/gnowsys-ndf/gnowsys_ndf/server_settings.py;
        else
            # code if not found
            echo -e "GSTUDIO_INSTITUTE_ID ='${ss_id}'" >>  /home/core/code/gstudio/gnowsys-ndf/gnowsys_ndf/server_settings.py;
        fi

        # update school code
        ss_code=$(grep -irw "$ss_id" /home/core/code/All_States_School_CLIx_Code_+_School_server_Code_-_TS_Intervention_Schools.csv | awk -F ';' '{print $3}')

        # Trim leading  whitespaces 
        ss_code=$(echo ${ss_code##*( )})
        # Trim trailing  whitespaces 
        ss_code=$(echo ${ss_code%%*( )})

        if grep -Fq "GSTUDIO_INSTITUTE_ID_SECONDARY" /home/core/code/gstudio/gnowsys-ndf/gnowsys_ndf/server_settings.py
        then
            # code if found
            sed -e "/GSTUDIO_INSTITUTE_ID_SECONDARY/ s/=.*/='${ss_code}'/" -i  /home/core/code/gstudio/gnowsys-ndf/gnowsys_ndf/server_settings.py;
        else
            # code if not found
            echo -e "GSTUDIO_INSTITUTE_ID_SECONDARY ='${ss_code}'" >>  /home/core/code/gstudio/gnowsys-ndf/gnowsys_ndf/server_settings.py;
        fi

        # update school name
        ss_name=$(grep -irw "$ss_id" /home/core/code/All_States_School_CLIx_Code_+_School_server_Code_-_TS_Intervention_Schools.csv | awk -F ';' '{print $2}' | sed 's/"//g')

        # Trim leading  whitespaces 
        ss_name=$(echo ${ss_name##*( )})
        # Trim trailing  whitespaces 
        ss_name=$(echo ${ss_name%%*( )})

        if grep -Fq "GSTUDIO_INSTITUTE_NAME" /home/core/code/gstudio/gnowsys-ndf/gnowsys_ndf/server_settings.py
        then
            # code if found
            sed -e "/GSTUDIO_INSTITUTE_NAME/ s/=.*/='${ss_name}'/" -i  /home/core/code/gstudio/gnowsys-ndf/gnowsys_ndf/server_settings.py;
        else
            # code if not found
            echo -e "GSTUDIO_INSTITUTE_NAME ='${ss_name}'" >>  /home/core/code/gstudio/gnowsys-ndf/gnowsys_ndf/server_settings.py;
        fi


        sleep 90      # Wait for apllication to start properly

        echo -e "\n${cyan}school server instance config - setting postgres database ${reset}"
        docker exec -it gstudio /bin/sh -c "echo 'psql -f /data/drop_database.sql;' | sudo su - postgres"
        docker exec -it gstudio /bin/sh -c "echo 'psql -f /data/pg_dump_all.sql;' | sudo su - postgres"

        echo -e "\n${cyan}school server instance config - copying oac, oat and AssetContent ${reset}"
        docker exec -it gstudio /bin/sh -c "rsync -avzPh /data/CLIx/datastore/AssetContent/* /home/docker/code/gstudio/gnowsys-ndf/qbank-lite/webapps/CLIx/datastore/repository/AssetContent/"

        echo -e "\n${cyan}restarting school server instance to apply the configuration ${reset}"
        docker restart gstudio

        sleep 60      # Wait for apllication to start properly

        echo -e "\n${cyan}school server instance config - copy display pics and user csvs ${reset}"  
        docker cp display-pics gstudio:/home/docker/code/
        docker cp user-csvs/${ss_id}_users.csv gstudio:/home/docker/code/user-csvs/

        echo -e "\n${cyan}school server instance config - create users and apply display pics ${reset}"
        docker exec -it gstudio /bin/sh -c "/usr/bin/python /home/docker/code/gstudio/gnowsys-ndf/manage.py sync_users /home/docker/code/user-csvs/${ss_id}_users.csv"

#        echo -e "\n${cyan}school server instance config - setting necessary permissions to media direcory and files ${reset}"
#        sudo chmod -R 755 /home/core/data/media/*

        echo -e "\n${cyan}school server instance config - create workspace with institute id ${reset}"
        docker exec -it gstudio /bin/sh -c "/bin/echo \"execfile('/home/docker/code/gstudio/doc/deployer/create_workspace_from_institute_id.py')\" |/usr/bin/python /home/docker/code/gstudio/gnowsys-ndf/manage.py shell"

        echo -e "\n${cyan}school server instance config - correct spelling mistakes in usernames id ${reset}"
        docker exec -it gstudio /bin/sh -c "/bin/echo \"execfile('/home/docker/code/gstudio/doc/deployer/release2-1_nov17.py')\" |/usr/bin/python /home/docker/code/gstudio/gnowsys-ndf/manage.py shell"

        echo -e "\n${cyan}school server instance config - set crontab (trigger script at start of system) ${reset}"
        crontab /home/core/mycron-host

        # copy ssl files 
        docker exec -it gstudio /bin/sh -c "/usr/bin/rsync -avPh /data/clixserver.tiss.edu /etc/ssl/"

        # restart cron
        # docker exec -it gstudio /bin/sh -c "/bin/kill -9 $(pidof cron) && /usr/sbin/cron "

        SET_SETUP_PROGRESS "$setup_progress_status_filename" "4";
    else
        WARNING "Setup progress step value is ${setup_progress_status}, hence continuing with the process.\nSkipping the step 4 of setting up / configuring the container for the setup of student CLIx platform."  "$BASH_SOURCE";
    fi


    # Step 5: loading docker image for the setup of syncthing
    GET_SETUP_PROGRESS "$setup_progress_status_filename";
    if [ "$setup_progress_status" == "4" ]; then
        INFO "Setup progress status value: $setup_progress_status. Hence loading docker image for the setup of syncthing." "green" ;

        # Set docker image realted variable
        docker_image_path="/home/core/setup-software/syncthing/linuxserver-syncthing.tar";
        docker_image_name="linuxserver/syncthing";
        docker_image_grep_name="linuxserver/syncthing";
        CHECK_FOR_ALREADY_LOADED_DOCKER_IMAGE;

        SET_SETUP_PROGRESS "$setup_progress_status_filename" "5";
    else
        WARNING "Setup progress step value is ${setup_progress_status}, hence continuing with the process.\nSkipping the step 5 of loading docker image for the setup of syncthing."  "$BASH_SOURCE";
    fi


    # Step 6: starting the container for the setup of syncthing
    GET_SETUP_PROGRESS "$setup_progress_status_filename";
    if [ "$setup_progress_status" == "5" ]; then
        INFO "Setup progress status value: $setup_progress_status. Hence starting the container for setup syncthing." "green" ;

        # Set docker image realted variable
        docker_compose_filename="/home/core/docker-compose/syncthing/docker-compose.yml";
        docker_container_name="syncthing";
        CHECK_FOR_ALREADY_STARTED_DOCKER_CONTAINER;

        SET_SETUP_PROGRESS "$setup_progress_status_filename" "6";
    else
        WARNING "Setup progress step value is ${setup_progress_status}, hence continuing with the process.\nSkipping the step 6 of starting the container for setup syncthing."  "$BASH_SOURCE";
    fi

}

#************************ Major process realted functions ends from here ***************************#

#**************************** Installation process starts from here ********************************#

# echo -e "\n${cyan}Please be ready with the School server id ${reset}" ;

if [ ! -f /home/core/school_server_id_value ]; then
    INFO "Please provide the School server id? (Example Mizoram school 23 will have mz23 and Telangana 24 school - tg24)" "$BASH_SOURCE" "yellow";
    GET_INPUTS "School server id: ";
    eval ss_id=$input;

    ss_id="${ss_id##*( )}";    ### Trim leading  whitespaces ###
    ss_id="${ss_id%%*( )}";    ### Trim trailing whitespaces ###
    echo "${ss_id}" > /home/core/school_server_id_value;

    state_code=${ss_id:0:2};
    SET_LANGUAGE $state_code;
elif [ -f /home/core/school_server_id_value ] || [ "$school_server_id" != "" ]; then
    INFO "School server id value is ${school_server_id}, hence continuing with the process." "$BASH_SOURCE" "green";
    ss_id=$(more /home/core/school_server_id_value);
    state_code=${ss_id:0:2};
    SET_LANGUAGE $state_code;
fi

# update host entry
if grep -Fq "clixserver   clixserver.tiss.edu" /etc/hosts
then
    # code if found
    INFO "host entry for 'clixserver   clixserver.tiss.edu' already exist in '/etc/host'." "$BASH_SOURCE" "green";    
else
    # code if not found
    WARNING "host entry for 'clixserver   clixserver.tiss.edu' doesn't exist in '/etc/host'. Hence trying to add" "$BASH_SOURCE";    
    rsync -avPh /etc/hosts /tmp/ ;
    sed -e '/^127.0.1.1/ s/$/   clixserver   clixserver.tiss.edu/' -i /tmp/hosts;
    sudo rsync -avzPh /tmp/hosts /etc/;
    sudo cat /tmp/hosts | sudo  tee /etc/hosts;
fi

# update  Huawei E353/E3131 support entry
if grep -Fq "# Huawei E353/E3131" /lib/udev/rules.d/40-usb_modeswitch.rules
then
    # code if found
    INFO "host entry for 'clixserver   clixserver.tiss.edu' already exist in '/lib/udev/rules.d/40-usb_modeswitch.rules'." "$BASH_SOURCE" "green";    
else
    # code if not found
    WARNING "Entry for 'Huawei E353/E3131' dongle support doesn't exist in '/lib/udev/rules.d/40-usb_modeswitch.rules'. Hence trying to add" "$BASH_SOURCE";    
    echo -e "# Huawei E353/E3131 \nATTR{idVendor}==\"12d1\", ATTR{idProduct}==\"1f01\", RUN +=\"usb_modeswitch '%b/%k'\"" | tee -a /lib/udev/rules.d/40-usb_modeswitch.rules;

    # rsync -avPh /lib/udev/rules.d/40-usb_modeswitch.rules /tmp/ ;
    # echo -e "# Huawei E353/E3131 \nATTR{idVendor}==\"12d1\", ATTR{idProduct}==\"1f01\", RUN +=\"usb_modeswitch '%b/%k'\"" | tee -a /tmp/40-usb_modeswitch.rules;
    # sudo rsync -avzPh /tmp/40-usb_modeswitch.rules /etc/;
    # sudo cat /tmp/40-usb_modeswitch.rules | sudo  tee /lib/udev/rules.d/40-usb_modeswitch.rules;
fi

# Ref: https://askubuntu.com/questions/172524/how-can-i-check-if-automatic-updates-are-enabled
# update disable unattended updates (package list) entry    
if grep -Fq "APT::Periodic::Update-Package-Lists" /etc/apt/apt.conf.d/10periodic
then
    # code if found
    INFO "Auto-updates (package list) entry already exist in '/etc/apt/apt.conf.d/10periodic'. Hence trying to update (set it to disable{value as '1'})" "$BASH_SOURCE" "green";
    sudo echo -e "APT::Periodic::Update-Package-Lists /"0/";" | sudo tee -a /etc/apt/apt.conf.d/10periodic;
else
    # code if not found
    WARNING "Auto-updates (package list) entry doesn't exist in '/etc/apt/apt.conf.d/10periodic'. Hence trying to add (set it to disable{value as '1'})" "$BASH_SOURCE";    
    sudo echo -e "APT::Periodic::Update-Package-Lists /"0/";" | sudo tee -a /etc/apt/apt.conf.d/10periodic;
fi

# update disable unattended updates (download upgradeable package) entry
if grep -Fq "APT::Periodic::Download-Upgradeable-Packages" /etc/apt/apt.conf.d/10periodic
then
    # code if found
    INFO "Auto-updates (download upgradeable package) entry already exist in '/etc/apt/apt.conf.d/10periodic'. Hence trying to update (set it to disable{value as '1'})" "$BASH_SOURCE" "green";
    sudo echo -e "APT::Periodic::Download-Upgradeable-Packages /"0/";" | sudo tee -a /etc/apt/apt.conf.d/10periodic;
else
    # code if not found
    WARNING "Auto-updates (download upgradeable package) entry doesn't exist in '/etc/apt/apt.conf.d/10periodic'. Hence trying to add (set it to disable{value as '1'})" "$BASH_SOURCE";    
    sudo echo -e "APT::Periodic::Download-Upgradeable-Packages /"0/";" | sudo tee -a /etc/apt/apt.conf.d/10periodic;
fi

# update disable unattended updates (upgrade packages) entry
if grep -Fq "APT::Periodic::Unattended-Upgrade" /etc/apt/apt.conf.d/10periodic
then
    # code if found
    INFO "Auto-updates (upgrade packages) entry already exist in '/etc/apt/apt.conf.d/10periodic'. Hence trying to update (set it to disable{value as '1'})" "$BASH_SOURCE" "green";
    sudo echo -e "APT::Periodic::Unattended-Upgrade /"0/";" | sudo tee -a /etc/apt/apt.conf.d/10periodic;
else
    # code if not found
    WARNING "Auto-updates (upgrade packages) entry doesn't exist in '/etc/apt/apt.conf.d/10periodic'. Hence trying to add (set it to disable{value as '1'})" "$BASH_SOURCE";    
    sudo echo -e "APT::Periodic::Unattended-Upgrade /"0/";" | sudo tee -a /etc/apt/apt.conf.d/10periodic;
fi


# update disable unattended updates (package list) entry
if grep -Fq "APT::Periodic::Update-Package-Lists" /etc/apt/apt.conf.d/20auto-upgrades
then
    # code if found
    INFO "Auto-updates (package list) entry already exist in '/etc/apt/apt.conf.d/20auto-upgrades'. Hence trying to update (set it to disable{value as '1'})" "$BASH_SOURCE" "green";
    sudo echo -e "APT::Periodic::Update-Package-Lists /"0/";" | sudo tee -a /etc/apt/apt.conf.d/20auto-upgrades;
else
    # code if not found
    WARNING "Auto-updates (package list) entry doesn't exist in '/etc/apt/apt.conf.d/20auto-upgrades'. Hence trying to add (set it to disable{value as '1'})" "$BASH_SOURCE";    
    sudo echo -e "APT::Periodic::Update-Package-Lists /"0/";" | sudo tee -a /etc/apt/apt.conf.d/20auto-upgrades;
fi

# update disable unattended updates (download upgradeable package) entry
if grep -Fq "APT::Periodic::Download-Upgradeable-Packages" /etc/apt/apt.conf.d/20auto-upgrades
then
    # code if found
    INFO "Auto-updates (download upgradeable package) entry already exist in '/etc/apt/apt.conf.d/20auto-upgrades'. Hence trying to update (set it to disable{value as '1'})" "$BASH_SOURCE" "green";
    sudo echo -e "APT::Periodic::Download-Upgradeable-Packages /"0/";" | sudo tee -a /etc/apt/apt.conf.d/20auto-upgrades;
else
    # code if not found
    WARNING "Auto-updates (download upgradeable package) entry doesn't exist in '/etc/apt/apt.conf.d/20auto-upgrades'. Hence trying to add (set it to disable{value as '1'})" "$BASH_SOURCE";    
    sudo echo -e "APT::Periodic::Download-Upgradeable-Packages /"0/";" | sudo tee -a /etc/apt/apt.conf.d/20auto-upgrades;
fi

# update disable unattended updates (upgrade packages) entry
if grep -Fq "APT::Periodic::Unattended-Upgrade" /etc/apt/apt.conf.d/20auto-upgrades
then
    # code if found
    INFO "Auto-updates (upgrade packages) entry already exist in '/etc/apt/apt.conf.d/20auto-upgrades'. Hence trying to update (set it to disable{value as '1'})" "$BASH_SOURCE" "green";
    sudo echo -e "APT::Periodic::Unattended-Upgrade /"0/";" | sudo tee -a /etc/apt/apt.conf.d/20auto-upgrades;
else
    # code if not found
    WARNING "Auto-updates (upgrade packages) entry doesn't exist in '/etc/apt/apt.conf.d/20auto-upgrades'. Hence trying to add (set it to disable{value as '1'})" "$BASH_SOURCE";    
    sudo echo -e "APT::Periodic::Unattended-Upgrade /"0/";" | sudo tee -a /etc/apt/apt.conf.d/20auto-upgrades;
fi

setup

INFO "Start docker at startup" "$BASH_SOURCE" "green";
sudo systemctl enable docker

#**************************** Installation process ends here ********************************#
SCRIPT_ENTRY

exit 0;