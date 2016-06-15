#!/bin/bash

dHOME="/home/docker/code";

# Mrunal : 20160131-2130 : Take user input as School id (small letter of initials of state and school no in 3 digit)
if [[ $1 == "" ]]; then
    echo "Please provide the user details file name." ;
    echo "(For example Rajasthan state and school 001 'r001-user-details' must be the default file name and hit Enter key of Keyboard)" ;
    read INPUT_FILE ;
else
    INPUT_FILE=$1;
fi

echo "File name entered is $INPUT_FILE ." ;

filename=$(basename "$INPUT_FILE")
extension="${filename##*.}"
filename1="${filename%.*}"
#echo ":$filename:$extension:$filename1:$INPUT_FILE:    $dHOME/user-details/${INPUT_FILE}";

if [[ "${INPUT_FILE}" == "${filename}" ]]; then
    if [[ -f "$dHOME/user-details/${INPUT_FILE}" ]]; then
	INPUT_FILE="$dHOME/user-details/${INPUT_FILE}"
    fi
fi
#echo  "\nNow filename : ${INPUT_FILE}"

# Mrunal : 20160131-2130 : 
if [[ "${INPUT_FILE}" == "" ]] ; then
    echo "No input. Hence exiting please restart / re-run the script again." ;
    exit ;
elif [[ ! -f "${INPUT_FILE}" ]]; then
    echo "File ${INPUT_FILE} does not exists. Hence exiting please restart / re-run the script again." ;
    exit ;
elif [[ "${extension}" != csv ]]; then
    echo "Only csv file can be used to create new users. Hence exiting please restart / re-run the script again." ;
    exit ;
else
    echo "File ${INPUT_FILE} exists. Continuing the process." ;
fi

# Mrunal : 20160131-2130 : Take username and password from file and add the user. (username as "username from file"-"school id") 
#INPUT_FILE='Users.csv' ;
IFS=';' ;
i=1 ;
while read sch_id Uname UPass ;
do

    echo "Name - $Uname" ;
    echo "Password - $UPass" ;
    
    cd $dHOME/gstudio/gnowsys-ndf/

    echo "[run] create superuser $Uname" ;
    echo "from django.contrib.auth.models import User ;
if not User.objects.filter(username='$Uname').count():
    User.objects.create_user('$Uname', '', '$UPass')                                                                   
" | python manage.py shell
    
    if [[ $? == "0" ]]; then
	echo "User : $Uname and Password : $UPass created successfully in the database" 2&1 >> Bulk-User-creation-database.logs
    fi
    i=$((i+1))

done < $INPUT_FILE

exit ;
