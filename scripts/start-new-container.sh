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
dHOME="/home/docker/code"
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
sg docker -c 'pwd'
#     echo -e "\nInfo-msg : Loading docker images($dock_img). Be patient it may take few minutes. : sg docker -c 'docker load < $dock_img_file' \n"  | sed -e "s/^/$(date +%Y%b%d-%I%M%S%p) $   /"  2>&1 | tee -a ${INSTALL_LOG_FILE}
# sg docker -c "docker load < $dock_img_file"

if [[ $1 == "" ]]; then
    echo "Please provide the image name.(REPOSITORY:TAG)" ;
    docker images --format "table {{.Repository}}\t{{.Tag}} \t{{.ID}}"
    echo "(For example 'school-server/mongokit:v1-20160330-134534' must be the default file name and hit Enter key of Keyboard)" ;
    read dock_img_name ;
else
    dock_img_name=$1;
fi
echo "Image name entered is $dock_img_name ." ;
docker_repo=$(echo $dock_img_name | cut -f1 -d:);
docker_tag=$(echo $dock_img_name | cut -f2 -d:);
echo "docker images | grep -w $docker_repo.*$docker_tag"
docker images | grep -w "$docker_repo.*$docker_tag"  > /dev/null 2>&1   # Mrunal : No redirections here please
#echo "$?"

if [ "$?" != "0" ] ; then
    # Docker-Image creation Failed
    echo -e "Caution-msg : Docker image $dock_img_name does not exist. Try again later\n" | sed -e "s/^/$(date +%Y%b%d-%I%M%S%p) $   /"  2>&1 | tee -a ${INSTALL_LOG_FILE}
    exit
else
    echo -e "Caution-msg : Docker image $dock_img_name exist.\n" | sed -e "s/^/$(date +%Y%b%d-%I%M%S%p) $   /"  2>&1 | tee -a ${INSTALL_LOG_FILE}  
fi

n=0 ;
nl=($(more $file1/confs/deploy.conf  | sed -n -e '/port_.*_host/ s/ *=.*;//p' | wc -l));   # ref : https://linuxconfig.org/how-to-count-occurrence-of-a-specific-character-in-a-string-or-file-using-bash

lport_name=($(more $file1/confs/deploy.conf  | sed -n -e '/port_.*_host/ s/ *=.*;//p'))

lport_num=($(more $file1/confs/deploy.conf  | sed -n -e '/port_.*_host/ s/.*= *\(.*\);/\1/p'))

#echo "${lport_name[@]}"
#echo "$n : $nl"

dock_hostname=($(more $file1/confs/deploy.conf  | sed -n -e '/dock_hostname/ s/.*= *\(.*\);/\1/p'))


for (( n=0; n<nl; n++ ))
do
    
    echo "${lport_name[$n]} is ${lport_num[$n]}"
    
    lport_status="busy";
    while [ "$lport_status" == "busy" ]
    do
    echo "H1"
 #    Two_entry="False";
 #    echo "${lport_num[*]} ------ ${lport_num[$n]} ---- ${lport_num[*]/${lport_num[$n]}/} ---- ${lport_num[*]}"
	# echo "${tport_num[*]} ------ ${tport_num[$n]} ---- ${tport_num[*]/${tport_num[$n]}/} ---- ${tport_num[*]}"
	# if [[ "${tport_num[*]/$port_no/}" = "${tport_num[*]}" ]]; then
	# 	Two_entry="True";
	# fi
	# echo "H2 $Two_entry"
	l=`sudo netstat -ntulp | grep -w :${lport_num[$n]}`
	if [[ "$?" == "0" ]] ; then
	    lport_status="busy";
	    port_no=${lport_num[$n]};
	    nothing=1;
	    while [ $nothing == 1 ]
	    do
		tport_num=("${lport_num[@]}")
    	port_no=${tport_num[$n]};
    	unset tport_num[$n]
    	#port_no=$((port_no+1));
		echo "${lport_num[*]} ------ $port_no --- ${lport_num[*]/$port_no/} --- ${lport_num[*]}"
		if [ "${tport_num[*]/$port_no/}" = "${tport_num[*]}" ]; then
		    lport_num[$n]=$port_no;
		    nothing=0;
		    echo "does not exists";
		fi
	    done
	    echo "port_no and ${lport_num[$n]}";
	else
	    lport_status="use it (free port)";
	    sed -e "/${lport_name[$n]}/ s/=.*;/=${lport_num[$n]};/" -i  $file1/confs/deploy.conf
	    echo "-----------------${lport_name[$n]} is ${lport_num[$n]}--------------"
	fi
	
	source $file1/confs/deploy.conf
    done
done
#exit

n=0 ;
for (( n=1; n>=1; n++ ))
do
    #echo "name : $dock_con$n"   # Mrunal : Testing purpose
    echo " # docker ps -a | grep -w $dock_con$n  > /dev/null 2>&1" 
    sg docker -c "docker ps -a | grep -w $dock_con$n  > /dev/null 2>&1"  # Mrunal : No redirections here please
    if [[ $? != 0 ]]; then
	echo -e "\nInfo-msg : **Docker-container initialization** \n"  | sed -e "s/^/$(date +%Y%b%d-%I%M%S%p) $   /"  2>&1 | tee -a ${INSTALL_LOG_FILE}
	echo -e "\nInfo-msg : **Please wait for some time - approx 5 mins** \n"  | sed -e "s/^/$(date +%Y%b%d-%I%M%S%p) $   /"  2>&1 | tee -a ${INSTALL_LOG_FILE}
	echo " # docker run -it -d --restart=always  -v $hHOME/data:/data -v $hHOME/backups:/backups -v $hHOME/softwares:/softwares  -h $dock_hostname -p $port_ssh_host:$port_ssh_dock -p $port_smtp_host:$port_smtp_dock -p $port_http_host:$port_http_dock -p $port_django_dev_host:$port_django_dev_dock -p $port_mongo_host:$port_mongo_dock -p $port_smtp_test_host:$port_smtp_test_dock -p $port_imap_host:$port_imap_dock -p $port_smtps_host:$port_smtps_dock --name=$dock_con$n  $docker_repo:$docker_tag" # Mrunal: Testing purpose
	sg docker -c "docker run -it -d --restart=always  -v $hHOME/data:/data -v $hHOME/backups:/backups -v $hHOME/softwares:/softwares  -h $dock_hostname -p $port_ssh_host:$port_ssh_dock -p $port_smtp_host:$port_smtp_dock -p $port_http_host:$port_http_dock -p $port_django_dev_host:$port_django_dev_dock -p $port_mongo_host:$port_mongo_dock -p $port_smtp_test_host:$port_smtp_test_dock -p $port_imap_host:$port_imap_dock -p $port_smtps_host:$port_smtps_dock --name=$dock_con$n  $docker_repo:$docker_tag " ;

	if [[ $? -eq 0 ]]; then
	    # Docker-Container starting success
	    echo -e "Info-msg : Docker-container created and started successfully. " | sed -e "s/^/$(date +%Y%b%d-%I%M%S%p) $   /"  2>&1 | tee -a ${INSTALL_LOG_FILE}
	    break
	else
	    # Docker-Container creation Failed
	    echo -e "Caution-msg : Docker-container creation Failed. Please try again. (Error code : $?) \n" | sed -e "s/^/$(date +%Y%b%d-%I%M%S%p) $   /"  2>&1 | tee -a ${INSTALL_LOG_FILE}
	fi
	sleep 5m
	break
    fi
done

#docker ps -q --filter=image=gnowgi/gstudio  > /dev/null 2>&1   # Mrunal : No redirections here please
sg docker -c "docker ps | grep -w $dock_con$n  > /dev/null 2>&1" # Mrunal : No redirections here please
ip_address=`ifconfig eth0 | awk '/inet addr/{print substr($2,6)}'`
if [[ $? -eq 0 ]]; then
    # Installation completed
    echo -e "Info-msg : Installation complete successfully. Just enter your ipaddress:port ($ip_address:$port_http_host) in address bar of your internet browser." | sed -e "s/^/$(date +%Y%b%d-%I%M%S%p) $   /"  2>&1 | tee -a ${INSTALL_LOG_FILE}
else
    # Installation Failed
    echo -e "Caution-msg : Installation Failed. Please try again. \n" | sed -e "s/^/$(date +%Y%b%d-%I%M%S%p) $   /"  2>&1 | tee -a ${INSTALL_LOG_FILE}
fi

# ----------------------------- Shell file code ends here ------------------------------------------

}
