#!/bin/bash

# touch /tmp/gstudio-20160118-1822.tar.bz2 /tmp/gstudio-20160119-1822.tar.bz2 /tmp/gstudio-20160120-1822.tar.bz2 /tmp/gstudio-20160121-1822.tar.bz2 /tmp/gstudio-20160122-1822.tar.bz2 /tmp/gstudio-20160123-1822.tar.bz2 /tmp/gstudio-20160124-1822.tar.bz2 /tmp/gstudio-20160125-1822.tar.bz2 /tmp/gstudio-20160126-1822.tar.bz2 /tmp/gstudio-20160127-1820.tar.bz2 /tmp/gstudio-20160127-1822.tar.bz2 /tmp/gstudio-20160128-1820.tar.bz2 /tmp/gstudio-20160129-1820.tar.bz2 /tmp/gstudio-20160129-1822.tar.bz2

FILE_NAMES=( `ls /tmp/gstudio-*.tar.bz2 ` );
DateTime_STAMP=$(date +%Y%m%d);
#echo "File names are: ${FILE_NAMES[@]} and Timestamp: $DateTime_STAMP";
((DateTime_STAMP1 = DateTime_STAMP - 3));      # : Today' s timestamp - No of days 
echo "Today' s Timestamp: $DateTime_STAMP and keep files between : $DateTime_STAMP and $DateTime_STAMP1";

# : Extract datetime-timestamp and create an array
declare -a DT_FILE_NAMES=();
for i in "${FILE_NAMES[@]}";
do
#    echo "i = $i"; # : Testing purpose printing
    SUB=$(echo "$i" | cut -d'-' -f 2 );
    DT_FILE_NAMES=( "${DT_FILE_NAMES[@]}" "$SUB" );
done


#echo "Substring : ${DT_FILE_NAMES[@]}"; # : Testing purpose printing
#echo "array : Len of array ${#FILE_NAMES[@]} : Len of first ${#FILE_NAMES} : Array ${FILE_NAMES[@]}"; # : Testing purpose printing
#echo "array : Len of array ${#DT_FILE_NAMES[@]} : Len of first ${#DT_FILE_NAMES} : Array ${DT_FILE_NAMES[@]}"; # : Testing purpose printing

# : Remove element from array for deletion and create a new / final array for deletion of files
for i in "${DT_FILE_NAMES[@]}";
do
#    echo "i = $i"; # : Testing purpose printing
    if [ $i -gt $DateTime_STAMP1 ]; then
	FILE_NAMES=(${FILE_NAMES[@]/*$i*/} );
#	echo "New array of deletion: ${FILE_NAMES[@]}";
#	echo "Remove element from array for deletion"; # : Testing purpose printing
#    else
#	echo "No action"; # : Testing purpose printing
    fi
done

# : Final printing
echo "File names selected for deletion: ${FILE_NAMES[@]}"
echo "File names before deletion :" && ls /tmp/gstudio-*.tar.bz2 
rm -rf "${FILE_NAMES[@]}";
echo "File names after deletion :" && ls /tmp/gstudio-*.tar.bz2 
echo "Here:"
ls /tmp/*$(date +%Y)*
