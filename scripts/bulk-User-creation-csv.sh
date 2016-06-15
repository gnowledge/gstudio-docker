#!/bin/bash



# Mrunal : Set HOME variable in deploy.conf
file=`readlink -e -f $0`
file1=`echo $file | sed -e 's/\/scripts.*//'` ; 
file2=`echo $file1 | sed -e 's/\//\\\\\//g'` ;
#    file3=`echo $file1 | sed -e 's:/:\\\/:g'` ;
sed -e "/HOME/ s/=.*;/=$file2;/" -i  $file1/confs/deploy.conf;
more $file1/confs/deploy.conf | grep HOME; 


source $file1/confs/deploy.conf

OPTION="$1";
if [[ "$1" == "" ]]; then
    echo -e 'Please select the type of the users credentials: \n   1. students \n   2. teachers \n';
    read OPTION ;
fi
    
echo -e "USER input : $OPTION";
if [[ "$OPTION" == "" ]]; then
    echo "No input";
    exit
elif [[ "$OPTION" == "1" ]]; then
    echo -e "\nGenerating student details";
    OPTION="students";
elif [[ "$OPTION" == "2" ]]; then
    echo -e "\nGenerating teachers details";
    OPTION="teachers";
else
    echo "Invalid input";
    exit
fi

# Mrunal : 20160131-2130 : Take user input as School id (small letter of initials of state and school no in 3 digit)
echo "Please provide the id of School" ;
echo "(For example Rajasthan state and school 001 'r001' must be entered and hit Enter key of Keyboard){if need for all school please leave it empty}" ;
read sch_id_i ;
echo "School id entered is $sch_id_i" ;

# Max no of school as per states
cl=200;  # chhattisgarh
ml=50;   # mizoram
rl=300;  # rajasthan
sl=150;  # special interest ( for GNs , testing and clixs team use)
tl=300;  # telangana

# Mrunal : 20160131-2130 : 
if [[ "${sch_id_i}" =~ ^[ct,mz,rj,tg,sp]{2}[0-9]{1}$ ]] || [[ "${sch_id_i}" =~ ^[ct,mz,rj,tg,sp]{2}[0-9]{2}$ ]] || [[ "${sch_id_i}" =~ ^[ct,mz,rj,tg,sp]{2}[0-9]{3}$ ]] || [[ "${sch_id_i}" = "" ]]; then
    echo "School id matches the criteria. Continuing the process." ;
else
    echo "School id doesn't match the criteria. Hence exiting please restart / re-run the script again." ;
    exit;
fi

for (( states=1; states<5; states++ ));
do
    
    if [[ $states == 1 ]] && [[ "$sch_id_i" != "" ]]; then
     	sch_id="$sch_id_i";
	numl=2;
    elif [[ $states == 2 ]] && [[ "$sch_id_i" != "" ]]; then
     	exit;
    elif [[ $states == 1 ]]; then
	numl=$cl ;
	stat="ct";
    elif [[ $states == 2 ]]; then
	numl=$ml ;
	stat="mz";
    elif [[ $states == 3 ]]; then
	numl=$rl ;
	stat="rj";
    elif [[ $states == 4 ]]; then
	numl=$tl ;
	stat="tg";
    elif [[ $states == 5 ]]; then
	numl=$sl ;
	stat="sp";
    fi
    
    for (( num=0; num<$numl; num++ ));
    do
	# Mrunal : 20160131-2130 : Take username and password from file and add the user. (username as "username from file"-"school id") 
	#[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
	INPUT_FILE="${OPTION}-credentials-input.csv" ;
	IFS=',' ;
	Color=();
	Animal=();
	if [[ "$sch_id_i" == "" ]]; then
#	    sch_id="$stat$(printf "%03d" $num)";
	    sch_id="$stat$num";
	fi
	i=0 ;

	while read Col1 ;
	do
	    Col1=${Col1// };             #remove leading spaces
	    Col1=${Col1%% };             #remove trailing spaces
	    if [[ "${Col1}" != "" ]]; then
		Color[$i]=$Col1;
#		echo "Color - ${Color[$i]}" ;
	    fi
	    i=$((i+1))
#	    echo "i is ${i}"
	done < $INPUT_FILE
	
#	echo "Color : ${Color[@]} :"
	i=0;
	for (( c=0; c<${#Color[@]}; c++ ));
	do
		Uname="${Color[$c]}-$sch_id";
		echo "Username-${i} - $Uname" ;
		UPass=$(bash $HOME/scripts/gen-rand-passwd.sh);
		echo "Password - $UPass" ;
		if [ ! -d $HOME/user-details ]; then
		    mkdir $HOME/user-details;
		    echo "$HOME/user-details"
		fi
		echo "$sch_id;$Uname;$UPass" >> $HOME/user-details/$sch_id-$OPTION-details.csv;
		if [[ "$sch_id_i" == "" ]]; then
		    echo "$sch_id;$Uname;$UPass" >> $HOME/user-details/all-$OPTION-details.csv;
		fi
		# 	echo "[run] create superuser $1" ;
		# 	echo "from django.contrib.auth.models import User ;
		# if not User.objects.filter(username='$Uname').count():
		#     User.objects.create_user('$Uname', '', '$UPass')                                                                   
		# " | python manage.py shell
		i=$((i+1))
	    done
	done
    done
done    
exit ;
    
