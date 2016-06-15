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


#--------------------------------------------------------------------#
# Log file details...
#--------------------------------------------------------------------#
LOG_DIR="$(pwd)/Pre-install_Logs";
INSTALL_LOG="docker-load-image-$(date +%Y%m%d-%H%M%S).log"; # Mrunal : Fri Aug 28 17:38:35 IST 2015 : used for redirecting Standard_output(Normal msg)
INSTALL_LOG_FILE="$LOG_DIR/$INSTALL_LOG"; # Mrunal : Fri Aug 28 17:38:35 IST 2015 : used for redirecting Standard_output(Normal msg)
dHOME="/home/docker/code";
# ---------------- Log files variable def ends here -----------------


# Mrunal : Set dHOME variable in deploy.conf
file=`readlink -e -f $0`
file1=`echo $file | sed -e 's/\/scripts.*//'` ; 
file2=`echo $file1 | sed -e 's/\//\\\\\//g'` ;
#    file3=`echo $file1 | sed -e 's:/:\\\/:g'` ;
sed -e "/hHOME/ s/=.*;/=$file2;/" -i  $file1/confs/deploy.conf;
more $file1/confs/deploy.conf | grep hHOME; 


source $file1/confs/deploy.conf

pwd
#sg docker -c 'pwd'
docker ps
if [[ $? != 0 ]]; then
    echo -e "\nCaution-msg : Please check the docker installation Or install docker and restart system to take effect. Try again later after.\n"  | sed -e "s/^/$(date +%Y%b%d-%I%M%S%p) $   /"  2>&1 | tee -a ${INSTALL_LOG_FILE}
    exit;
fi
    

if [[ $1 == "" ]]; then
    echo "Please provide the image name with complete path.(\path_to_the_dirctory\file_name)" ;
    echo "(For example '/home/docker/code/school-server_mongokit_v1-20160330-134534' must be the default file name and hit Enter key of Keyboard)" ;
    read dock_img_file ;
elif [[ -f $dock_img_file ]]; then
    dock_img_file=$1;
elif [[ ! -f $dock_img_file ]]; then
    echo -e "Info-msg : Docker image file does not exist. \n"   | sed -e "s/^/$(date +%Y%b%d-%I%M%S%p) $   /"  2>&1 | tee -a ${INSTALL_LOG_FILE}    
    exit;
else
    echo -e "\nCaution-msg : Something went wrong.\n"  | sed -e "s/^/$(date +%Y%b%d-%I%M%S%p) $   /"  2>&1 | tee -a ${INSTALL_LOG_FILE}
    exit;
fi
echo "Docker image file name entered is $dock_img_file ." ;

echo -e "\nInfo-msg : Loading docker images($dock_img). Be patient it may take few minutes. : sg docker -c 'docker load < $dock_img_file' \n"  | sed -e "s/^/$(date +%Y%b%d-%I%M%S%p) $   /"  2>&1 | tee -a ${INSTALL_LOG_FILE}
docker load < $dock_img_file

if [[ $? -eq 0 ]]; then
    # Docker image loaded successfully
    echo -e "Info-msg : Docker image loaded successfully. " | sed -e "s/^/$(date +%Y%b%d-%I%M%S%p) $   /"  2>&1 | tee -a ${INSTALL_LOG_FILE}
    bash $hHOME/scripts/start-new-container.sh $dock_img_name
else
    # Docker image loading failed 
    echo -e "Caution-msg : Docker image could not be loaded. Please try again. (Error code : $?) \n" | sed -e "s/^/$(date +%Y%b%d-%I%M%S%p) $   /"  2>&1 | tee -a ${INSTALL_LOG_FILE}
fi

# ----------------------------- Shell file code ends here ------------------------------------------

}
