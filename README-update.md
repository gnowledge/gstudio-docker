
# Instruction to apply the update patch

## Download the update tar file:
	
	updates dt 05-08-2017 (all updates in single tar file):
		https://clixplatform.tiss.edu/softwares/clix-schoolserver-updates/update-patch-7698c0a-r2-20170805.tar.gz
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


## Update-patch number: 
	Syntax  		: 	``` update-patch-7698c0a-r<release-no>-<yyyymmdd> ```
	Exact Number 	: 	``` update-patch-7698c0a-r2-20170805``

## Version number: r1

## Commit number
### gstudio-docker:			(https://github.com/mrunal4/gstudio-docker.git - master)
	Short			:	``` 7698c0a ```
	Long			: 	``` 7698c0a9c420404b98284c3eecbd731a960c3d81 ```

### gstudio:    			(https://github.com/gnowledge/gstudio.git - dlkit)
	Short			:	``` 536f212 ```
	Long			: 	``` 536f212ff033a6a011ac28070451994f83a65954 ```

### qbank-lite:				(https://github.com/gnowledge/qbank-lite.git - clixserver)
	Short			:	``` 43be004 ```
	Long			: 	``` 43be0040267e652b1c9e625e3a08d8a4710d5d4e ```

### OpenAssessmentsClient:	(https://github.com/gnowledge/OpenAssessmentsClient.git - clixserver)
	Short			:	``` 462ba9c ```
	Long			: 	``` 462ba9c29e6e8874386c5e76138909193e90240e ```


------------------------------------------------------------------------------------------------------


# Instruction to prepare the update patch

mkdir update_patch-7698c0a-r2-20170805

mkdir -p update_patch-7698c0a-r2-20170805/code-updates

cd update_patch-7698c0a-r2-20170805/code-updates

git clone https://github.com/mrunal4/gstudio-docker.git

git clone https://github.com/gnowledge/gstudio.git -b dlkit

rsync -avzPh gstudio-docker/scripts/git-offline-update.sh gstudio-docker/scripts/code-update.sh .

cd ../../


mkdir -p update_patch-7698c0a-r2-20170805/oac-and-oat-updates

cd update_patch-7698c0a-r2-20170805/oac-and-oat-updates

rsync -avzPh ../code-updates/gstudio-docker/scripts/update-oac-and-oat.sh .

wget https://clixplatform.tiss.edu/softwares/clix-schoolserver-updates-raw-material/20170805/oac.patch

wget https://clixplatform.tiss.edu/softwares/clix-schoolserver-updates-raw-material/20170805/oat.patch

cd ../../

tar cvzf update_patch-7698c0a-r2-20170805.tar.gz update_patch-7698c0a-r2-20170805/

rsync -avzPh update_patch-7698c0a-r2-20170805/code-updates/gstudio-docker/scripts/patch/patch-r2.sh update_patch-7698c0a-r2-20170805/code-updates/gstudio-docker/README-update.md .

------------------------------------------------------------------------------------------------------

