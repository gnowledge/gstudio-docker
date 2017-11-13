
CLIx Platform release patch 2.1, version 17.09.r1, Notes (for RJ/CG/TS)
State: Rajasthan, Chhattisgarh and Telangana 
Release date: 13th november 2017

# Instruction to apply the update patch

## Download the update file:
	
	updates dt 13-11-2017 (all updates in single tar file):
        https://clixplatform.tiss.edu/softwares/clix-schoolserver-updates/update_patch-520d9ed-r2.1-20171113.tar.gz
		https://clixplatform.tiss.edu/softwares/clix-schoolserver-updates/update_patch-520d9ed-r2.1-20171113.tar.gz.md5sum
		https://clixplatform.tiss.edu/softwares/clix-schoolserver-updates/patch-r4.sh
		https://clixplatform.tiss.edu/softwares/clix-schoolserver-updates/README-update.md


## Copy content (above downloaded files) in Pendrive (not inside any directory please - directly inside the pendrive {root of pendrive})

## Check md5sum for file checksum:
	Command : ``` md5sum update_patch-520d9ed-r2.1-20171113.tar.gz ```
    Ensure that the alphanumeric code (output of the above command) is matching with the content of update_patch-520d9ed-r2.1-20171113.tar.gz.md5sum (which you have downloaded from the server)

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
	Exact Number 	: 	``` update_patch-520d9ed-r2.1-20171113 ``

## Version number: r1

## Commit number
### gstudio-docker:			(https://github.com/mrunal4/gstudio-docker.git - master)
	Short			:	``` 520d9ed ```
	Long			: 	``` 520d9ed489fba752fa3843ccb98c0c9ad70329e3 ```

### gstudio:    			(https://github.com/gnowledge/gstudio.git - master)
	Short			:	``` 5d5ed8a ```
	Long			: 	``` 5d5ed8acd48950f9eb850590bef068f853a42fb5 ```

### qbank-lite:				(https://github.com/gnowledge/qbank-lite.git - clixserver)
	Short			:	``` 1b48892 ```
	Long			: 	``` 1b488926a4d609dcde017e4fe7a47b8a4b541339 ```

### OpenAssessmentsClient:	(https://github.com/gnowledge/OpenAssessmentsClient.git - clixserver)
	Short			:	``` acfed44 ```
	Long			: 	``` acfed44c30b421a49fa2ec43b361ff11653e9d31 ```



------------------------------------------------------------------------------------------------------


This release note pertains to the Connected Learning Initiative (CLIx) student platform aka CLIx platform release 2.1 (henceforth, release 2.1). 
The release patch 2.1 patch-r2.1 should be applied on the CLIx platform ver 17.06.r1 only. Please find below details of release patch 2.1 features:


Technical Details

Features:
    1. System heartbeat related changes
    2. Set timezone as IST (Asia/Kolkata)
	3. Backup hierarchy related changes
        Year (YYYY)                                                 [ LEVEL 0 ]
            State (State Code)                                      [ LEVEL 1 ]
                - School (School Code + Server ID)                  [ LEVEL 2 ]
                    - gstudio (Clix Platform)                       [ LEVEL 3 ]
                        - db                                        [ LEVEL 4 ]
                        - media                                     [ LEVEL 4 ]
                        - rcs-repo                                  [ LEVEL 4 ]
                        - postgres-dump                             [ LEVEL 4 ]
                        - local_settings.py                         [ LEVEL 4 ]
                        - server_settings.py                        [ LEVEL 4 ]
                        - gstudio-logs                              [ LEVEL 4 ]
                        - system-heartbeat.log                      [ LEVEL 4 ]
                        - system-heartbeat.log                      [ LEVEL 4 ]
                        - gstudio-exported-users-analytics-csvs     [ LEVEL 4 ]
                        - git-commit.log                            [ LEVEL 4 ]
                        - assessment-media                          [ LEVEL 4 ]
                            - repository                            [ LEVEL 5 ]
                            - studentResponseFiles                  [ LEVEL 5 ]
                    - unplatform (Optional)                         [ LEVEL 3 ]

Git commit and file summary: 17.08.r1...master

*Following are details of repositories, versions for CLIx Platform release 4: RJ/CG/TS:*

    1. *OpenAssessmentClient*:
        a. Repository : https://github.com/gnowledge/OpenAssessmentsClient/tree/clixserver
        b. Version/Tag: 17.09.r1 (https://github.com/gnowledge/OpenAssessmentsClient/releases/tag/17.09.r1)
        c. Branch: `clixserver`

    2. *qbank*:
        a. Repository : https://github.com/gnowledge/qbank-lite/tree/clixserver
        b. Version/Tag: 17.06.r1 (https://github.com/gnowledge/qbank-lite/releases/tag/17.06.r1)
        c. Branch: `clixserver`

    3. *gStudio*:
        a. Repository : https://github.com/gnowledge/gstudio
        b. Version/Tag: 17.09.r1 (currently in draft, will post release note URL soon)
        c. Branch: `master`

    4.  Dependencies* [pip installables]: https://github.com/gnowledge/gstudio/blob/master/requirements.txt
        a. `dlkit` updated to `0.5.13` (https://github.com/gnowledge/gstudio/blob/master/requirements.txt#L36)


------------------------------------------------------------------------------------------------------