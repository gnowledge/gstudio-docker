CLIx Platform release patch 2.1, version 17.12.r1, Notes (for CG/RJ/TS)
State: Chhattisgarh, Rajasthan and Telangana 
Release date: 29 December 2017

# Instruction to apply the update patch

## Download following files:
1. https://clixplatform.tiss.edu/softwares/clix-schoolserver-updates/update_patch-beb6af2-r2.1-20171229.tar.gz
2. https://clixplatform.tiss.edu/softwares/clix-schoolserver-updates/update_patch-beb6af2-r2.1-20171229.tar.gz.md5sum
3. https://clixplatform.tiss.edu/softwares/clix-schoolserver-updates/patch-r2.1.sh
4. https://clixplatform.tiss.edu/softwares/clix-schoolserver-updates/README-update.md


## Copy content (above downloaded files) in Pendrive (not inside any directory please - directly inside the pendrive {root of pendrive})

## Check md5sum for file checksum:
	Command : ``` md5sum update_patch-beb6af2-r2.1-20171229.tar.gz ```
    Ensure that the alphanumeric code (output of the above command) is matching with the content of update_patch-beb6af2-r2.1-20171229.tar.gz.md5sum (which you have downloaded from the server)

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
	Exact Number 	: 	``` update_patch-beb6af2-r2.1-20171229 ``

## Version number: r1

## Commit number
### gstudio-docker:			(https://github.com/mrunal4/gstudio-docker.git - master)
	Short			:	``` beb6af2 ```
	Long			: 	``` beb6af265bd62b6dc34bb0acdfcdcedb6b2bccd0 ```

### gstudio:    			(https://github.com/gnowledge/gstudio.git - master)
	Short			:	``` 225cf7b ```
	Long			: 	``` 225cf7b5b8c11b916ee33488c5fc2e82ceaffa5d```

### qbank-lite:				(https://github.com/gnowledge/qbank-lite.git - clixserver)
	Short			:	``` 23e2113 ```
	Long			: 	``` 23e21133c51be72534868e6b1f29f5c38ad217ef ```

### OpenAssessmentsClient:	(https://github.com/gnowledge/OpenAssessmentsClient.git - clixserver)
	Short			:	``` 976b5fc ```
	Long			: 	``` 976b5fca5a3cf1f058b242b897024e13d67b7c58 ```



------------------------------------------------------------------------------------------------------

Release notes: CLIx Platform patch 2.1 
ver 17.12.r1
Release date: 29 December 2017

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

**Gstudio-Docker Features:**
- Issue of multiple time SSL-certificate exception addition on client machines (browsers) is fixed.

---


**Gstudio Features:**

- LMS:
    - Module Enroll:
        - Provision for enrollment at Module level. Now with module level enrollment, all the units under it gets enrolled.
        - Handled use cases with/without (varying) buddies.
    - Provided *Enroll* button on unit card.
    - Activity player header:
        - Added new button *Next Lesson*, *Previous Lesson*.
        - Unit name: provided tooltip, truncating to 25 characters.
        - Tooltips addedd for all actions and CSS updated.
    - Activity Player:
        - Made `Enroll` button more promient from visibility point of view.
    - Lesson state save:
        - In Lessons listing, the state of content tree is saved when you leave the page and is retrieved till the next state change. Includes logout/browser close use cases also
        - Keyboard support binded to traverse Lessons
- My Desk:
    - Showing `Explore` button if no courses are enrolled.
- Progress Report:
    - Display unit/group-name
- Buddy:
    - Buddy selection widget: Arranged buddies to choose in alphabetical order
- Datatables version updated:
    - Group rows for Quz Responses
    - Export table content to csv and pdf formats

---

**Bug Fixes:**
- LMS:
    - Enabled browser/default context-menu(right-click event) in course content tree (which was earlier overridden by jqtree)
    - Write Note to open editor on redirection issue resolved.
- Banner image made full width without distoring aspect ratio.
- Tools: Policequad, logging issue with buddies fixed.
- Accessibility issues:
    - Unit header label colors modified
    - Activiy player header, including trunctaing Unit name
- Login: Trimming username input field.
- Quiz: bug of not saving nos of attempts resolved.

---

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

---

**Scripts to process after taking pull:**
- `pip install -r requirements.txt`
- `bower install`
- Execute following within python manage.py shell:
    - `execfile('../doc/deployer/release2-1_nov17.py')`

---

Git commit and file summary: https://github.com/gnowledge/gstudio/compare/17.10.r1...master
In case of any queries or to report an issue please contact Clix-india-tech@clix.tiss.edu



------------------------------------------------------------------------------------------------------