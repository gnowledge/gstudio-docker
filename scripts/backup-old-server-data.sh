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

function backup_completely() {
  content="NULL";               # Holds content value (path) to be checked file, directory or something else

  # Variables related to "copy_content_validations" function
  source_path="1";              # Holds source file / directory path for copying
  destination_path="2";         # Holds destination directory path for copying
  flag="3";                     # Holds destination directory path for copying

  # Variables related to "type_of_content" function
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

  #******************************** Basic functions starts from here ***********************************#

  function response()
  {
    if [ $? = 0 ]; then
      response_status="Working";
  #    echo "Working (Code=$?)"           # For testing uncomment here
    else
      response_status="Not_Working";
  #    echo "Not_Working (Code=$?)"       # For testing uncomment here
    fi
  }

  function check_disk_insertion()
  {

    for (( i=1; i<5; i++ )); 
    do

          check_disk=`lsblk | grep sdb9 | wc -l`

          if [[ "$check_disk" != "1" ]]; then
                sleep 5;
                echo -e "\nWaiting for the installer (pen drive / portable HDD).";
          elif [[ "$check_disk" == "1" ]]; then
                #echo -e "\nPen drive found. Continuing installation.";
                disk_status="Found";
                break
          fi

          if [[ $i == 4 ]]; then
                echo -e "\nInstaller (pen drive / portable HDD) not found. Retry installation.";
                disk_status="Not_found";
                exit;       # For testing comment here
          fi

    done

  }

  function mounting_disk()
  {
    echo -e "\n${cyan}Name the destination disk for taking backup (portable HDD)? ${reset}" ;
    echo -e "${brown}(For example 'sdb' or 'sdc') ${reset}" ;
    echo -e "${brown}{if you are not sure and want to exit simply type enter} ${reset}" ;
    echo -e "${brown}{should be other than 'sda'} ${reset}" ;
    check_disk_h=`lsblk | grep SIZE`
    check_disk_d=`lsblk | grep disk`
    echo -e "\n${purple}$check_disk_h ${reset}" ;
    echo -e "${blue}$check_disk_d ${reset}\n" ;
    echo -e -n "${cyan}disk name : ${reset}" ;

    read disk_t ;
    disk_t_ck=`lsblk | grep $disk_t`

    if [[ "$disk_t" == "" ]]; then

      echo -e "\n${brown}No input. Hence exiting. Please try again later. ${reset}" ;
      mounting_status="Unmounted";
      exit

    elif [[ "$disk_t_ck" == "" ]]; then

      echo -e "\n${brown}Invalid input. Hence exiting. Please try again later. ${reset}" ;
      mounting_status="Unmounted";
      exit

    elif [[ "$disk_t_ck" != "" ]]; then

    
      echo -e "${cyan}mounting /dev/${disk_t} in /mnt ${reset}"
      sudo mount /dev/${disk_t}9 /mnt/

      mounting_status="Mounted";
    
    fi

  }


  function unmounting_disk()
  {

      echo -e "\n${cyan}umount /mnt${reset}"
      sudo umount /mnt/

      unmounting_status="Unmounted";

  }

  # This function will check the type of content (file, directory or No idea)
  function type_of_content()
  {
    # Type of content
    #  D=Directory
    #  F=File
    #  N=No idea
    content="$1";
    if [[ -d $content ]]; then
      echo "$content is a directory"
      content_type="D";
    elif [[ -f $content ]]; then
      echo "$content is a file"
      content_type="F";
    else
      echo "$content is not valid"
      content_type="N";
      exit 1
    fi
  }

  function file_existence_validation()
  {
    filename="$1";
    if [[ -f $filename ]]; then
      file_existence_status="Present";
    elif [[ ! -f $filename ]]; then
      echo -e "\n${cyan}File ($filename) doesn't exists. ${reset}"
      file_existence_status="Not_Present";
    else
      echo -e "\n${red}Error: Oops something went wrong. Contact system administator or CLIx technical team - Mumbai. ($filename)${reset}" ;
    fi  
  }

  function directory_existence_validation()
  {
    directoryname="$1";
    if [[ -d $directoryname ]]; then
      echo -e "\n${cyan}Directory ($directoryname) exists. ${reset}"
      directory_existence_status="Present";
    elif [[ ! -d $directoryname ]]; then
      echo -e "\n${cyan}Directory ($directoryname) doesn't exists. ${reset}"
      directory_existence_status="Not_Present";
      if [[ "$2" == "Create" ]]; then
        mkdir -p $directoryname;
        if [ "$?" == "0" ]; then
          echo -e "\n${cyan}Directory ($directoryname) doesn't exists. Got signal to create the same. Hence created successfully.${reset}"
          directory_existence_status="Present";
        else
          echo -e "\n${cyan}Directory ($directoryname) doesn't exists. Got signal to create the same. Unfortunately failed to create.${reset}"
        fi
      fi
    else
      echo -e "\n${red}Error: Oops something went wrong. Contact system administator or CLIx technical team - Mumbai. ($directoryname)${reset}" ;
    fi  
  }

  # This function will validate, copy the content increamentally from source to destination. (Can take care partial copy)
  #   + Directory existence 
  #   + Data integrity
  #   + In case of partial copy rsync will handle it
  function copy_content()
  {

    directory_existence_validation "$destination_path" "Create"
    if [ "$directory_existence_status" == "Present" ]; then
      if [[ "$3" == "max-size" ]]; then
        #Ref: https://serverfault.com/questions/105206/rsync-exclude-files-that-are-over-a-certain-size
        #flag --max-size=30m
        echo -e "\n${cyan}Destination directory exists. Hence proceeding to copy the content. ${reset}" ;
        echo -e "\n${cyan}copy clix-platform data and necessary files from $source_path to $destination_path. \nThis may take time, please be patient. (Approx 15-30 min depending on the system performance) ${reset}"
        sudo rsync -avzPh --max-size=30m "${source_path}" "${destination_path}"      # For testing comment here
      else
        echo -e "\n${cyan}Destination directory exists. Hence proceeding to copy the content. ${reset}" ;
        echo -e "\n${cyan}copy clix-platform data and necessary files from $source_path to $destination_path. \nThis may take time, please be patient. (Approx 15-30 min depending on the system performance) ${reset}"
        sudo rsync -avzPh "${source_path}" "${destination_path}"      # For testing comment here
      fi
    elif  [ "$directory_existence_status" == "Not_Present" ]; then
      echo -e "\n${cyan}Destination directory doesn' t exists. Hence skipping the process of copying the content and continuing with the process. ${reset}" ;
    else
      echo -e "\n${cyan}Oops something went wrong. Contact system administator or CLIx technical team - Mumbai. ${reset}" ;
    fi

  }

  function docker_load_validation()
  {
    #echo "docker_image_name:$docker_image_name"       # For testing uncomment here
    docker images | grep $docker_image_grep_name  >> /dev/null  
    response
  }

  function docker_load()
  {
    echo -e "\n${cyan}loading $1 docker image ${reset}"
    echo -e "${brown}caution : it may take long time ${reset}"
    docker load < $docker_image_path      # For testing comment here
  }

  function docker_run_validation()
  {
    docker ps -a | grep $docker_container_name # >> /dev/null
    response
  }

  function docker_run()
  {
    echo -e "\n${cyan}running $1 docker container ${reset}"
    echo -e "${brown}caution : it may take long time ${reset}"
    docker run $docker_flag $docker_volumes $docker_ports --name="$docker_container_name" $docker_image_name      # For testing comment here
  }


  #******************************** Basic functions ends from here ***********************************#



  #**************************** Installation process starts from here ********************************#

  # 
  # echo -e "\n${cyan}Please be ready with the following details: ${reset}" ;
  # echo -e "\n${cyan}\t School server id ${reset}" ;

  echo -e "\n${cyan}Please (re)insert the (CLIx School Server) installer (pen drive / portable HDD).${reset}"

  #sleep 5

  check_disk_insertion
  echo -e "\n${cyan}Disk status : $disk_status ${reset}";

  # echo -e "\n${cyan}Please provide the School server id? (Example Mizoram school 23 will have mz23 and Telangana 24 school - tg24) ${reset}" ;
  # echo -e -n "School server id: "
  # read ss_id

  # get current year
  cur_year=`date +"%Y"`

  # platform name
  platform="gstudio"

  # get server id (Remove single quote {'} and Remove double quote {"})
  ss_id=`docker exec -it gstudio bash -c "more /home/docker/code/gstudio/gnowsys-ndf/gnowsys_ndf/server_settings.py | grep -w GSTUDIO_INSTITUTE_ID | sed 's/.*=//g' | sed \"s/'//g\" | sed 's/\"//g'"`
  ss_id=`tr -dc '[[:print:]]' <<< "$ss_id"`

  # get state code
  state_code=${ss_id:0:2};

  # get server code (Remove single quote {'} and Remove double quote {"})
  ss_code=`docker exec -it gstudio bash -c "more /home/docker/code/gstudio/gnowsys-ndf/gnowsys_ndf/server_settings.py | grep -w GSTUDIO_INSTITUTE_ID_SECONDARY | sed 's/.*=//g' | sed \"s/'//g\" | sed 's/\"//g'"`
  ss_code=`tr -dc '[[:print:]]' <<< "$ss_code"`

  # get server name (Remove single quote {'} and Remove double quote {"})
  #ss_name=`docker exec -it gstudio bash -c "more /home/docker/code/gstudio/gnowsys-ndf/gnowsys_ndf/server_settings.py | grep -w GSTUDIO_INSTITUTE_NAME | sed 's/.*=//g' | sed \"s/'//g\" | sed 's/\"//g'"`
  ss_name=`tr -dc '[[:print:]]' <<< "$ss_name"`

  # For testing purpose
  # ls -ltrh /mnt/test
  # mounting_disk
  # echo -e "\n${cyan}Mounting status : $mounting_status ${reset}";
  # unmounting_disk
  # echo -e "\n${cyan}Unmounting status : $unmounting_status ${reset}";


  # backup up of old school server clix-platform data 
  echo -e -n "\n${cyan}Do you want to backup old school server clix-platform data? [Y/N]: ${reset}" ;
  read backup_old_clix_platform_status

  if [ "$backup_old_clix_platform_status" == "Y" ] || [ "$backup_old_clix_platform_status" == "y" ] || [ "$backup_old_clix_platform_status" == "Yes" ] || [ "$backup_old_clix_platform_status" == "yes" ] || [ "$backup_old_clix_platform_status" == "" ]; then
    echo -e "\n${cyan}Option selected / entered: $backup_old_clix_platform_status. Hence initiating the backup up of old school server clix-platform data. ${reset}" ;
    
    # Mrunal : Handling mounting in case of unplanned poweroff (Power failure). Unmount the mounting point
    unmounting_disk
    echo -e "\n${cyan}Unmounting status : $unmounting_status ${reset}";

    mounting_disk
    echo -e "\n${cyan}Mounting status : $mounting_status ${reset}";
    
    # source_path="/home/core/data/benchmark-dump";
    # destination_path="/mnt/home/core/${cur_year}/${state_code}/${ss_code}-${ss_id}/${platform}/";
    # echo -e "\n${cyan}copy clix-platform data and necessary files except media directory from $source_path to $destination_path ${reset}"
    # copy_content "$source_path" "$destination_path"

    # source_path="/home/core/data/counters-dump";
    # destination_path="/mnt/home/core/${cur_year}/${state_code}/${ss_code}-${ss_id}/${platform}/";
    # echo -e "\n${cyan}copy clix-platform data and necessary files except media directory from $source_path to $destination_path ${reset}"
    # copy_content "$source_path" "$destination_path"

    if [[ ! -d /mnt/home/core/${cur_year}/${state_code}/${ss_code}-${ss_id}/${platform}/ ]]; then
        mkdir -p /mnt/home/core/${cur_year}/${state_code}/${ss_code}-${ss_id}/${platform}/
    fi

    source_path="/home/core/data/db";
    destination_path="/mnt/home/core/${cur_year}/${state_code}/${ss_code}-${ss_id}/${platform}/";
    echo -e "\n${cyan}copy clix-platform db from $source_path to $destination_path ${reset}"
    copy_content "$source_path" "$destination_path"

    source_path="/home/core/data/gstudio-exported-users-analytics-csvs";
    destination_path="/mnt/home/core/${cur_year}/${state_code}/${ss_code}-${ss_id}/${platform}/";
    echo -e "\n${cyan}copy clix-platform gstudio-exported-users-analytics-csvs from $source_path to $destination_path ${reset}"
    copy_content "$source_path" "$destination_path"

    source_path="/home/core/data/gstudio-logs";
    destination_path="/mnt/home/core/${cur_year}/${state_code}/${ss_code}-${ss_id}/${platform}/";
    echo -e "\n${cyan}copy clix-platform gstudio-logs from $source_path to $destination_path ${reset}"
    copy_content "$source_path" "$destination_path"

    source_path="/home/core/data/postgres-dump";
    destination_path="/mnt/home/core/${cur_year}/${state_code}/${ss_code}-${ss_id}/${platform}/";
    echo -e "\n${cyan}copy clix-platform postgres-dump from $source_path to $destination_path ${reset}"
    copy_content "$source_path" "$destination_path"

    source_path="/home/core/data/rcs-repo";
    destination_path="/mnt/home/core/${cur_year}/${state_code}/${ss_code}-${ss_id}/${platform}/";
    echo -e "\n${cyan}copy clix-platform rcs-repo from $source_path to $destination_path ${reset}"
    copy_content "$source_path" "$destination_path"

    source_path="/home/core/data/local_settings.py";
    destination_path="/mnt/home/core/${cur_year}/${state_code}/${ss_code}-${ss_id}/${platform}/";
    echo -e "\n${cyan}copy clix-platform local_settings.py from $source_path to $destination_path ${reset}"
    copy_content "$source_path" "$destination_path"

    source_path="/home/core/data/server_settings.py";
    destination_path="/mnt/home/core/${cur_year}/${state_code}/${ss_code}-${ss_id}/${platform}/";
    echo -e "\n${cyan}copy clix-platform server_settings.py from $source_path to $destination_path ${reset}"
    copy_content "$source_path" "$destination_path"

    source_path="/home/core/data/system-heartbeat";
    destination_path="/mnt/home/core/${cur_year}/${state_code}/${ss_code}-${ss_id}/${platform}/";
    echo -e "\n${cyan}copy clix-platform system-heartbeat from $source_path to $destination_path ${reset}"
    copy_content "$source_path" "$destination_path"

    source_path="/home/core/data/git-commit-details.log";
    destination_path="/mnt/home/core/${cur_year}/${state_code}/${ss_code}-${ss_id}/${platform}/";
    echo -e "\n${cyan}copy clix-platform git-commit-details from $source_path to $destination_path ${reset}"
    copy_content "$source_path" "$destination_path"

    source_path="/home/core/data/assessment-media";
    destination_path="/mnt/home/core/${cur_year}/${state_code}/${ss_code}-${ss_id}/${platform}/";
    echo -e "\n${cyan}copy clix-platform data and necessary files except media directory from $source_path to $destination_path ${reset}"
    copy_content "$source_path" "$destination_path"

    source_path="/home/core/data/media";
    destination_path="/mnt/home/core/${cur_year}/${state_code}/${ss_code}-${ss_id}/${platform}/";
    echo -e "\n${cyan}copy clix-platform media directory of data from $source_path to $destination_path ${reset}"
    copy_content "$source_path" "$destination_path" "max-size" 

    echo -e "\n${cyan}Size of directories: ${reset}"
    # sudo du -hs /home/core/data/benchmark-dump /mnt/home/core/${cur_year}/${state_code}/${ss_code}-${ss_id}/${platform}/benchmark-dump
    # sudo du -hs /home/core/data/counters-dump /mnt/home/core/${cur_year}/${state_code}/${ss_code}-${ss_id}/${platform}/counters-dump
    sudo du -hs /home/core/data/db /mnt/home/core/${cur_year}/${state_code}/${ss_code}-${ss_id}/${platform}/db
    sudo du -hs /home/core/data/gstudio-exported-users-analytics-csvs /mnt/home/core/${cur_year}/${state_code}/${ss_code}-${ss_id}/${platform}/gstudio-exported-users-analytics-csvs
    sudo du -hs /home/core/data/gstudio-logs /mnt/home/core/${cur_year}/${state_code}/${ss_code}-${ss_id}/${platform}/gstudio-logs
    sudo du -hs /home/core/data/postgres-dump /mnt/home/core/${cur_year}/${state_code}/${ss_code}-${ss_id}/${platform}/postgres-dump
    sudo du -hs /home/core/data/rcs-repo /mnt/home/core/${cur_year}/${state_code}/${ss_code}-${ss_id}/${platform}/rcs-repo
    sudo du -hs /home/core/data/local_settings.py /mnt/home/core/${cur_year}/${state_code}/${ss_code}-${ss_id}/${platform}/local_settings.py
    sudo du -hs /home/core/data/server_settings.py /mnt/home/core/${cur_year}/${state_code}/${ss_code}-${ss_id}/${platform}/server_settings.py
    sudo du -hs /home/core/data/system-heartbeat /mnt/home/core/${cur_year}/${state_code}/${ss_code}-${ss_id}/${platform}/system-heartbeat
    sudo du -hs /home/core/data/git-commit-details.log /mnt/home/core/${cur_year}/${state_code}/${ss_code}-${ss_id}/${platform}/git-commit-details.log
    sudo du -hs /home/core/data/assessment-media /mnt/home/core/${cur_year}/${state_code}/${ss_code}-${ss_id}/${platform}/assessment-media
    sudo du -hs /home/core/data/media /mnt/home/core/${cur_year}/${state_code}/${ss_code}-${ss_id}/${platform}/media

    sudo du -hc $(find /home/core/data/media -type f -size +30M)
    echo -e "\n${cyan}Size of directories: ${reset}"
    sudo du -chs /home/core/data/* /mnt/home/core/${cur_year}/${state_code}/${ss_code}-${ss_id}/${platform}/*

    unmounting_disk
    echo -e "\n${cyan}Unmounting status : $unmounting_status ${reset}";

  elif  [ "$backup_old_clix_platform_status" == "N" ] || [ "$backup_old_clix_platform_status" == "n" ] || [ "$backup_old_clix_platform_status" == "No" ] || [ "$backup_old_clix_platform_status" == "no" ]; then
    echo -e "\n${cyan}Option selected / entered: $backup_old_clix_platform_status. Hence skipping backup up of old school server clix-platform data and continuing with the process. ${reset}" ;
  else
    echo -e "\n${cyan}Oops something went wrong. Contact system administator or CLIx technical team - Mumbai. ${reset}" ;
  fi
}
backup_completely |   tee /mnt/backup_completely.log;
exit
