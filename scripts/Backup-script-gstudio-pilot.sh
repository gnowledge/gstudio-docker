#!/bin/bash


#--------------------------------------------------------------------#
# Backup of gstudio 
# File name    : Backup-script-mrunal.sh
# File version : 1.0
# Created by   : Mr. Mrunal M. Nachankar
# Created on   : 26-06-2014 12:04:AM
# Modified by  : None
# Modified on  : Not yet
# Description  : This file is used for taking backup of gstudio
#                1. Check for backup directory - If don't exist please create the same.
#					1.1	Backup directory : /home/glab/rcs-db-backup/<yyyy-mm-dd> i.e for 26th June 2015 it will be "/home/glab/rcs-db-backup/2015-06-26"
#					1.2 In backup directory we will have 2 sub directories "rcs" for rcs repo backup and "mongodb" for mongodb database backup (mongodb dump)
#				 2. Take backup of rcs via cp (copy -rv) command
#				 3. Take backup of mongodb via mongodbdump command
#				 4. Create a compressed file (TAR File - tar.bz2)
#				 5. Optional - Move the backup directory to /tmp/ after successful creation of tar.bz2 file
#--------------------------------------------------------------------#

#--------------------------------------------------------------------#
# Setup log directories and Log files. 
#--------------------------------------------------------------------#
ulimit -c unlimited

# Mrunal : 26-06-2014 12:04:AM : Log file / details related variables
LOG_DIR="$HOME/Backup/LOGS/";
DateTime_STAMP=$(date +%Y%m%d-%H%M%S)
BACKUP_LOG_FILE="$HOME/Backup/LOGS/backup-$DateTime_STAMP.log"; # Mrunal : 26-06-2014 12:04:AM : used for redirecting Standard_output(Normal msg)
ERROR_LOG_FILE="$HOME/Backup/LOGS/error-$DateTime_STAMP.log"; # Mrunal : 26-06-2014 12:04:AM : used for redirecting Standard_error(Error msg)
appd_date="| sed -e ""s/^/$(date -R) /";    # Mrunal : 26-06-2014 12:04:AM : Used for appending date at the satrting of the line in the log file

# Mrunal : 26-06-2014 12:04:AM : Backup related variables
BACKUP_DIR="$HOME/Backup/$DateTime_STAMP"  # Mrunal : 26-06-2014 12:04:AM : Used for Backup directory (full path) 
#BACKUP_DIR_NAME=${BACKUP_DIR#"/"}  # Mrunal : 26-06-2014 12:04:AM : Used for Backup directory (Just name) 
BACKUP_DIR_NAME=$DateTime_STAMP # Mrunal : 26-06-2014 12:04:AM : Used for Backup directory (Just name) 
RCS_REPO_SOURCE_PATH="/home/docker/code/gstudio/gnowsys-ndf/gnowsys_ndf/ndf/rcs-repo"  # Mrunal : 26-06-2014 12:04:AM : Used for RCS Repo source directory (full path)

DATABASE_NAME="meta-mongodb"  # Mrunal : 26-06-2014 12:04:AM : Used for Database name of mongodb

SQLITE_SOURCE_PATH="/home/docker/code/gstudio/gnowsys-ndf/"  # Mrunal : 26-06-2014 12:04:AM : Used for RCS Repo source directory (full path)
SQLITE_SOURCE_NAME="example-sqlite3.db"  # Mrunal : 26-06-2014 12:04:AM : Used for RCS Repo source directory (full path)

TAR_FILE_NAME="gstudio-$DateTime_STAMP" # Mrunal : 26-06-2014 12:04:AM : used for creating tar file
#TAR_FILE_NAME="${TAR_FILE_NAME:1:${#TAR_FILE_NAME}-1}"

#--------------------------------------------------------------------#
# Check Directory...
#	If directory is present : Display messages
#	If directory is not present : create and display messages
#--------------------------------------------------------------------#

check_dir () {
    if [ -d $1 ]; then
	echo "$1 directory is already present."  # Mrunal : 26-06-2014 12:04:AM 
	echo "$1 directory is already present."  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 
	echo "";  # Mrunal : 26-06-2014 12:04:AM
	echo "" | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE} # Mrunal : 26-06-2014 12:04:AM 
    else
	# Mrunal : 26-06-2014 12:04:AM : Check the existence of the directory
	if [ $1 == $LOG_DIR ]; then
	    echo "mkdir -p $1"   # Mrunal : 26-06-2014 12:04:AM : Log printing exempted as it is creating LOG directory
	    `mkdir -p $1`  # Mrunal : 26-06-2014 12:04:AM : Create LOG directory
	else
	    echo "mkdir -p $1"  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 
	    `mkdir -p $1`  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 
	    echo ""  # Mrunal : 26-06-2014 12:04:AM  
	    echo "" | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 
	fi
	echo "$1 directory is now been created."   # Mrunal : 26-06-2014 12:04:AM 
	echo "$1 directory is now been created."  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 
	echo ""  # Mrunal : 26-06-2014 12:04:AM 
	echo "" | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}   # Mrunal : 26-06-2014 12:04:AM 
    fi
}

#--------------------------------------------------------------------#
# Backup Script execution starts from here..
#--------------------------------------------------------------------#

#################   BACKUP STARTS FROM HERE  #######################

# To check LOG directory and files (If directory is not created do create it with function)
#    Here check_dir is the function and $LOG_DIR is dirctory full path variable defined earlier

check_dir $LOG_DIR  # Mrunal : 26-06-2014 12:04:AM : Calling check_dir function to check LOG directory existence

echo "++++++++++++++++++++++++++ Backup - Started +++++++++++++++++++++++++++++++++"  # Mrunal : 26-06-2014 12:04:AM 
echo "++++++++++++++++++++++++++ Backup - Started +++++++++++++++++++++++++++++++++"  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 
echo ""  # Mrunal : 26-06-2014 12:04:AM 
echo "" | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 

#------------------------------------------------------------------------------

echo ""  # Mrunal : 26-06-2014 12:04:AM 
echo "" | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 

echo "Creating the backup directory"  # Mrunal : 26-06-2014 12:04:AM 
echo "Creating the backup directory"  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 

echo ""  # Mrunal : 26-06-2014 12:04:AM 
echo "" | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 

check_dir "$BACKUP_DIR"  # Mrunal : 26-06-2014 12:04:AM 

#------------------------------------------------------------------------------

echo ""  # Mrunal : 26-06-2014 12:04:AM 
echo "" | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 

echo "Backup of RCS-Repo started"  # Mrunal : 26-06-2014 12:04:AM 
echo "Backup of RCS-Repo started"  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 

echo ""  # Mrunal : 26-06-2014 12:04:AM 
echo ""  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 

check_dir "$BACKUP_DIR"  # Mrunal : 26-06-2014 12:04:AM 

echo "cp -rv $RCS_REPO_SOURCE_PATH $BACKUP_DIR/"  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 
cp -rv $RCS_REPO_SOURCE_PATH $BACKUP_DIR/  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 

if [ "$?" != "0" ]; then
	echo "Backup (RCS) - Failed. Seems like the source path doesn't exists";  # Mrunal : 26-06-2014 12:04:AM 
	echo "Backup (RCS) - Failed. Seems like the source path doesn't exists"  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE} ; # Mrunal : 26-06-2014 12:04:AM 
else
	echo "Backup (RCS) - Successfully completed. ";  # Mrunal : 26-06-2014 12:04:AM 
	echo "Backup (RCS) - Successfully completed. "  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE} ;  # Mrunal : 26-06-2014 12:04:AM 
#	exit 1; 

	# Mrunal : 26-06-2014 12:04:AM : Size
	echo "Size of $RCS_REPO_SOURCE_PATH : "  # Mrunal : 26-06-2014 12:04:AM 
	echo "Size of $RCS_REPO_SOURCE_PATH : "  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 

#	echo "du -hs $RCS_REPO_SOURCE_PATH | awk '{ print $1 }'"  # Mrunal : 26-06-2014 12:04:AM 
	du -hs $RCS_REPO_SOURCE_PATH | awk '{ print $1 }'
	du -hs $RCS_REPO_SOURCE_PATH | awk '{ print $1 }'  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 

	echo ""  # Mrunal : 26-06-2014 12:04:AM 
	echo ""  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 
	
	echo "Size of $BACKUP_DIR/rcs-repo/ : "  # Mrunal : 26-06-2014 12:04:AM 
	echo "Size of $BACKUP_DIR/rcs-repo/ : "  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 

#	echo "du -hs $BACKUP_DIR/rcs | awk '{ print $1 }'"  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 
	du -hs $BACKUP_DIR/rcs-repo/ | awk '{ print $1 }'
	du -hs $BACKUP_DIR/rcs-repo/ | awk '{ print $1 }' | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 

	echo ""  # Mrunal : 26-06-2014 12:04:AM 
	echo ""  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrun| awk '{ print $1 }'al : 26-06-2014 12:04:AM 

	
	# Mrunal : 26-06-2014 12:04:AM : No of directories
	
	echo ""  # Mrunal : 26-06-2014 12:04:AM 
	echo ""  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 
	
	echo "No of directories in $RCS_REPO_SOURCE_PATH : "  # Mrunal : 26-06-2014 12:04:AM 
	echo "No of directories in $RCS_REPO_SOURCE_PATH : "  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 

#	echo "find $RCS_REPO_SOURCE_PATH -type d | wc -l "  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 
	find $RCS_REPO_SOURCE_PATH -type d | wc -l
	find $RCS_REPO_SOURCE_PATH -type d | wc -l   | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 

	echo ""  # Mrunal : 26-06-2014 12:04:AM 
	echo ""  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 
	
	echo "No of directories in $BACKUP_DIR/rcs/ : "  # Mrunal : 26-06-2014 12:04:AM 
	echo "No of directories in $BACKUP_DIR/rcs/ : "  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 

#	echo "find $BACKUP_DIR/rcs-repo/ -type d | wc -l "  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 
	find $BACKUP_DIR/rcs-repo/ -type d | wc -l
	find $BACKUP_DIR/rcs-repo/ -type d | wc -l   | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 
	
	echo ""  # Mrunal : 26-06-2014 12:04:AM 
	echo ""  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 

	# Mrunal : 26-06-2014 12:04:AM : No of files
	
	echo ""  # Mrunal : 26-06-2014 12:04:AM 
	echo ""  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 

	echo "No of files in $RCS_REPO_SOURCE_PATH : "  # Mrunal : 26-06-2014 12:04:AM 
	echo "No of files in $RCS_REPO_SOURCE_PATH : "  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 

#	echo "find $RCS_REPO_SOURCE_PATH -type f | wc -l "  # Mrunal : 26-06-2014 12:04:AM 
	find $RCS_REPO_SOURCE_PATH -type d | wc -l   
	find $RCS_REPO_SOURCE_PATH -type d | wc -l  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 

	echo ""  # Mrunal : 26-06-2014 12:04:AM 
	echo ""  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 
	
	echo "No of files in $BACKUP_DIR/rcs-repo/ : "  # Mrunal : 26-06-2014 12:04:AM 
	echo "No of files in $BACKUP_DIR/rcs-repo/ : "  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 

#	echo "find $BACKUP_DIR/rcs-repo/ -type f | wc -l "  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 
	find $BACKUP_DIR/rcs-repo/ -type f | wc -l   
	find $BACKUP_DIR/rcs-repo/ -type f | wc -l   | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 
	
	echo ""  # Mrunal : 26-06-2014 12:04:AM 
	echo ""  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 

fi

#------------------------------------------------------------------------------

echo ""  # Mrunal : 26-06-2014 12:04:AM 
echo ""| sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 

echo "Backup of mongodb started"  # Mrunal : 26-06-2014 12:04:AM 
echo "Backup of mongodb started"  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 

echo ""  # Mrunal : 26-06-2014 12:04:AM 
echo ""  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 

check_dir "$BACKUP_DIR/mongodb"  # Mrunal : 26-06-2014 12:04:AM 

echo ""  # Mrunal : 26-06-2014 12:04:AM 
echo ""  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 

# echo "pwd"  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 
# echo "pwd:" & pwd

# echo ""  # Mrunal : 26-06-2014 12:04:AM 
# echo ""  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 

echo "cd $BACKUP_DIR/mongodb"  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 
echo "cd $BACKUP_DIR/mongodb"
cd $BACKUP_DIR/mongodb

echo ""  # Mrunal : 26-06-2014 12:04:AM 
echo ""  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 

echo "mongodump -d $DATABASE_NAME"  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 
mongodump -d "$DATABASE_NAME"  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 

if [ "$?" == "0" ]; then
	echo "Backup (Mongodb) - Successfully completed. ";  # Mrunal : 26-06-2014 12:04:AM 
	echo "Backup (Mongodb) - Successfully completed. "  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE} ;  # Mrunal : 26-06-2014 12:04:AM 
	#exit 1; 
else
	echo "Backup (Mongodb) - Failed. Seems like the database with the name doesn't exists";  # Mrunal : 26-06-2014 12:04:AM 
	echo "Backup (Mongodb) - Failed. Seems like the database with the name doesn't exists"  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE} ;  # Mrunal : 26-06-2014 12:04:AM 
fi

echo ""  # Mrunal : 26-06-2014 12:04:AM 
echo ""  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 

# Mrunal : 26-06-2014 12:04:AM : Size
echo "Size of $BACKUP_DIR/mongodb/ : "  # Mrunal : 26-06-2014 12:04:AM 
echo "Size of $BACKUP_DIR/mongodb/ : "  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 

#	echo "du -hs $BACKUP_DIR/mongodb/ | awk '{ print $1 }'"  # Mrunal : 26-06-2014 12:04:AM 
du -hs $BACKUP_DIR/mongodb/ | awk '{ print $1 }'
du -hs $BACKUP_DIR/mongodb/ | awk '{ print $1 }'  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 

echo ""  # Mrunal : 26-06-2014 12:04:AM 
echo ""  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 
	

#------------------------------------------------------------------------------

echo ""  # Mrunal : 26-06-2014 12:04:AM 
echo "" | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 

echo "Backup of sqlite(example-sqlite) started"  # Mrunal : 26-06-2014 12:04:AM 
echo "Backup of sqlite(example-sqlite) started"  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 

echo ""  # Mrunal : 26-06-2014 12:04:AM 
echo ""  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 

check_dir "$BACKUP_DIR"  # Mrunal : 26-06-2014 12:04:AM 

echo "cp -rv $SQLITE_SOURCE_PATH$SQLITE_SOURCE_NAME $BACKUP_DIR/"  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 
cp -rv $SQLITE_SOURCE_PATH$SQLITE_SOURCE_NAME $BACKUP_DIR/  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 

if [ "$?" == "0" ]; then
	echo "Backup (SQLITE) - Successfully completed. ";  # Mrunal : 26-06-2014 12:04:AM 
	echo "Backup (SQLITE) - Successfully completed. "  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE} ;  # Mrunal : 26-06-2014 12:04:AM 
#	exit 1; 
else
	echo "Backup (SQLITE) - Failed. Seems like the source path doesn't exists";  # Mrunal : 26-06-2014 12:04:AM 
	echo "Backup (SQLITE) - Failed. Seems like the source path doesn't exists"  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE} ; # Mrunal : 26-06-2014 12:04:AM 
fi

# Mrunal : 26-06-2014 12:04:AM : Size
echo "Size of $SQLITE_SOURCE_PATH/$SQLITE_SOURCE_NAME : "  # Mrunal : 26-06-2014 12:04:AM 
echo "Size of $SQLITE_SOURCE_PATH/$SQLITE_SOURCE_NAME : "  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 

#	echo "du -hs $SQLITE_SOURCE_NAME | awk '{ print $1 }'"  # Mrunal : 26-06-2014 12:04:AM 
du -hs "$SQLITE_SOURCE_PATH/$SQLITE_SOURCE_NAME" | awk '{ print $1 }'
du -hs "$SQLITE_SOURCE_PATH/$SQLITE_SOURCE_NAME" | awk '{ print $1 }'  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 

echo ""  # Mrunal : 26-06-2014 12:04:AM 
echo ""  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 
	
echo "Size of $BACKUP_DIR/$SQLITE_SOURCE_NAME : "  # Mrunal : 26-06-2014 12:04:AM 
echo "Size of $BACKUP_DIR/$SQLITE_SOURCE_NAME : "  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 

#	echo "du -hs $BACKUP_DIR/rcs | awk '{ print $1 }'"  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 
du -hs $BACKUP_DIR/$SQLITE_SOURCE_NAME | awk '{ print $1 }'
du -hs $BACKUP_DIR/$SQLITE_SOURCE_NAME | awk '{ print $1 }' | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 

#------------------------------------------------------------------------------

echo ""  # Mrunal : 26-06-2014 12:04:AM 
echo ""| sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 

echo "Compression of Backup started"  # Mrunal : 26-06-2014 12:04:AM 
echo "Compression of Backup started"  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 

echo ""  # Mrunal : 26-06-2014 12:04:AM 
echo ""  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 


# Mrunal : 26-06-2014 12:04:AM : creating a tar.bz2 file of the backup


echo ""  # Mrunal : 26-06-2014 12:04:AM 
echo ""  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 

echo "cd $BACKUP_DIR"  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 
echo "cd $BACKUP_DIR"
cd $BACKUP_DIR

echo ""  # Mrunal : 26-06-2014 12:04:AM 
echo ""  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 

echo "cd ../"  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 
echo "cd ../"
cd ../

echo ""  # Mrunal : 26-06-2014 12:04:AM 
echo ""  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 

echo "tar -cvjf $TAR_FILE_NAME.tar.bz2 $BACKUP_DIR_NAME"  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 
tar cvjf $TAR_FILE_NAME.tar.bz2  $BACKUP_DIR_NAME  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 
	
if [[ "$?" == "0" ]]; then
	echo "Compression of Backup - Successfully completed. ";  # Mrunal : 26-06-2014 12:04:AM 
	echo "Compression of Backup - Successfully completed. "  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE} ;  # Mrunal : 26-06-2014 12:04:AM 

	# Mrunal :26-06-2014 12:04:AM : Moving the dated backup directory to /tmp as tarball has been created successfully & later remove the same. 
	mv -v $BACKUP_DIR/rcs /tmp/  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 
	rm -rf /tmp/$BACKUP_DIR  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 13-12-2014 12:04:AM 

else
        echo  "$?";
	echo "Compression of Backup - Failed. Ooops seems like some issue, please check logs for more details.";  # Mrunal : 26-06-2014 12:04:AM 
	echo "Compression of Backup - Failed. Ooops seems like some issue, please check logs for more details."  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE} ;  # Mrunal : 26-06-2014 12:04:AM 
	#exit 1; 
fi

echo ""  # Mrunal : 26-06-2014 12:04:AM 
echo "" | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 


echo ""  # Mrunal : 26-06-2014 12:04:AM 
echo "" | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 

echo "++++++++++++++++++++++++++ Backup - Ended +++++++++++++++++++++++++++++++++"  # Mrunal : 26-06-2014 12:04:AM 
echo "++++++++++++++++++++++++++ Backup - Ended +++++++++++++++++++++++++++++++++"  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 


echo
echo ""| sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}


echo "++++++++++++++++++++++++++ scp Backup - Started +++++++++++++++++++++++++++++++++"  # Mrunal : 26-06-2014 12:04:AM 
echo "++++++++++++++++++++++++++ scp Backup - Started +++++++++++++++++++++++++++++++++"  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 

echo
echo ""| sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}

scp -r $TAR_FILE_NAME.tar.bz2 glab@10.1.1.51:/home/glab/clix-pilot-backup/ | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}
mv $BACKUP_DIR /tmp/

if [ "$?" == "0" ]; then
	echo "Backup (scp) - Successfully completed. ";  # Mrunal : 26-06-2014 12:04:AM 
	echo "Backup (scp) - Successfully completed. "  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE} ;  # Mrunal : 26-06-2014 12:04:AM 
#	exit 1; 
else
	echo "Backup (scp) - Failed. Seems like some issue.";  # Mrunal : 26-06-2014 12:04:AM 
	echo "Backup (scp) - Failed. Seems like some issue."  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE} ; # Mrunal : 26-06-2014 12:04:AM 
fi

echo "++++++++++++++++++++++++++ scp Backup - Ended +++++++++++++++++++++++++++++++++"  # Mrunal : 26-06-2014 12:04:AM 
echo "++++++++++++++++++++++++++ scp Backup - Ended +++++++++++++++++++++++++++++++++"  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}  # Mrunal : 26-06-2014 12:04:AM 

echo
echo ""| sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}

echo "++++++++++++++++++++++++++ Mail sending - Started +++++++++++++++++++++++++++++++++"  # Mrunal : 26-06-2014 12:04:AM 
echo "++++++++++++++++++++++++++ Mail sending - Started +++++++++++++++++++++++++++++++++"  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}

echo
echo ""| sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}

#echo "Start"
#echo "Start"| sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}
echo "PFA the backup logs for pilot system (158.144.44.198)" | mail -A ${BACKUP_LOG_FILE} -A ${ERROR_LOG_FILE} -A /root/backup.log -s "Backup File - pilot" mrunal4888@gmail.com
echo "PFA the backup logs for pilot system (158.144.44.198)" | mail -A ${BACKUP_LOG_FILE} -A ${ERROR_LOG_FILE} -A /root/backup.log -s "Backup File - pilot" vk@gnowledge.org
#echo "End"
#echo "End"| sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}

if [ "$?" == "0" ]; then
	echo "Backup (Mail sending) - Successfully completed. ";  # Mrunal : 26-06-2014 12:04:AM 
	echo "Backup (Mail sending) - Successfully completed. "  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE} ;  # Mrunal : 26-06-2014 12:04:AM 
#	exit 1; 
else
	echo "Backup (Mail sending) - Failed. Seems like some issue.";  # Mrunal : 26-06-2014 12:04:AM 
	echo "Backup (Mail sending) - Failed. Seems like some issue."  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE} ; # Mrunal : 26-06-2014 12:04:AM 
fi

echo
echo ""| sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}

echo "++++++++++++++++++++++++++ Mail sending - Ended +++++++++++++++++++++++++++++++++"  # Mrunal : 26-06-2014 12:04:AM 
echo "++++++++++++++++++++++++++ Mail sending - Ended +++++++++++++++++++++++++++++++++"  | sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}

echo
echo ""| sed -e "s/^/$(date -R) /" 1>> ${BACKUP_LOG_FILE} 2>> ${ERROR_LOG_FILE}
exit 0
