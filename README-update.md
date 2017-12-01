
CLIx Platform release patch 2.1, version 17.09.r1, Notes (for CG/MZ/RJ/TS)
State: Chhattisgarh, Mizoram, Rajasthan and Telangana 
Release date: 1st December 2017

# Instruction to apply the update patch

## Download the update file:
	
	updates dt 01-12-2017 (all updates in single tar file):
        https://clixplatform.tiss.edu/softwares/clix-schoolserver-updates/update_patch-687c96e-r2.1-20171201.tar.gz
		https://clixplatform.tiss.edu/softwares/clix-schoolserver-updates/update_patch-687c96e-r2.1-20171201.tar.gz.md5sum
		https://clixplatform.tiss.edu/softwares/clix-schoolserver-updates/patch-r4.sh
		https://clixplatform.tiss.edu/softwares/clix-schoolserver-updates/README-update.md


## Copy content (above downloaded files) in Pendrive (not inside any directory please - directly inside the pendrive {root of pendrive})

## Check md5sum for file checksum:
	Command : ``` md5sum update_patch-687c96e-r2.1-20171201.tar.gz ```
    Ensure that the alphanumeric code (output of the above command) is matching with the content of update_patch-687c96e-r2.1-20171201.tar.gz.md5sum (which you have downloaded from the server)

## Now we have files in pendrive. Insert pendrive in the School server

## Check the connection of drive with lsblk command
	Command : ``` lsblk ````
	Expected output:
		```
		core@clixserver ~ $ lsblk 
		NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
		sda      8:0    0 931.5G  0 disk 
		|-sda4   8:4    0     1G  0 part /usr
		|-sda2   8:2    0     2M  0 part 
		|-sda9   8:9    0 929.2G  0 part /
		|-sda7   8:7    0    64M  0 part 
		|-sda3   8:3    0     1G  0 part 
		|-sda1   8:1    0   128M  0 part /boot
		`-sda6   8:6    0   128M  0 part /usr/share/oem
		NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
		sdb      8:0    0 931.7G  0 disk 
		`-sdb1   8:1    0   16G  0 part 
		```

## Became root user:
	Command : ``` sudo su ```

## create /mnt/pd:
	Command : ``` mkdir /mnt/pd ```

## Mount the pendrive:
	Command : ``` mount <device> /mnt/pd ```
	Example : ``` mount /dev/sdb1 /mnt/pd ```

## Change the directory to /mnt
	Command : ``` cd /mnt/pd ```
	Expected output:
		```
		core@clixserver ~ $ cd /mnt/pd
		core@clixserver /mnt/pd $ 
		```

## Update command			(After the patch is applied it will display the message "Patch 4 update finished.")
	Command : ``` bash patch-r2.1.sh ```

## Shutdown command			(After the patch is finished. Shutdown the system with following command")
	Command : ``` shutdown now ```

======================================================================================================# 


# This file will contain the details about the update patch. This file also includes how the update patch is prepared.


## Update-patch number: (One commit no back of gstudio-docker)
	Syntax  		: 	``` update_patch-<gstudio-docker-repo-commit-no>-r<release-no>-<yyyymmdd> ```
	Exact Number 	: 	``` update_patch-687c96e-r2.1-20171201 ``

## Version number: r1

## Commit number
### gstudio-docker:			(https://github.com/mrunal4/gstudio-docker.git - master)
	Short			:	``` 687c96e ```
	Long			: 	``` 687c96ea80f188d8da240ac6424e0e6feacea8ce ```

### gstudio:    			(https://github.com/gnowledge/gstudio.git - master)
	Short			:	``` cf1765f ```
	Long			: 	``` cf1765f15f0ff62c4068e89a0d28620875469c29 ```

### qbank-lite:				(https://github.com/gnowledge/qbank-lite.git - clixserver)
	Short			:	``` 23e2113 ```
	Long			: 	``` 23e21133c51be72534868e6b1f29f5c38ad217ef ```

### OpenAssessmentsClient:	(https://github.com/gnowledge/OpenAssessmentsClient.git - clixserver)
	Short			:	``` acfed44 ```
	Long			: 	``` acfed44c30b421a49fa2ec43b361ff11653e9d31 ```



------------------------------------------------------------------------------------------------------

Release notes: CLIx Platform patch 2.1 
ver 17.12.r1
Release date: 30th November 2017

ABOUT
This release note pertains to the Connected Learning Initiative (CLIx) student platform aka CLIx platform patch 2.1 (henceforth, patch 2.1). 
This patch should be applied in the states of CG, RJ and TS.
The release 2 patch-r2.1 should be applied on top of the CLIx platform having set up by installing platform ver 17.06.r1 followed by ver 17.09.r1. That is,

1) Install the CLIx platform using installer (ver 17.06.r1)
2) Apply release 2 (patch-r2) (ver 17.09.r1)
3) Apply patch-r2.1 (ver 17.12.r1)

DOWNLOAD
1. Patch 2.1 link: https://clixplatform.tiss.edu/softwares/clix-schoolserver-updates/
2. Open `README-update.md` file as text file and follow instruction given to apply


DETAILS
Please find below details of fixes and features included in patch 2.1:
CLIx Platform patch 2.1: RJ/CG/TS

**Features:**
 LMS:
Now there are three places that have *Enroll* button so that students never miss to enroll.
On the module card
On the unit card
Inside the unit 
Super Admin will not see the Enroll button.
Module level Enrollment:
Provision for enrollment at Module level (provided *Enroll* button on module card). Now with module level enrollment, user gets enrolled into all the units under that module.
Handles use cases of with/without (varying) buddies.
Provided *Enroll* button on unit card.
Unit Player:
Lesson state save:
In Lessons listing, the state of content tree is saved when you leave the page and is retrieved till the next state change. Includes logout/browser close use cases also
Keyboard support binded to traverse Lessons
Changed position of settings wheel from the banner to secondary header
Activity player:
Added new button *Next Lesson*, *Previous Lesson* in the header.
Added *Lesson* to go back to lessons listing with context preserved.
Native(browser) Right click is allowed in Lessons listing
My Desk:
Show `Explore` button if no courses are enrolled.
Progress Report:
Display unit/group-name
Buddy:
Buddy selection widget: Arranged buddies to choose in alphabetical order
Spell correction for *garpes to grapes*; *pegion to pigeon* and *beatle to beetle*.
Mouse hover over buddy icon will now give the buddy name
Tooltips added for main header, unit secondary header, activity player header and notebook.
Data tables version updated:
Group rows for Quiz Responses
Export table content to csv and pdf formats
Tar file gets updated with platform quantitative data CSVs on hourly basis
Quantitative and qualitative data will now be in similar directory structure
system-heartbeat directory will be created with details of RAM, HDD, Size description in data etc.
Ngnix logs are enabled
Ssl certificate is added: redirect clixserver to clixserver.tiss.edu in schools 
Redirect :qbank8080 to 8080 port (no need to add exception for :8080 port for assessments to work)



**Bug Fixes:**
LMS:
Enabled browser/default context-menu(right-click event) in course content tree (which was earlier overridden by jqtree)
Write Note to open editor in a new tab
Banner image made full width without distorting aspect ratio.
Tools: Policequad: data logging issue with buddies fixed.
Text corrections in Progress Report (Update -> Refresh; Complete -> Visit)
Accessibility issues:
Unit header label colors modified
Activity player header, including truncating Unit name
Login: Trimming spaces in the username input field.
Time zone inconsistency between inside and outside the docker is fixed to maintain IST time.

**gstudio/technical updates:**
- Added `fab` command to backup and restore sql db.
    - `fab backup_psql_data`
    - `fab restore_psql_data:<backup file name with path>`
- Release Scripts:
    - Created a new folder `doc/release-scripts/` to hold all release scripts.
    - Copied existing release scripts under it.
    - Added a new release script for patch 2.1: `release2-1_nov17.py`
        - This script will update mispelled usernames (both in `Author` and `User` objects).
    - Added a new `user-tokens.json` containg all tokens used for CLIx usernames generation.
- Updated `bower.json` for `datatables` plugin.
- Implemented initial phase of Sphinx documentation for gstudio.
    - Created necessary files and folders under `doc/`.
    - Added pip dependencies in `requirements.txt` for same.

**Scripts to process after taking pull:**
- `pip install -r requirements.txt`
- `bower install`
- Execute following within python manage.py shell:
    - `execfile('../doc/deployer/release2_sept17.py')`

Git commit and file summary: https://github.com/gnowledge/gstudio/compare/17.10.r1...master
In case of any queries or to report an issue please contact Clix-india-tech@clix.tiss.edu



------------------------------------------------------------------------------------------------------