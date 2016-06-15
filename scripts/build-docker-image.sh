#!/bin/bash
{

#--------------------------------------------------------------------------------------------------------------#
# File name   : build-docker.sh
# File creation : gnowgi
# Description :
#               git clone
#               Build Docker-Image via docker build command (using Dockerfile)
#
# Last Modification : Mrunal M. Nachankar : Mon, 07-09-2015 12:15:AM
# Description :      
#               Logs directory check and creation
#               Prerequisites - Checking for OS version and architecture
#                               Checking type of user and permission
#                               Internet checking
#                               Checking wget package
#               Docker application / package checking and installation
#               Creating local copy of replica code via git clone or update via git pull 
#               Build Docker-Image via docker build command (using Dockerfile)
#               Verify image creation
#               Start the Docker-container via docker run command (using newly created docker image)
#               Copy host logs(pre-install logs) inside docker container 
#               Verify initialization of docker-container and display message of completion
#--------------------------------------------------------------------------------------------------------------#

#-----------------------------------------------------------------------
# Mrunal M. Nachankar : Mon, 07-09-2015 12:15:AM : Old code
#git clone https://github.com/gnowledge/gstudio.git
#docker build -t gnowgi/gstudio .
#-----------------------------------------------------------------------


# shell 
sh_c="sh -c"

# bfilename is base file name, extension is file extension and filename is just file name without path and extension
bfilename=$(basename "$0")
extension="${filename##*.}"
filename="${filename%.*}"
#echo "Here ----------- :$filename:$extension:$filename:$0:";


# Mrunal : Set HOME variable in deploy.conf
file=`readlink -e -f $0`
file1=`echo $file | sed -e 's/\/scripts.*//'` ; 
file2=`echo $file1 | sed -e 's/\//\\\\\//g'` ;
#    file3=`echo $file1 | sed -e 's:/:\\\/:g'` ;
#echo "FIle1 - $file1 and File2 - $file2----------------------------------------"
sed -e "/hHOME/ s/=.*;/=$file2;/" -i  $file1/confs/deploy.conf;
more $file1/confs/deploy.conf | grep hHOME; 


#--------------------------------------------------------------------#
# Log file details...
#--------------------------------------------------------------------#
LOG_DIR="$(pwd)/Pre-install_Logs";
INSTALL_LOG="build-docker-image-$(date +%Y%m%d-%H%M%S).log"; # Mrunal : Fri Aug 28 17:38:35 IST 2015 : used for redirecting Standard_output(Normal msg)
INSTALL_LOG_FILE="$LOG_DIR/$INSTALL_LOG"; # Mrunal : Fri Aug 28 17:38:35 IST 2015 : used for redirecting Standard_output(Normal msg)
HOME="";
mkdir $LOG_DIR
touch $INSTALL_LOG_FILE

log1=`echo $LOG_DIR | sed -e 's/\//\\\\\//g'` ;
log2=`echo $INSTALL_LOG_FILE | sed -e 's/\//\\\\\//g'` ;


#echo "MLOG:$LOG_DIR : $file1/confs/deploy.conf ---------------  $filename1"
sed -e "/LOG_DIR/ s/=.*;/=$log1;/" -i  $file1/confs/deploy.conf;
sed -e "/INSTALL_LOG/ s/=.*;/=$INSTALL_LOG;/" -i  $file1/confs/deploy.conf;
sed -e "/INSTALL_LOG_FILE/ s/=.*;/=$log2;/" -i  $file1/confs/deploy.conf;
# ---------------- Log files variable def ends here -----------------


source $file1/confs/deploy.conf
source $file1/scripts/internet-check.sh



pwd
#sg docker -c 'pwd'
docker ps
echo -e "\n"
if [[ $? != 0 ]]; then
    echo -e "\nCaution-msg : Please check the docker installation Or install docker and restart system to take effect. Try again later after. $?\n"  | sed -e "s/^/$(date +%Y%m%d-%I%M%S%p) $   /"  2>&1 | tee -a ${INSTALL_LOG_FILE}
    exit;
fi

# if [[ $1 == "" ]]; then
#     echo "Please provide the image name with complete path.(\path_to_the_dirctory\file_name)" ;
#     echo "(For example '/home/docker/code/school-server_mongokit_v1-20160330-134534' must be the default file name and hit Enter key of Keyboard)" ;
#     read dock_img_file ;
# elif [[ -f $dock_img_file ]]; then
#     dock_img_file=$1;
# elif [[ ! -f $dock_img_file ]]; then
#     echo -e "Info-msg : Docker image file does not exist. \n"   | sed -e "s/^/$(date +%Y%m%d-%I%M%S%p) $   /"  2>&1 | tee -a ${INSTALL_LOG_FILE}    
# else
#     echo -e "\nCaution-msg : Something went wrong.\n"  | sed -e "s/^/$(date +%Y%m%d-%I%M%S%p) $   /"  2>&1 | tee -a ${INSTALL_LOG_FILE}
#     exit;
# fi
# echo "Docker image file name entered is $dock_img_file ." ;



# Checking for the interent connections
source $file1/scripts/internet-check.sh

# We are checking the gstudio repo. If the directory exists then take git pull or else take clone of online repo
echo -e "\nInfo-msg : Checking gstudio repo local directory. If the directory exists then take git pull or else take clone of online repo  \n"  | sed -e "s/^/$(date +%Y%m%d-%I%M%S%p) $   /"  2>&1 | tee -a ${INSTALL_LOG_FILE}

# docker image and container related variables
_repo_branch="";


echo -e "\nInfo-msg : Please give branch name of online repo "  | sed -e "s/^/$(date +%Y%m%d-%I%M%S%p) $   /"  2>&1 | tee -a ${INSTALL_LOG_FILE}
echo -e -n "\n${red}Branch name: ${reset}"   | sed -e "s/^/$(date +%Y%m%d-%I%M%S%p) $   /"  2>&1 | tee -a ${INSTALL_LOG_FILE}
read -t 60 _repo_branch

if [ "$_repo_branch" == "" ]; then
    echo -e "\nInfo-msg : No value provided. So applying default value as replica. \n"  | sed -e "s/^/$(date +%Y%m%d-%I%M%S%p) $   /"  2>&1 | tee -a ${INSTALL_LOG_FILE}
    _repo_branch="replica";
fi 

# git branch -r  | cut -d/ -f2- | grep -v HEAD | grep $_repo_branch > /dev/null 2>&1

# if [ $? -eq 0 ]; then
#     echo -e "\nInfo-msg : Value provided is $_repo_branch. \n"  | sed -e "s/^/$(date +%Y%m%d-%I%M%S%p) $   /"  2>&1 | tee -a ${INSTALL_LOG_FILE}
# else
#     echo -e "\nInfo-msg : Value provided is $_repo_branch. Input is invalid \n"  | sed -e "s/^/$(date +%Y%m%d-%I%M%S%p) $   /"  2>&1 | tee -a ${INSTALL_LOG_FILE}
#     exit
# fi

if [ -d "gstudio" ]; then
    cd gstudio

    git branch -r --list | grep $_repo_branch  > /dev/null 2>&1   # Mrunal : No redirections here please
    if [ $? -eq 0 ]; then               # If internet connection is available
	echo -e "\nInfo-msg : Value is correct hence continuing the procedure. \n"  | sed -e "s/^/$(date +%Y%m%d-%I%M%S%p) $   /"  2>&1 | tee -a ${INSTALL_LOG_FILE}
    else
	echo -e "\nInfo-msg : No value provided. So applying default value as replica. \n"  | sed -e "s/^/$(date +%Y%m%d-%I%M%S%p) $   /"  2>&1 | tee -a ${INSTALL_LOG_FILE}
	_repo_branch="replica";
    fi	

    # Pull the gstudio code from github online repo
    echo -e "\nInfo-msg : Pull the gstudio latest code from github online repo and $_repo_branch branch as gstudio directory already exist.\n"  | sed -e "s/^/$(date +%Y%m%d-%I%M%S%p) $   /"  2>&1 | tee -a ${INSTALL_LOG_FILE}
    
    git branch --list | grep $_repo_branch  > /dev/null 2>&1   # Mrunal : No redirections here please
    if [ $? -eq 0 ]; then               # If internet connection is available
	git checkout $_repo_branch       # Switch to branch 
    else
	git checkout -b $_repo_branch    # Create and Switched to branch
    fi	
    #git pull https://github.com/gnowledge/gstudio.git
    git pull origin $_repo_branch | sed -e "s/^/$(date +%Y%m%d-%I%M%S%p) $   /"  2>&1 | tee -a ${INSTALL_LOG_FILE}   # Mrunal-uncomment it - kedar ebuddy issue quick fix
    cd ..
else    
    # Clone the gstudio code from github online repo
    echo -e "\nInfo-msg : Clone the gstudio code from github online repo : $_repo_branch \n"  | sed -e "s/^/$(date +%Y%m%d-%I%M%S%p) $   /"  2>&1 | tee -a ${INSTALL_LOG_FILE}
    git clone https://github.com/gnowledge/gstudio.git -b $_repo_branch | sed -e "s/^/$(date +%Y%m%d-%I%M%S%p) $   /"  2>&1 | tee -a ${INSTALL_LOG_FILE}
fi


echo -e 'Please select the database for storing the users credentials: \n   1. sqlite \n   2. postgresql';
read _OPTION ;

echo -e "$HOME/scripts/local_settings_changes.sh"

# Mrunal : for applying comments for sqlite3/postgresql
bash $HOME/scripts/local_settings_changes.sh $_OPTION $_repo_branch



# Checking for the interent connections
source $file1/scripts/internet-check.sh


# Build the docker image (via instructions in Docker file)
echo -e "\nInfo-msg : Build the docker image (via instructions in Docker file). This process may take long time {Depends on the internet speed. Approx(45mins - 1.45mins)} . docker build -t $dock_img_name . \n"  | sed -e "s/^/$(date +%Y%m%d-%I%M%S%p) $   /"  2>&1 | tee -a ${INSTALL_LOG_FILE}
docker build -t $dock_img_name .

docker images $dock_img_name | grep $dock_img_name  > /dev/null 2>&1   # Mrunal : No redirections here please
if [ $? -eq 0 ]; then
    # Docker-Image created successfully
    echo -e "Info-msg : Docker-Image created successfully. Now initiating the Docker-Container with created docker image(gnowgi/gstudio).\n" | sed -e "s/^/$(date +%Y%m%d-%I%M%S%p) $   /"  2>&1 | tee -a ${INSTALL_LOG_FILE}
    bash $HOME/scripts/start-new-container.sh $dock_img_name
else
    # Docker-Image creation Failed
    echo -e "Caution-msg : Docker-Image creation Failed. Please try again. \n" | sed -e "s/^/$(date +%Y%m%d-%I%M%S%p) $   /"  2>&1 | tee -a ${INSTALL_LOG_FILE}
    exit
fi

echo -e "\nInfo-msg : copy pre-install logs to docker system \n" | sed -e "s/^/$(date +%Y%m%d-%I%M%S%p) $   /"  2>&1 | tee -a ${INSTALL_LOG_FILE}
sudo docker cp ${INSTALL_LOG_FILE} $(docker inspect -f '{{.Id}}'  $(docker ps -q)):/root/DockerLogs/  | sed -e "s/^/$(date +%Y%m%d-%I%M%S%p) $   /"  2>&1 | tee -a ${INSTALL_LOG_FILE}

echo -e "\nInfo-msg : Verify the copy process and existence of the file \n"  | sed -e "s/^/$(date +%Y%m%d-%I%M%S%p) $   /"  2>&1 | tee -a ${INSTALL_LOG_FILE}
sudo ls /var/lib/docker/aufs/mnt/$(docker inspect -f '{{.Id}}' $(docker ps -q --filter=image=$dock_img_name))/root/DockerLogs/  | sed -e "s/^/$(date +%Y%m%d-%I%M%S%p) $   /"  2>&1 | tee -a ${INSTALL_LOG_FILE}


docker ps -q --filter=image=$dock_img_name  > /dev/null 2>&1   # Mrunal : No redirections here please
if [ $? -eq 0 ]; then
    # Installation completed
    echo -e "Info-msg : Docker image built successfully. Just enter your ipaddress:port in address bar of your internet browser." | sed -e "s/^/$(date +%Y%m%d-%I%M%S%p) $   /"  2>&1 | tee -a ${INSTALL_LOG_FILE}
else
    # Installation Failed
    echo -e "Caution-msg : Docker image building failed. Please try again. \n" | sed -e "s/^/$(date +%Y%m%d-%I%M%S%p) $   /"  2>&1 | tee -a ${INSTALL_LOG_FILE}
fi

# Mrunal : start the container
#bash $HOME/scripts/start-new-container.sh $_OPTION $_repo_branch

# ----------------------------- Shell file code ends here ------------------------------------------

}
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          [0m
-rwxrwxr-x 1 glab glab   241 Mar 28 12:21 [01;32mAUTHORS[0m
-rwxrwxr-x 1 glab glab 12171 Jun  1 21:33 [01;32mDockerfile[0m
drwxrwxr-x 3 glab glab  4096 Jun  1 23:14 [01;34mscripts[0m
drwxrwxr-x 2 glab glab  4096 Jun  1 23:19 [01;34mconfs[0m
]0;glab@Latitude3540-Ubuntu16: ~/Mrunal/Docker/mrufinal/git-docker-gitudio/new-working-bkp[01;32mglab@Latitude3540-Ubuntu16[01;33m:[01;34m~/Mrunal/Docker/mrufinal/git-docker-gitudio/new-working-bkp[01;33m$[00m subl scripts[K[K[K[K[K[K[K[K[K[K[K[Kls
[0m[01;34mbackup_defaults[0m
]0;glab@Latitude3540-Ubuntu16: ~/Mrunal/Docker/mrufinal/git-docker-gitudio/new-working-bkp[01;32mglab@Latitude3540-Ubuntu16[01;33m:[01;34m~/Mrunal/Docker/mrufinal/git-docker-gitudio/new-working-bkp[01;33m$[00m subl backup_defaults/scripts/bi[Kuild-docker-image.sh 
]0;glab@Latitude3540-Ubuntu16: ~/Mrunal/Docker/mrufinal/git-docker-gitudio/new-working-bkp[01;32mglab@Latitude3540-Ubuntu16[01;33m:[01;34m~/Mrunal/Docker/mrufinal/git-docker-gitudio/new-working-bkp[01;33m$[00m subl backup_defaults/scripts/build-docker-image.sh [C[C[C[C[4P[1@c[1@p[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C../h[Kgstudio-docker
gstudio-docker/            gstudio-docker-dev/        gstudio-docker-final/      gstudio-docker-mess/       gstudio-docker-modified/   gstudio-docker-new-os-bkp/
]0;glab@Latitude3540-Ubuntu16: ~/Mrunal/Docker/mrufinal/git-docker-gitudio/new-working-bkp[01;32mglab@Latitude3540-Ubuntu16[01;33m:[01;34m~/Mrunal/Docker/mrufinal/git-docker-gitudio/new-working-bkp[01;33m$[00m cp backup_defaults/scripts/build-docker-image.sh ../gstudio-docker/
AUTHORS           Dockerfile        .git/             maintenance/      README.md         scripts/          user-details/     
confs/            duplicity-backup/ gstudio/          Pre-install_Logs/ schema_dump/      .sync/            
]0;glab@Latitude3540-Ubuntu16: ~/Mrunal/Docker/mrufinal/git-docker-gitudio/new-working-bkp[01;32mglab@Latitude3540-Ubuntu16[01;33m:[01;34m~/Mrunal/Docker/mrufinal/git-docker-gitudio/new-working-bkp[01;33m$[00m cp backup_defaults/scripts/build-docker-image.sh ../gstudio-docker/
AUTHORS           Dockerfile        .git/             maintenance/      README.md         scripts/          user-details/     
confs/            duplicity-backup/ gstudio/          Pre-install_Logs/ schema_dump/      .sync/            
]0;glab@Latitude3540-Ubuntu16: ~/Mrunal/Docker/mrufinal/git-docker-gitudio/new-working-bkp[01;32mglab@Latitude3540-Ubuntu16[01;33m:[01;34m~/Mrunal/Docker/mrufinal/git-docker-gitudio/new-working-bkp[01;33m$[00m cp backup_defaults/scripts/build-docker-image.sh ../gstudio-docker/scripts/
]0;glab@Latitude3540-Ubuntu16: ~/Mrunal/Docker/mrufinal/git-docker-gitudio/new-working-bkp[01;32mglab@Latitude3540-Ubuntu16[01;33m:[01;34m~/Mrunal/Docker/mrufinal/git-docker-gitudio/new-working-bkp[01;33m$[00m cd ../gstudio-docker
]0;glab@Latitude3540-Ubuntu16: ~/Mrunal/Docker/mrufinal/git-docker-gitudio/gstudio-docker[01;32mglab@Latitude3540-Ubuntu16[01;33m:[01;34m~/Mrunal/Docker/mrufinal/git-docker-gitudio/gstudio-docker[01;33m$[00m s[Kls
[0m[01;32mAUTHORS[0m  [01;34mconfs[0m  [01;32mDockerfile[0m  [01;34mduplicity-backup[0m  [01;34mgstudio[0m  [01;34mmaintenance[0m  [01;34mPre-install_Logs[0m  [01;32mREADME.md[0m  [01;34mschema_dump[0m  [01;34mscripts[0m  [01;34muser-details[0m
]0;glab@Latitude3540-Ubuntu16: ~/Mrunal/Docker/mrufinal/git-docker-gitudio/gstudio-docker[01;32mglab@Latitude3540-Ubuntu16[01;33m:[01;34m~/Mrunal/Docker/mrufinal/git-docker-gitudio/gstudio-docker[01;33m$[00m (reverse-i-search)`': [Kb': cp backup_defaults/scripts/build-docker-image.sh ../gstudio-docker/scripts/[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[1@a[C[C[C[C[C[C[46Ps': doc