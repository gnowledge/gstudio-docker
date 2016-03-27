#!/bin/bash

# Mrunal : 20160131-2130 : Take user input as School id (small letter of initials of state and school no in 3 digit)
echo "Please provide the id of School" ;
echo "(For example Rajasthan state and school 001 'r001' must be entered and hit Enter key of Keyboard)" ;
read sch_id ;
echo "School id entered is $sch_id" ;

# Mrunal : 20160131-2130 : 
if [[ "${sch_id}" =~ [a-z]{1}[0-9]{3} ]]; then
    echo "School id doesn't match the criteria. Hence exiting please restart / re-run the script again." ;
    exit ;
else
    echo "School id matches the criteria. Continuing the process." ;
fi

# Mrunal : 20160131-2130 : Take username and password from file and add the user. (username as "username from file"-"school id") 
INPUT_FILE='Users.csv' ;
IFS=',' ;
while read Uname UPass ;
do

    i=1 ;
    echo "Name - $Uname-$sch_id" ;
    echo "Password - $UPass" ;
    
    echo "[run] create superuser $1" ;
    echo "from django.contrib.auth.models import User ;
if not User.objects.filter(username='$Uname').count():
    User.objects.create_user('$Uname', '', '$UPass')                                                                   
" | python manage.py shell

    i=i+1 ;

done < $INPUT_FILE

exit ;
