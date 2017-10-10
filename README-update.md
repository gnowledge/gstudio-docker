# Instruction to apply the update patch

## Download the update tar file:
	
	updates dt 29-09-2017 (all updates in single tar file):
        https://clixplatform.tiss.edu/softwares/clix-schoolserver-updates/update_patch-15f7287-r3-20171010.tar.gz
		https://clixplatform.tiss.edu/softwares/clix-schoolserver-updates/update_patch-15f7287-r3-20171010.tar.gz.md5sum
		https://clixplatform.tiss.edu/softwares/clix-schoolserver-updates/patch-r2.sh
		https://clixplatform.tiss.edu/softwares/clix-schoolserver-updates/README-update.md


## Copy content (downloaded tar file) in Pendrive (not inside any directory please - directly inside the pendrive {root of pendrive})

## Check md5sum for file checksum:
	Command : ``` md5sum update_patch-15f7287-r3-20171010.tar.gz ```
    Ensure that the alphanumeric code (output of the above command) is matching with the content of update_patch-15f7287-r3-20171010.tar.gz.md5sum (which you have downloaded from the server)

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
		|-sdb4   8:4    0     1G  0 part 
		|-sdb2   8:2    0     2M  0 part 
		|-sdb9   8:9    0 929.5G  0 part 
		|-sdb7   8:7    0    64M  0 part 
		|-sdb3   8:3    0     1G  0 part 
		|-sdb1   8:1    0   128M  0 part 
		`-sdb6   8:6    0   128M  0 part 
		```

## Became root user:
	Command : ``` sudo su ```

## Mount the pendrive:
	Command : ``` mount <device> /mnt/ ```
	Example : ``` mount /dev/sdb9 /mnt/ ```

## Change the directory to /mnt
	Command : ``` cd /mnt ```
	Expected output:
		```
		core@clixserver ~ $ cd /mnt/
		core@clixserver /mnt $ 
		```

## Update command			(After the patch is applied it will reboot the system)
	Command : ``` bash patch-r2.sh ```


======================================================================================================# Update details


# This file will contain the details about the update patch. This file also includes how the update patch is prepared.


## Update-patch number: (One commit no back of gstudio-docker)
	Syntax  		: 	``` update_patch-<gstudio-docker-repo-commit-no>-r<release-no>-<yyyymmdd> ```
	Exact Number 	: 	``` update_patch-15f7287-r3-20171010 ``

## Version number: r1

## Commit number
### gstudio-docker:			(https://github.com/mrunal4/gstudio-docker.git - master)
	Short			:	``` 15f7287 ```
	Long			: 	``` 15f7287ea2b6dfefd127038c732402aff293de16 ```

### gstudio:    			(https://github.com/gnowledge/gstudio.git - master)
	Short			:	``` 84457e9 ```
	Long			: 	``` 84457e980ae4133245bfa5c6970fb6969dd0dab1 ```

### qbank-lite:				(https://github.com/gnowledge/qbank-lite.git - clixserver)
	Short			:	``` 1b48892 ```
	Long			: 	``` 1b488926a4d609dcde017e4fe7a47b8a4b541339 ```

### OpenAssessmentsClient:	(https://github.com/gnowledge/OpenAssessmentsClient.git - clixserver)
	Short			:	``` acfed44 ```
	Long			: 	``` acfed44c30b421a49fa2ec43b361ff11653e9d31 ```



------------------------------------------------------------------------------------------------------

CLIx Platform release , Notes (for RJ/CG/TS)
State: Rajasthan, Chhattisgarh and Telangana 
Release date: 10th October 2017

```
Key features
    -  Backup and System heartbeat related changes
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
```
------------------------------------------------------------------------------------------------------
