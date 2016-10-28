#!/bin/bash

# dirname_in is used to store input dir name
#dirname_in="/media/glab/d23792a7-c7d6-40db-b712-0e80d0678b761/MStore/RnD/testbase" ;                       # Mrunal changes are here : Change the source directory
dirname_in="/data" ;                       # Mrunal changes are here : Change the source directory

# dirname_out_default is used to store default output dir name
dirname_out_default="/backups/" ;          # Mrunal changes are here : Change the default directory

# dirname_out is used to store output dir name
dirname_out="$1" ;                         # Mrunal changes are here : Change the destination directory (default it is set to 1stargument value)

#State id limits as a default start is set to 1 and end is set to 100 (means for mizoram its mz1 to mz100)
currnet_state_nm_start=1;                  # Mrunal changes are here : starting state id
currnet_state_nm_end=100;                  # Mrunal changes are here : ending state id

# Following variables are used to store the color codes for displaying the content on terminal
red="\033[0;91m" ;
green="\033[0;32m" ;
brown="\033[0;33m" ;
blue="\033[0;34m" ;
cyan="\033[0;36m" ;
reset="\033[0m" ;

echo -e "" ;

create_symlink(){

for selected_file in `find $dirname_in -type f`; do
    
    dirname_selected_file=$(dirname ${selected_file});
    last_dirname_in=$(dirname $dirname_in);
    
    dirstructure=${dirname_selected_file#$dirname_in};
    
    Final_output_dirname_selected_file="$1${dirstructure}"
	
    $(mkdir -p $Final_output_dirname_selected_file);

    echo -e "Symlinking : \nSource - ${selected_file} \nDestination - ${Final_output_dirname_selected_file} \n"
    ln -s ${selected_file} ${Final_output_dirname_selected_file}

done

}

# Checking - Validations
err_msg="Usage: ";
echo -e "Input filename is '$dirname_in'. \n";

# Check for input (dirname_in)
if [[ $dirname_in == "" ]] ; then
    echo -e "${red}Please specify the Input dir name(Full path). ${reset}\n" ;
    msg="${red}Please set the Input dir name(Full path) {Name of the orignal source directory - variable name in the file is 'dirname_in'} . ${reset}\n"
    error=1 ;
    exit
fi

# Check for output (dirname_out)
if [[ $1 == "" ]] ; then

    echo -e "${red}Please specify the Output dir name(Full path). ${reset}\n" ;
    msg="\n${red}Please specify the Output dir name(Full path) {variable name should be passed as an argument while executing the file} . ${reset}\n"
    error=1 ;
    exit

elif [[ $1 != "" ]] ; then

    if [[ -d "$1" ]] ; then

        echo -e "${red}Output dir name(Full path) exist. Hence continuing process.${reset}\n" ;
        
    else

        echo -e "${red}Output dir name(Full path) does not exist. Hence creating it.${reset}\n" ;
        mkdir -p $1

    fi
fi

# Print usage incase of invalid inputs
if [[ $error == 1 ]] ; then
    echo -e "${red}${msg}${reset}" ;
    error=0 ;
    exit ;
fi

# Creation logical conditions
if [[ "$1" != "" ]] && [[ "$2" == "mz" ]] ; then

	state_nm="mz" ;
	max_server_state_limit=5;
	currnet_state_nm=0;
	for currnet_state_nm in `seq $currnet_state_nm_start $currnet_state_nm_end`;
	do
	    create_symlink $dirname_out_default$state_nm$currnet_state_nm ;
	    echo "Name: $dirname_out_default$state_nm$currnet_state_nm";
	done

elif [[ "$1" != "" ]] && [[ "$2" == "rj" ]] ; then

    state_nm="rj" ;
    max_server_state_limit=5;
    currnet_state_nm=0;
    for currnet_state_nm in `seq $currnet_state_nm_start $currnet_state_nm_end`;
    do
        create_symlink $dirname_out_default$state_nm$currnet_state_nm ;
        echo "Name: $dirname_out_default$state_nm$currnet_state_nm";
    done

elif [[ "$1" != "" ]] && [[ "$2" == "ct" ]] ; then

    state_nm="ct" ;
    max_server_state_limit=5;
    currnet_state_nm=0;
    for currnet_state_nm in `seq $currnet_state_nm_start $currnet_state_nm_end`;
    do
        create_symlink $dirname_out_default$state_nm$currnet_state_nm ;
        echo "Name: $dirname_out_default$state_nm$currnet_state_nm";
    done

elif [[ "$1" != "" ]] && [[ "$2" == "tg" ]] ; then

    state_nm="tg" ;
    max_server_state_limit=5;
    currnet_state_nm=0;
    for currnet_state_nm in `seq $currnet_state_nm_start $currnet_state_nm_end`;
    do
        create_symlink $dirname_out_default$state_nm$currnet_state_nm ;
        echo "Name: $dirname_out_default$state_nm$currnet_state_nm";
    done

elif [[ "$1" != "" ]] && [[ "$2" == "sp" ]] ; then

    state_nm="sp" ;
    max_server_state_limit=5;
    currnet_state_nm=0;
    for currnet_state_nm in `seq $currnet_state_nm_start $currnet_state_nm_end`;
    do
        create_symlink $dirname_out_default$state_nm$currnet_state_nm ;
        echo "Name: $dirname_out_default$state_nm$currnet_state_nm";
    done

fi
