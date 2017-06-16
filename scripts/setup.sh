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
              #echo -e "\nInstaller (pen drive / portable HDD) found. Continuing installation.";
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
  echo -e "\n${cyan}Name the disk for source of installation media? ${reset}" ;
  echo -e "${brown}(For example 'sda' or 'sdb' or 'sdc') ${reset}" ;
  echo -e "${brown}{if you are not sure and want to exit simply type enter} ${reset}" ;
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
    echo -e "\n${cyan}Destination directory exists. Hence proceeding to copy the content. ${reset}" ;
    echo -e "\n${cyan}copy clix-server data and necessary files from $source_path to $destination_path. \nThis may take time, please be patient. (Approx 15-30 min depending on the system performance) ${reset}"
    sudo rsync -avzPh "$1" "$source_path" "$destination_path"      # For testing comment here
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


#************************ Major process realted functions starts from here ***************************#


function setup-clix-server()
{
  
  # Setup CLIx server (Copy clix image)
  echo -e -n "\n${cyan}Do you want to setup school server clix-server (Copy clix image) ? [Y/N]: ${reset}" ;
  read setup_clix_server_copy_content_server_image_status

  if [ "$setup_clix_server_copy_content_server_image_status" == "Y" ] || [ "$setup_clix_server_copy_content_server_image_status" == "y" ] || [ "$setup_clix_server_copy_content_server_image_status" == "Yes" ] || [ "$setup_clix_server_copy_content_server_image_status" == "yes" ] || [ "$setup_clix_server_copy_content_server_image_status" == "" ]; then
    # Mrunal : Handling mounting in case of unplanned poweroff (Power failure). Unmount the mounting point
    unmounting_disk
    echo -e "\n${cyan}Unmounting status : $unmounting_status ${reset}";

    mounting_disk
    echo -e "\n${cyan}Mounting status : $mounting_status ${reset}";
   
    echo -e "\n${cyan}Option selected / entered: $setup_clix_server_copy_content_server_image_status. Hence setting the clix-server (Copy clix image). ${reset}" ;
  
    source_path="/mnt/home/core/setup-software/gstudio";
    destination_path="/home/core/setup-software/";
    echo -e "\n${cyan}copy clix-server docker image from $source_path to $destination_path ${reset}"
    copy_content "$source_path" "$destination_path"  

    unmounting_disk
    echo -e "\n${cyan}Unmounting status : $unmounting_status ${reset}";

  elif  [ "$setup_clix_server_copy_content_server_image_status" == "N" ] || [ "$setup_clix_server_copy_content_server_image_status" == "n" ] || [ "$setup_clix_server_copy_content_server_image_status" == "No" ] || [ "$setup_clix_server_copy_content_server_image_status" == "no" ]; then
    echo -e "\n${cyan}Option selected / entered: $setup_clix_server_copy_content_server_image_status. Hence skipping the clix-server setup (Copy clix image) and continuing with the process. ${reset}" ;
  else
    echo -e "\n${cyan}Oops something went wrong. Contact system administator or CLIx technical team - Mumbai. ${reset}" ;
  fi
  
  # Setup CLIx server (Copy data and server related scripts)
  echo -e -n "\n${cyan}Do you want to setup school server clix-server (Copy data and server related scripts) ? [Y/N]: ${reset}" ;
  read setup_clix_server_copy_content_data_status

  if [ "$setup_clix_server_copy_content_data_status" == "Y" ] || [ "$setup_clix_server_copy_content_data_status" == "y" ] || [ "$setup_clix_server_copy_content_data_status" == "Yes" ] || [ "$setup_clix_server_copy_content_data_status" == "yes" ] || [ "$setup_clix_server_copy_content_data_status" == "" ]; then
    # Mrunal : Handling mounting in case of unplanned poweroff (Power failure). Unmount the mounting point
    unmounting_disk
    echo -e "\n${cyan}Unmounting status : $unmounting_status ${reset}";

    mounting_disk
    echo -e "\n${cyan}Mounting status : $mounting_status ${reset}";
   
    echo -e "\n${cyan}Option selected / entered: $setup_clix_server_copy_content_data_status. Hence setting the clix-server (Copy data and server related scripts). ${reset}" ;
  
    source_path="/mnt/home/core/backup-old-server-data.sh";
    destination_path="/home/core/";
    echo -e "\n${cyan}copy clix-server data and necessary files from $source_path to $destination_path ${reset}"
    copy_content "$source_path" "$destination_path"  

    source_path="/mnt/home/core/install-to-disk.sh";
    destination_path="/home/core/";
    echo -e "\n${cyan}copy clix-server data and necessary files from $source_path to $destination_path ${reset}"
    copy_content "$source_path" "$destination_path"  

    source_path="/mnt/home/core/user-csvs";
    destination_path="/home/core/";
    echo -e "\n${cyan}copy clix-server data and necessary files from $source_path to $destination_path ${reset}"
    copy_content "$source_path" "$destination_path"  

    source_path="/mnt/home/core/display-pics";    
    destination_path="/home/core/";
    echo -e "\n${cyan}copy clix-server data and necessary files from $source_path to $destination_path ${reset}"
    copy_content "$source_path" "$destination_path"  

    source_path="/mnt/home/core/data";    
    destination_path="/home/core/";
    echo -e "\n${cyan}copy clix-server data and necessary files from $source_path to $destination_path ${reset}"
    copy_content "$source_path" "$destination_path"  

    unmounting_disk
    echo -e "\n${cyan}Unmounting status : $unmounting_status ${reset}";

  elif  [ "$setup_clix_server_copy_content_data_status" == "N" ] || [ "$setup_clix_server_copy_content_data_status" == "n" ] || [ "$setup_clix_server_copy_content_data_status" == "No" ] || [ "$setup_clix_server_copy_content_data_status" == "no" ]; then
    echo -e "\n${cyan}Option selected / entered: $setup_clix_server_copy_content_data_status. Hence skipping the clix-server setup (Copy data and server related scripts) and continuing with the process. ${reset}" ;
  else
    echo -e "\n${cyan}Oops something went wrong. Contact system administator or CLIx technical team - Mumbai. ${reset}" ;
  fi

  # Setup CLIx server (load server image)
  echo -e -n "\n${cyan}Do you want to setup school server clix-server (load server image) ? [Y/N]: ${reset}" ;
  read setup_clix_server_load_server_image_status

  if [ "$setup_clix_server_load_server_image_status" == "Y" ] || [ "$setup_clix_server_load_server_image_status" == "y" ] || [ "$setup_clix_server_load_server_image_status" == "Yes" ] || [ "$setup_clix_server_load_server_image_status" == "yes" ] || [ "$setup_clix_server_load_server_image_status" == "" ]; then
    echo -e "\n${cyan}Option selected / entered: $setup_clix_server_load_server_image_status. Hence setting the clix-server (load server image). ${reset}" ;

    # clix-server docker image loading process (along with validation)
    docker_image_path="/home/core/setup-software/gstudio/registry.tiss.edu-school-server-dlkit-29-df10fd6.tar";
    docker_image_name="registry.tiss.edu/school-server-dlkit:29-df10fd6";
    docker_image_grep_name="school-server-dlkit";
    docker_load_validation 
    docker_image_loading_status="Not Loaded";

    if [ "$response_status" == "Working" ]; then
      echo -e "\n${cyan}Docker image ($docker_image_name) already exists. ${reset}" ;
      docker_image_loading_status="Loaded";
    elif [ "$response_status" == "Not_Working" ]; then

      echo -e "\n${cyan}Docker image ($docker_image_name) doesn't exists. Hence we are loading the docker image ${reset}" ;
      docker_image_loading_status="Not Loaded";
      file_existence_validation $docker_image_path
      if [ "$file_existence_status" == "Present" ]; then
        echo -e "\n${cyan}File ($filename) exists. ${reset}"
        docker_load 
        docker_load_validation 

        if [ "$response_status" == "Working" ]; then
          echo -e "\n${cyan}Docker image ($docker_image_name) successfully loaded. ${reset}" ;
          docker_image_loading_status="Loaded";
        elif [ "$response_status" == "Not_Working" ]; then
          echo -e "\n${cyan}Docker image ($docker_image_name) failed to load. ${reset}" ;
          docker_image_loading_status="Not Loaded";
        else
          echo -e "\n${red}Error: Oops something went wrong. Contact system administator or CLIx technical team - Mumbai. ${reset}" ;
          docker_image_loading_status="Not Loaded";
        fi

      elif [ "$file_existence_status" == "Not_Present" ]; then
        echo -e "\n${red}Error: File ($filename) doesn't exists. Hence clix-server image ($docker_image_name) will not be able to load.${reset}"
        docker_image_loading_status="Not Loaded";
        exit
      else
        echo -e "\n${red}Error: Oops something went wrong. Contact system administator or CLIx technical team - Mumbai. ${reset}" ;
        docker_image_loading_status="Not Loaded";
      fi

    else
      echo -e "\n${red}Error: Oops something went wrong. Contact system administator or CLIx technical team - Mumbai. ${reset}" ;
      docker_image_loading_status="Not Loaded";
    fi

  elif  [ "$setup_clix_server_load_server_image_status" == "N" ] || [ "$setup_clix_server_load_server_image_status" == "n" ] || [ "$setup_clix_server_load_server_image_status" == "No" ] || [ "$setup_clix_server_load_server_image_status" == "no" ]; then
    echo -e "\n${cyan}Option selected / entered: $setup_clix_server_load_server_image_status. Hence skipping the clix-server setup (load server image) and continuing with the process. ${reset}" ;
  else
    echo -e "\n${cyan}Oops something went wrong. Contact system administator or CLIx technical team - Mumbai. ${reset}" ;
  fi


  # Setup CLIx server (run server container)
  echo -e -n "\n${cyan}Do you want to setup school server clix-server (run server docker container and setup)? [Y/N]: ${reset}" ;
  read setup_clix_server_run_server_container_status

  if [ "$setup_clix_server_run_server_container_status" == "Y" ] || [ "$setup_clix_server_run_server_container_status" == "y" ] || [ "$setup_clix_server_run_server_container_status" == "Yes" ] || [ "$setup_clix_server_run_server_container_status" == "yes" ] || [ "$setup_clix_server_run_server_container_status" == "" ]; then
    echo -e "\n${cyan}Option selected / entered: $setup_clix_server_run_server_container_status. Hence setting the clix-server (run server container). ${reset}" ;

    if [ "$docker_image_loading_status" == "Loaded" ]; then
      echo -e "\n${cyan}Docker image already exists. ${reset}" ;

      # clix-server docker contianer running process (along with validation)
      docker_image_path="/home/core/setup-software/gstudio/registry.tiss.edu-school-server-dlkit-29-df10fd6.tar";
      docker_image_name="registry.tiss.edu/school-server-dlkit:29-df10fd6";
      docker_container_name="gstudio";
      docker_flag=" -itd -h $ss_id --restart=always ";
      docker_volumes="-v /home/core/data:/data -v /home/core/backups:/backups -v /home/core/setup-software:/softwares ";
      docker_ports="-p 8022:22 -p 8025:25 -p 80:80 -p 443:443 -p 8000:8000 -p 8017:27017 -p 8143:143 -p 8587:587 -p 8080:8080 -p 5555:5555";
      docker_run_validation 
      docker_container_running_status="Not Loaded";
      
      if [ "$response_status" == "Working" ]; then
        echo -e "\n${cyan}Docker image ($docker_image_name) already exists. ${reset}" ;
        docker_container_running_status="Loaded";
      elif [ "$response_status" == "Not_Working" ]; then

        echo -e "\n${cyan}Docker image ($docker_image_name) doesn't exists. Hence we are running the docker container ${reset}" ;
        docker_container_running_status="Not Loaded";
        file_existence_validation $docker_image_path
        if [ "$file_existence_status" == "Present" ]; then
          echo -e "\n${cyan}File ($filename) exists. ${reset}"
          docker_run
          docker_run_validation 

          if [ "$response_status" == "Working" ]; then
            echo -e "\n${cyan}Docker image ($docker_container_name) successfully loaded / running. ${reset}" ;
            docker_container_running_status="Loaded";
          elif [ "$response_status" == "Not_Working" ]; then
            echo -e "\n${cyan}Docker image ($docker_container_name) failed to load / run. ${reset}" ;
            docker_container_running_status="Not Loaded";
          else
            echo -e "\n${red}Error: Oops something went wrong. Contact system administator or CLIx technical team - Mumbai. ${reset}" ;
            docker_container_running_status="Not Loaded";
          fi

        elif [ "$file_existence_status" == "Not_Present" ]; then
          echo -e "\n${red}Error: File ($filename) doesn't exists. Hence clix-server image ($docker_container_name) will not be able to load / run.${reset}"
          docker_container_running_status="Not Loaded";
        else
          echo -e "\n${red}Error: Oops something went wrong. Contact system administator or CLIx technical team - Mumbai. ${reset}" ;
          docker_container_running_status="Not Loaded";
          exit
        fi
      fi

      if [ "$docker_container_running_status" == "Loaded" ]; then

        #docker run $docker_flag $docker_volumes $docker_ports --name="$docker_container_name" $docker_image_name
        #echo -e "\n${cyan}creating school server instance (docker container) ${reset}"
        #docker run -itd -h $ss_id --restart=always -v /home/core/data:/data -v /home/core/backups:/backups -v /home/core/setup-software:/softwares -p 8022:22 -p 8025:25 -p 80:80 -p 443:443 -p 8000:8000 -p 8017:27017 -p 8143:143 -p 8587:587 --name=gstudio  school-server-master:v1-20160626-080144

        
        echo -e "\n${cyan}school server instance config - setting server name/id ${reset}"
        docker exec -it gstudio /bin/sh -c "/bin/echo GSTUDIO_INSTITUTE_ID = \'${ss_id}\' > /home/docker/code/gstudio/gnowsys-ndf/gnowsys_ndf/server_settings.py"
        #sed_cmd="/GSTUDIO_INSTITUTE_ID/ s/=.*/='${ss_id}'/"
        #docker exec -it gstudio /bin/sh -c "sed -e '${sed_cmd}' -i /home/docker/code/gstudio/gnowsys-ndf/gnowsys_ndf/server_settings.py;"

        sleep 90      # Wait for apllication to start properly

        echo -e "\n${cyan}school server instance config - setting postgres database ${reset}"
        docker exec -it gstudio /bin/sh -c "echo 'psql -f /data/drop_database.sql;' | sudo su - postgres"
        docker exec -it gstudio /bin/sh -c "echo 'psql -f /data/pg_dump_all.sql;' | sudo su - postgres"

        echo -e "\n${cyan}school server instance config - copying oac, oat and AssetContent ${reset}"
        docker exec -it gstudio /bin/sh -c "rsync -avzPh /data/oat /data/oac /softwares/"
        #docker exec -it gstudio /bin/sh -c "mkdir /home/docker/code/gstudio/gnowsys-ndf/qbank-lite/webapps/CLIx/datastore/repository/AssetContent/"
        docker exec -it gstudio /bin/sh -c "rsync -avzPh /data/CLIx/datastore/AssetContent/* /home/docker/code/gstudio/gnowsys-ndf/qbank-lite/webapps/CLIx/datastore/repository/AssetContent/"

        echo -e "\n${cyan}restarting school server instance to apply the configuration ${reset}"
        docker restart gstudio

        sleep 60      # Wait for apllication to start properly

        echo -e "\n${cyan}school server instance config - copy display pics and user csvs ${reset}"  
        #docker cp /home/docker/code/data/local_settings.py gstudio:/home/docker/code/gstudio/gnowsys-ndf/gnowsys_ndf/local_settings.py
        docker cp display-pics gstudio:/home/docker/code/
        docker cp user-csvs/${ss_id}_users.csv gstudio:/home/docker/code/user-csvs/

        echo -e "\n${cyan}school server instance config - create users and apply display pics ${reset}"
        docker exec -it gstudio /bin/sh -c "/usr/bin/python /home/docker/code/gstudio/gnowsys-ndf/manage.py sync_users /home/docker/code/user-csvs/${ss_id}_users.csv"

        echo -e "\n${cyan}school server instance config - setting necessary permissions to media direcory and files ${reset}"
        sudo chmod -R 755 /home/core/data/media/*

      fi

    elif [ "$docker_image_loading_status" == "Not Loaded" ]; then
      echo -e "\n${cyan}Docker image ($docker_image_name) doesn't exists. So we can't setup / configure the clix-server. ${reset}" ;
    else
      echo -e "\n${red}Error: Oops something went wrong. Contact system administator or CLIx technical team - Mumbai. ${reset}" ;
    fi
    
  elif  [ "$setup_clix_server_run_server_container_status" == "N" ] || [ "$setup_clix_server_run_server_container_status" == "n" ] || [ "$setup_clix_server_run_server_container_status" == "No" ] || [ "$setup_clix_server_run_server_container_status" == "no" ]; then
    echo -e "\n${cyan}Option selected / entered: $setup_clix_server_run_server_container_status. Hence skipping the clix-server setup (run server docker container and setup) and continuing with the process. ${reset}" ;
  else
    echo -e "\n${cyan}Oops something went wrong. Contact system administator or CLIx technical team - Mumbai. ${reset}" ;
    exit
  fi

}


function copy-extra-software-packages()
{
  
  # Setup CLIx server (Copy tar file)
  echo -e -n "\n${cyan}Do you want to copy extra software packages (Copy tar file) ? [Y/N]: ${reset}" ;
  read copy_extra_software_packages_copy_tar_file_status

  if [ "$copy_extra_software_packages_copy_tar_file_status" == "Y" ] || [ "$copy_extra_software_packages_copy_tar_file_status" == "y" ] || [ "$copy_extra_software_packages_copy_tar_file_status" == "Yes" ] || [ "$copy_extra_software_packages_copy_tar_file_status" == "yes" ] || [ "$copy_extra_software_packages_copy_tar_file_status" == "" ]; then
    # Mrunal : Handling mounting in case of unplanned poweroff (Power failure). Unmount the mounting point
    unmounting_disk
    echo -e "\n${cyan}Unmounting status : $unmounting_status ${reset}";

    mounting_disk
    echo -e "\n${cyan}Mounting status : $mounting_status ${reset}";
   
    echo -e "\n${cyan}Option selected / entered: $copy_extra_software_packages_copy_tar_file_status. Hence copying extra software packages (Copy tar file). ${reset}" ;
  
#    source_path="/mnt/home/core/setup-software/Tools /mnt/home/core/setup-software/coreos /mnt/home/core/setup-software/i2c-softwares /mnt/home/core/setup-software/syncthing ";
    source_path="/mnt/home/core/setup-software/extra_software_packages.tar.bz2";
    destination_path="/home/core/setup-software/" ;
    echo -e "\n${cyan}copy clix-server docker image from $source_path to $destination_path ${reset}" ;
    copy_content "$source_path" "$destination_path" ;

    unmounting_disk
    echo -e "\n${cyan}Unmounting status : $unmounting_status ${reset}";

  elif  [ "$copy_extra_software_packages_copy_tar_file_status" == "N" ] || [ "$copy_extra_software_packages_copy_tar_file_status" == "n" ] || [ "$copy_extra_software_packages_copy_tar_file_status" == "No" ] || [ "$copy_extra_software_packages_copy_tar_file_status" == "no" ]; then
    echo -e "\n${cyan}Option selected / entered: $copy_extra_software_packages_copy_tar_file_status. Hence skipping the copy extra software packages (Copy tar file) and continuing with the process. ${reset}" ;
  else
    echo -e "\n${cyan}Oops something went wrong. Contact system administator or CLIx technical team - Mumbai. ${reset}" ;
  fi

  # Setup CLIx server (untar file)
  echo -e -n "\n${cyan}Do you want to copy extra software packages (Untar tar file) ? [Y/N]: ${reset}" ;
  read copy_extra_software_packages_untar_tar_file_status

  if [ "$copy_extra_software_packages_untar_tar_file_status" == "Y" ] || [ "$copy_extra_software_packages_untar_tar_file_status" == "y" ] || [ "$copy_extra_software_packages_untar_tar_file_status" == "Yes" ] || [ "$copy_extra_software_packages_untar_tar_file_status" == "yes" ] || [ "$copy_extra_software_packages_untar_tar_file_status" == "" ]; then

    echo -e "\n${cyan}Option selected / entered: $copy_extra_software_packages_copy_tar_file_status. Hence copying extra software packages (Untar tar file). ${reset}" ;
  
    echo -e "\n${cyan}copy clix-server docker image from $source_path to $destination_path ${reset}" ;
    cd /home/core/setup-software/ ;
    sudo tar xvjf extra_software_packages.tar.bz2 

    unmounting_disk
    echo -e "\n${cyan}Unmounting status : $unmounting_status ${reset}";

  elif  [ "$copy_extra_software_packages_copy_tar_file_status" == "N" ] || [ "$copy_extra_software_packages_copy_tar_file_status" == "n" ] || [ "$copy_extra_software_packages_copy_tar_file_status" == "No" ] || [ "$copy_extra_software_packages_copy_tar_file_status" == "no" ]; then
    echo -e "\n${cyan}Option selected / entered: $copy_extra_software_packages_copy_tar_file_status. Hence skipping the copy extra software packages (Untar tar file) and continuing with the process. ${reset}" ;
  else
    echo -e "\n${cyan}Oops something went wrong. Contact system administator or CLIx technical team - Mumbai. ${reset}" ;
  fi  
}



function setup-syncthing()
{
  
  # Setup Syncthing (Copy syncthing image)
  echo -e -n "\n${cyan}Do you want to setup school server clix-server syncthing (Copy syncthing image) ? [Y/N]: ${reset}" ;
  read setup_syncthing_copy_content_server_image_status

  if [ "$setup_syncthing_copy_content_server_image_status" == "Y" ] || [ "$setup_syncthing_copy_content_server_image_status" == "y" ] || [ "$setup_syncthing_copy_content_server_image_status" == "Yes" ] || [ "$setup_syncthing_copy_content_server_image_status" == "yes" ] || [ "$setup_syncthing_copy_content_server_image_status" == "" ]; then
    # Mrunal : Handling mounting in case of unplanned poweroff (Power failure). Unmount the mounting point
    unmounting_disk
    echo -e "\n${cyan}Unmounting status : $unmounting_status ${reset}";

    mounting_disk
    echo -e "\n${cyan}Mounting status : $mounting_status ${reset}";
   
    echo -e "\n${cyan}Option selected / entered: $setup_syncthing_copy_content_server_image_status. Hence setting the clix-server syncthing (Copy syncthing image). ${reset}" ;
  
    source_path="/mnt/home/core/setup-software/syncthing";
    destination_path="/home/core/setup-software/";
    echo -e "\n${cyan}copy clix-server docker image from $source_path to $destination_path ${reset}"
    copy_content "$source_path" "$destination_path"  

    unmounting_disk
    echo -e "\n${cyan}Unmounting status : $unmounting_status ${reset}";

  elif  [ "$setup_syncthing_copy_content_server_image_status" == "N" ] || [ "$setup_syncthing_copy_content_server_image_status" == "n" ] || [ "$setup_syncthing_copy_content_server_image_status" == "No" ] || [ "$setup_syncthing_copy_content_server_image_status" == "no" ]; then
    echo -e "\n${cyan}Option selected / entered: $setup_syncthing_copy_content_server_image_status. Hence skipping the syncthing setup (Copy syncthing image) and continuing with the process. ${reset}" ;
  else
    echo -e "\n${cyan}Oops something went wrong. Contact system administator or CLIx technical team - Mumbai. ${reset}" ;
  fi

  # Setup syncthing (load syncthing image)
  echo -e -n "\n${cyan}Do you want to setup school server clix-server syncthing (load syncthing image) ? [Y/N]: ${reset}" ;
  read setup_syncthing_load_server_image_status

  if [ "$setup_syncthing_load_server_image_status" == "Y" ] || [ "$setup_syncthing_load_server_image_status" == "y" ] || [ "$setup_syncthing_load_server_image_status" == "Yes" ] || [ "$setup_syncthing_load_server_image_status" == "yes" ] || [ "$setup_syncthing_load_server_image_status" == "" ]; then
    echo -e "\n${cyan}Option selected / entered: $setup_syncthing_load_server_image_status. Hence setting the clix-server syncthing (load syncthing image). ${reset}" ;

    # clix-server docker image loading process (along with validation)
    docker_image_path="/home/core/setup-software/syncthing/syncthing.tar";
    docker_image_name="joeybaker/syncthing";
    docker_image_grep_name="syncthing";
    docker_load_validation 
    docker_image_loading_status="Not Loaded";

    if [ "$response_status" == "Working" ]; then
      echo -e "\n${cyan}Docker image ($docker_image_name) already exists. ${reset}" ;
      docker_image_loading_status="Loaded";
    elif [ "$response_status" == "Not_Working" ]; then

      echo -e "\n${cyan}Docker image ($docker_image_name) doesn't exists. Hence we are loading the docker image ${reset}" ;
      docker_image_loading_status="Not Loaded";
      file_existence_validation $docker_image_path
      if [ "$file_existence_status" == "Present" ]; then
        echo -e "\n${cyan}File ($filename) exists. ${reset}"
        docker_load 
        docker_load_validation 

        if [ "$response_status" == "Working" ]; then
          echo -e "\n${cyan}Docker image ($docker_image_name) successfully loaded. ${reset}" ;
          docker_image_loading_status="Loaded";
        elif [ "$response_status" == "Not_Working" ]; then
          echo -e "\n${cyan}Docker image ($docker_image_name) failed to load. ${reset}" ;
          docker_image_loading_status="Not Loaded";
        else
          echo -e "\n${red}Error: Oops something went wrong. Contact system administator or CLIx technical team - Mumbai. ${reset}" ;
          docker_image_loading_status="Not Loaded";
        fi

      elif [ "$file_existence_status" == "Not_Present" ]; then
        echo -e "\n${red}Error: File ($filename) doesn't exists. Hence syncthing image ($docker_image_name) will not be able to load.${reset}"
        docker_image_loading_status="Not Loaded";
        exit
      else
        echo -e "\n${red}Error: Oops something went wrong. Contact system administator or CLIx technical team - Mumbai. ${reset}" ;
        docker_image_loading_status="Not Loaded";
      fi

    else
      echo -e "\n${red}Error: Oops something went wrong. Contact system administator or CLIx technical team - Mumbai. ${reset}" ;
      docker_image_loading_status="Not Loaded";
    fi

  elif  [ "$setup_syncthing_load_server_image_status" == "N" ] || [ "$setup_syncthing_load_server_image_status" == "n" ] || [ "$setup_syncthing_load_server_image_status" == "No" ] || [ "$setup_syncthing_load_server_image_status" == "no" ]; then
    echo -e "\n${cyan}Option selected / entered: $setup_syncthing_load_server_image_status. Hence skipping the clix-server syncthing setup (load syncthing image) and continuing with the process. ${reset}" ;
  else
    echo -e "\n${cyan}Oops something went wrong. Contact system administator or CLIx technical team - Mumbai. ${reset}" ;
  fi


  # Setup CLIx server syncthing (run syncthing container)
  echo -e -n "\n${cyan}Do you want to setup school server clix-server syncthing (run syncthing docker container and setup)? [Y/N]: ${reset}" ;
  read setup_syncthing_run_server_container_status

  if [ "$setup_syncthing_run_server_container_status" == "Y" ] || [ "$setup_syncthing_run_server_container_status" == "y" ] || [ "$setup_syncthing_run_server_container_status" == "Yes" ] || [ "$setup_syncthing_run_server_container_status" == "yes" ] || [ "$setup_syncthing_run_server_container_status" == "" ]; then
    echo -e "\n${cyan}Option selected / entered: $setup_syncthing_run_server_container_status. Hence setting the clix-server syncthing (run syncthing container). ${reset}" ;

    if [ "$docker_image_loading_status" == "Loaded" ]; then
      echo -e "\n${cyan}Docker image already exists. ${reset}" ;

      # clix-server docker image loading process (along with validation)
      docker_image_path="/home/core/setup-software/syncthing/syncthing.tar";
      docker_image_name="joeybaker/syncthing";
      docker_image_grep_name="syncthing";
      docker_load_validation 
      docker_image_loading_status="Not Loaded";

      # clix-server docker contianer running process (along with validation)
      docker_image_path="/home/core/setup-software/syncthing/syncthing.tar";
      docker_image_name="joeybaker/syncthing";
      docker_container_name="syncthing";
      docker_flag=" -itd -h syncthing --restart=always ";
      docker_volumes="-v /home/core/backups:/srv/backups  -v /srv/syncthing:/srv/config";
      docker_ports="-p 22000:22000  -p 21025:21025/udp  -p 8090:8080";
      docker_run_validation 
      docker_container_running_status="Not Loaded";
      
      if [ "$response_status" == "Working" ]; then
        echo -e "\n${cyan}Docker image ($docker_image_name) already exists. ${reset}" ;
        docker_container_running_status="Loaded";
      elif [ "$response_status" == "Not_Working" ]; then

        echo -e "\n${cyan}Docker image ($docker_image_name) doesn't exists. Hence we are running the docker container ${reset}" ;
        docker_container_running_status="Not Loaded";
        file_existence_validation $docker_image_path
        if [ "$file_existence_status" == "Present" ]; then
          echo -e "\n${cyan}File ($filename) exists. ${reset}"
          docker_run
          docker_run_validation 

          if [ "$response_status" == "Working" ]; then
            echo -e "\n${cyan}Docker image ($docker_container_name) successfully loaded / running. ${reset}" ;
            docker_container_running_status="Loaded";
          elif [ "$response_status" == "Not_Working" ]; then
            echo -e "\n${cyan}Docker image ($docker_container_name) failed to load / run. ${reset}" ;
            docker_container_running_status="Not Loaded";
          else
            echo -e "\n${red}Error: Oops something went wrong. Contact system administator or CLIx technical team - Mumbai. ${reset}" ;
            docker_container_running_status="Not Loaded";
          fi

        elif [ "$file_existence_status" == "Not_Present" ]; then
          echo -e "\n${red}Error: File ($filename) doesn't exists. Hence clix-server syncthing image ($docker_container_name) will not be able to load / run.${reset}"
          docker_container_running_status="Not Loaded";
        else
          echo -e "\n${red}Error: Oops something went wrong. Contact system administator or CLIx technical team - Mumbai. ${reset}" ;
          docker_container_running_status="Not Loaded";
          exit
        fi
      fi
    
    elif [ "$docker_image_loading_status" == "Not Loaded" ]; then
      echo -e "\n${cyan}Docker image ($docker_image_name) doesn't exists. So we can't setup / configure the clix-server. ${reset}" ;
    else
      echo -e "\n${red}Error: Oops something went wrong. Contact system administator or CLIx technical team - Mumbai. ${reset}" ;
    fi
    
  elif  [ "$setup_syncthing_run_server_container_status" == "N" ] || [ "$setup_syncthing_run_server_container_status" == "n" ] || [ "$setup_syncthing_run_server_container_status" == "No" ] || [ "$setup_syncthing_run_server_container_status" == "no" ]; then
    echo -e "\n${cyan}Option selected / entered: $setup_clix_server_run_server_container_status. Hence skipping the clix-server setup (run server docker container and setup) and continuing with the process. ${reset}" ;
  else
    echo -e "\n${cyan}Oops something went wrong. Contact system administator or CLIx technical team - Mumbai. ${reset}" ;
    exit
  fi

 
}

#************************ Major process realted functions ends from here ***************************#


#**************************** Installation process starts from here ********************************#

# 
echo -e "\n${cyan}Please be ready with the following details: ${reset}" ;
echo -e "\n${cyan}\t School server id ${reset}" ;

echo -e "\n${cyan}Please (re)insert the (CLIx School Server) installer (pen drive / portable HDD).${reset}"

sleep 5

check_disk_insertion
echo -e "\n${cyan}Disk status : $disk_status ${reset}";

echo -e "\n${cyan}Please provide the School server id? (Example Mizoram school 23 will have mz23 and Telangana 24 school - tg24) ${reset}" ;
echo -e -n "School server id: "
read ss_id

# For testing purpose
# ls -ltrh /mnt/test
# mounting_disk
# echo -e "\n${cyan}Mounting status : $mounting_status ${reset}";
# unmounting_disk
# echo -e "\n${cyan}Unmounting status : $unmounting_status ${reset}";


# Setup CLIx server 
echo -e -n "\n${cyan}Do you want to setup school server clix-server? [Y/N]: ${reset}" ;
read setup_clix_server_status

if [ "$setup_clix_server_status" == "Y" ] || [ "$setup_clix_server_status" == "y" ] || [ "$setup_clix_server_status" == "Yes" ] || [ "$setup_clix_server_status" == "yes" ] || [ "$setup_clix_server_status" == "" ]; then
  echo -e "\n${cyan}Option selected / entered: $setup_clix_server_status. Hence setting the clix-server. ${reset}" ;
  setup-clix-server
elif  [ "$setup_clix_server_status" == "N" ] || [ "$setup_clix_server_status" == "n" ] || [ "$setup_clix_server_status" == "No" ] || [ "$setup_clix_server_status" == "no" ]; then
  echo -e "\n${cyan}Option selected / entered: $setup_clix_server_status. Hence skipping the clix-server setup and continuing with the process. ${reset}" ;
else
  echo -e "\n${cyan}Oops something went wrong. Contact system administator or CLIx technical team - Mumbai. ${reset}" ;
fi


# Copy extra softwares
echo -e -n "\n${cyan}Do you want to copy extra software packages? [Y/N]: ${reset}" ;
read copy_extra_software_packages_status

if [ "$copy_extra_software_packages_status" == "Y" ] || [ "$copy_extra_software_packages_status" == "y" ] || [ "$copy_extra_software_packages_status" == "Yes" ] || [ "$copy_extra_software_packages_status" == "yes" ] || [ "$setup_clix_server_status" == "" ]; then
  echo -e "\n${cyan}Option selected / entered: $copy_extra_software_packages_status. Hence copying extra software packages for the clix-server. ${reset}" ;
  copy-extra-software-packages
elif  [ "$copy_extra_software_packages_status" == "N" ] || [ "$copy_extra_software_packages_status" == "n" ] || [ "$copy_extra_software_packages_status" == "No" ] || [ "$copy_extra_software_packages_status" == "no" ]; then
  echo -e "\n${cyan}Option selected / entered: $copy_extra_software_packages_status. Hence skipping the copying of extra software packages for the clix-server setup and continuing with the process. ${reset}" ;
else
  echo -e "\n${cyan}Oops something went wrong. Contact system administator or CLIx technical team - Mumbai. ${reset}" ;
fi


# Setup Syncthing
echo -e -n "\n${cyan}Do you want to setup syncthing for clix-server? [Y/N]: ${reset}" ;
read setup_syncthing_status

if [ "$setup_syncthing_status" == "Y" ] || [ "$setup_syncthing_status" == "y" ] || [ "$setup_syncthing_status" == "Yes" ] || [ "$setup_syncthing_status" == "yes" ] || [ "$setup_clix_server_status" == "" ]; then
  echo -e "\n${cyan}Option selected / entered: $setup_syncthing_status. Hence setting the syncthing. ${reset}" ;
  setup-syncthing
elif  [ "$setup_syncthing_status" == "N" ] || [ "$setup_syncthing_status" == "n" ] || [ "$setup_syncthing_status" == "No" ] || [ "$setup_syncthing_status" == "no" ]; then
  echo -e "\n${cyan}Option selected / entered: $setup_syncthing_status. Hence skipping the syncthing setup and continuing with the process. ${reset}" ;
else
  echo -e "\n${cyan}Oops something went wrong. Contact system administator or CLIx technical team - Mumbai. ${reset}" ;
fi


echo -e "\n${cyan}start docker at startup ${reset}"
sudo systemctl enable docker

exit
