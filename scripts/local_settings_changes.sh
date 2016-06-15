#!/bin/bash

# Ref : http://stackoverflow.com/questions/17998763/sed-commenting-a-line-matching-a-specific-string-and-that-is-not-already-comme
#       http://unix.stackexchange.com/questions/89913/sed-ignore-line-starting-whitespace-for-match
#sed -e '/Used for postgres db/ s/^#*/#/' -i  $dHOME/confs/local_settings.py.default 

# Mrunal : Set dHOME variable in deploy.conf
file=`readlink -e -f $0`
file1=`echo $file | sed -e 's/\/scripts.*//'` ; 
file2=`echo $file1 | sed -e 's/\//\\\\\//g'` ;
#    file3=`echo $file1 | sed -e 's:/:\\\/:g'` ;
sed -e "/hHOME/ s/=.*;/=$file2;/" -i  $file1/confs/deploy.conf;
more $file1/confs/deploy.conf | grep hHOME; 


source $file1/confs/deploy.conf

dHOME="/home/docker/code"

OPTION="$1";
if [[ "$1" == "" ]]; then
    echo -e 'Please select the database for storing the users credentials: \n   1. sqlite \n   2. postgresql';
    read OPTION ;
fi
    
echo -e "USER input : $OPTION";
if [[ "$OPTION" == "" ]]; then
    echo "No input";
elif [[ "$OPTION" == "1" ]]; then
    echo "Used for sqlite db";
    sed -e '/Used for sqlite3 db/ s/^\s*#*//' -i  $hHOME/confs/local_settings.py.default; 
    sed -e '/Used for postgres db/ s/^\s*#*/#/' -i  $hHOME/confs/local_settings.py.default; 
    #sed -e '/Used for postgres db/ s/^\s*#*/#/' -i  $hHOME/scripts/initialize.sh;
    #sed -e '/echo[[:space:]]\+"psql*/,+7 s/^\s*#*/#/' -i $hHOME/scripts/initialize.sh;
#    sed -e '/echo[[:space:]]\+"psql*/,+7 s/^\s*#*/#/' -i scripts/initialize.sh;
#    sed -e '/echo[[:space:]]\+"from[[:space:]]\+django.contrib.auth.models[[:space:]]\+import[[:space:]]\+User*/,+3 s/^\s*#*//' -i scripts/initialize.sh ;
#    sed -e '/[[:space:]]\+User.objects.create_superuser*/ s/^\s*#*/    /' -i scripts/initialize.sh;
elif [[ "$OPTION" == "2" ]]; then
    echo "Used for postgres db";
    sed -e '/Used for sqlite3 db/ s/^\s*#*/#/' -i  $hHOME/confs/local_settings.py.default; 
    sed -e '/Used for postgres db/ s/^\s*#*/        /' -i  $hHOME/confs/local_settings.py.default; 
    #sed -e '/Used for postgres db/ s/^\s*#*/        /' -i  $hHOME/scripts/initialize.sh;
    #sed -e '/echo[[:space:]]\+"psql*/,+7 s/^\s*#*/        /' -i $hHOME/scripts/initialize.sh;
#    sed -e '/echo[[:space:]]\+"from[[:space:]]\+django.contrib.auth.models[[:space:]]\+import[[:space:]]\+User*/,+3 s/^\s*#*/#/' -i scripts/initialize.sh;
#    sed -e '/echo[[:space:]]\+"psql*/,+7 s/^\s*#*//' -i scripts/initialize.sh;
#    sed -e '/[[:space:]]\+User.objects.create_superuser*/ s/^\s*#*/#    /' -i scripts/initialize.sh;
else
    echo "Invalid input";
fi

# site_name="$2";
# if [[ "$2" == "" ]]; then
#     echo -e 'Please provide the site name of this instance (example clix):';
#     read site_name ;
# fi
    
# echo -e "USER input : $site_name";
# if [[ "$site_name" == "" ]]; then
#     echo "No input";
# elif [[ "$site_name" == "clix" ]]; then
#     echo "Used for clix";
#     sed -e '/GSTUDIO_SITE_NAME/ s/=*/= "clix"/' -i  $dHOME/confs/local_settings.py.default; 
#     sed -e '/GSTUDIO_SITE_LANDING_TEMPLATE/ s/^\s*#*//' -i  $dHOME/confs/local_settings.py.default; 
# elif [[ "$site_name" == "metastudio" ]]; then
#     echo "Used for metastudio";
#     sed -e '/GSTUDIO_SITE_NAME/ s/=*/= "$site_name"/' -i  $dHOME/confs/local_settings.py.default; 
#     sed -e '/GSTUDIO_SITE_LANDING_TEMPLATE/ s/^\s*#*/#/' -i  $dHOME/confs/local_settings.py.default; 
# else
#     echo "Invalid input";
# fi

exit;
