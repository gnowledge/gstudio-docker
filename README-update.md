
# Instruction to apply the update patch

## Download the update tar file:
	
	updates dt 06-08-2017 (all updates in single tar file):
		https://clixplatform.tiss.edu/softwares/clix-schoolserver-updates/update_patch-5f257fe-r2-20170806.tar.gz
		https://clixplatform.tiss.edu/softwares/clix-schoolserver-updates/patch-r2.sh
		https://clixplatform.tiss.edu/softwares/clix-schoolserver-updates/README-update.md




## Copy content (downloaded tar file) in Pendrive (not inside any directory please - directly inside the pendrive {root of pendrive})

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
		sdb      8:0    0 931.5G  0 disk 
		|-sdb1   8:4    0     1G  0 part 
		```

## Mount the pendrive:
	Command : ``` mount <device> /mnt/ ```
	Example : ``` mount /dev/sdb1 /mnt/ ```

## Change the directory to /mnt
	Command : ``` cd /mnt ```
	Expected output:
		```
		core@clixserver ~ $ cd /mnt/
		core@clixserver /mnt $ 
		```


## Update command			(After the patch is applied it will reboot the system)
	Command : ``` sudo bash patch-r2.sh ```


======================================================================================================# Update details


# This file will contain the details about the update patch. This file also includes how the update patch is prepared.


## Update-patch number: (One commit no back of gstudio-docker)
	Syntax  		: 	``` update_patch-5f257fe-r<release-no>-<yyyymmdd> ```
	Exact Number 	: 	``` update_patch-5f257fe-r2-20170806``

## Version number: r1

## Commit number
### gstudio-docker:			(https://github.com/mrunal4/gstudio-docker.git - master)
	Short			:	``` 5f257fe ```
	Long			: 	``` 5f257fe11c2ca8fc6119251681fc48d0e31dd706 ```

### gstudio:    			(https://github.com/gnowledge/gstudio.git - dlkit)
	Short			:	``` 2849c7f ```
	Long			: 	``` 2849c7f3fad5c4c25f02a4194d2354da3c25e054 ```

### qbank-lite:				(https://github.com/gnowledge/qbank-lite.git - clixserver)
	Short			:	``` 1b48892 ```
	Long			: 	``` 1b488926a4d609dcde017e4fe7a47b8a4b541339 ```

### OpenAssessmentsClient:	(https://github.com/gnowledge/OpenAssessmentsClient.git - clixserver)
	Short			:	``` 462ba9c ```
	Long			: 	``` 462ba9c29e6e8874386c5e76138909193e90240e ```



------------------------------------------------------------------------------------------------------

