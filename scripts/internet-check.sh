#!/bin/bash
{
#--------------------------------------------------------------------------------------------------------------#
# File name   : internet-check.sh
# File creation : Mrunal Nachankar
# Description :
#               Check for internet connection
#               Build Docker-Image via docker build command (using Dockerfile)
#--------------------------------------------------------------------------------------------------------------#


# Mrunal : Set HOME variable in deploy.conf
file=`readlink -e -f $0`
file1=`echo $file | sed -e 's/\/scripts.*//'` ; 
file2=`echo $file1 | sed -e 's/\//\\\\\//g'` ;
#    file3=`echo $file1 | sed -e 's:/:\\\/:g'` ;
sed -e "/HOME/ s/=.*;/=$file2;/" -i  $file1/confs/deploy.conf;
#more $file1/confs/deploy.conf | grep HOME; 

source $file1/confs/deploy.conf

    INT_COM="";
    echo -e "\nWe are checking for Internet connection"  | sed -e "s/^/$(date +%Y%m%d-%H%M) $   /" 2>&1 | tee -a ${INSTALL_LOG_FILE}
    INT_COM=`ping www.google.com -c 5 | sed -e "s/^/$(date +%Y%b%d-%H%M) /"` 
#    echo -e "$INT_COM"  
    if [[ "$INT_COM" =~ bytes* ]]; then  # If internet connection is available
        _INT_COM=1
    else              # If no internet connection
        _INT_COM=0;
    fi
    
    echo -e "GET http://metastudio.org\n\n" | nc metastudio.org 80  > /dev/null 2>&1   # Mrunal : No redirections here please
    if [ $? -eq 0 ]; then               # If internet connection is available
        _META=1;
    else              # If no internet connection
        _META=0;
    fi
    
    echo -e "GET http://google.com HTTP/1.0\n\n" | nc google.com 80  > /dev/null 2>&1   # Mrunal : No redirections here please
    if [ $? -eq 0 ]; then               # If internet connection is available
        _GOOGLE=1;
    else              # If no internet connection
        _GOOGLE=0;    
    fi
    
#    echo -e "ping:$_INT_COM ; meta:$_META ; google:$_GOOGLE" 
    if ([ "$_INT_COM" == 0 ] && [ "$_META" == 0 ] && [ "$_GOOGLE" == 0 ]); then  # If no internet connection
        echo -e "\nInternet connection failed. Please check the network connections(IP, gateway, routes or physical cables)."  | sed -e "s/^/$(date +%Y%m%d-%H%M) $   /" 2>&1 | tee -a ${INSTALL_LOG_FILE}
	_INTERNET_STATUS=0;
	sed -e '/_INTERNET_STATUS/ s/=.*;/="0";/' -i  $HOME/confs/deploy.conf; 
    else              # If internet connection is available
        echo -e "\nInternet connection Successful."  | sed -e "s/^/$(date +%Y%m%d-%H%M) $   /" 2>&1 | tee -a ${INSTALL_LOG_FILE}
        echo -e "Hence we will continue with online installation."  | sed -e "s/^/$(date +%Y%m%d-%H%M) $   /" 2>&1 | tee -a ${INSTALL_LOG_FILE}
	_INTERNET_STATUS=1;
	sed -e '/_INTERNET_STATUS/ s/=.*;/="1";/' -i  $HOME/confs/deploy.conf; 
    fi
}
