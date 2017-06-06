# Update details

This file will contain the details about the update patch. This file also includes how the update patch is prepared.



##Update-patch number: 
	Syntax  		: 	``` update-patch-<gstudio-docker-commit-no>-r<release-no>-<yyyymmdd> ```
	Exact Number 	: 	``` update-patch-<gstudio-docker-commit-no>-r<release-no>-20170605 ```


##Version number: r1


##Commit number
###gstudio-docker:
	Short			:	``` 5568dbb ```
	Long			: 	``` 5568dbbbdf0bda549aefbcf8fc6a9352046d7d29 ```

###gstudio: 
	Short			:	``` 5568dbb ```
	Long			: 	``` 5568dbbbdf0bda549aefbcf8fc6a9352046d7d29 ```

###qbank:
	Short			:	``` cf7c138 ```
	Long			: 	``` cf7c1382638c340b5665d6e7ce7e7f31626aed30 ```

###OpenAssessmentsClient:
	Short			:	``` ed2f30d ```
	Long			: 	``` ed2f30dc65be911ee8f1c80a964e159e289ffe0b ```



##Instruction to prepare the update patch

mkdir update-patch-<gstudio-docker-commit-no>-r1-20170606

mkdir -p update-patch-<gstudio-docker-commit-no>-r1-20170606/code-updates

cd update-patch-<gstudio-docker-commit-no>-r1-20170606/code-updates

git clone https://github.com/mrunal4/gstudio-docker.git

git clone https://github.com/gnowledge/gstudio.git

rsync -avzPh gstudio-docker/scripts/git-offline-update.sh gstudio-docker/scripts/code-update.sh .

cd ../../


mkdir -p update-patch-<gstudio-docker-commit-no>-r1-20170606/oac-and-oat-updates

cd update-patch-<gstudio-docker-commit-no>-r1-20170606/oac-and-oat-updates

rsync -avzPh ../code-updates/gstudio-docker/scripts/update-oac-and-oat.sh .

wget https://clixplatform.tiss.edu/softwares/clix-schoolserver-updates-raw-material/20170606/oac.patch

wget https://clixplatform.tiss.edu/softwares/clix-schoolserver-updates-raw-material/20170606/oac.patch

cd ../../

tar cvzf update-patch-<gstudio-docker-commit-no>-r1-20170606.tar.gz update-patch-<gstudio-docker-commit-no>-r1-20170606/



##Instruction to apply the update patch

###Download the update tar file:
	
	updates dt 01-06-2017 (all updates in single tar file):
		https://clixplatform.tiss.edu/softwares/clix-schoolserver-updates/update_2017_06_01.tar.gz


###Copy content (downloaded tar file) in Pendrive (not inside any directory please - directly inside the pendrive {root of pendrive})

###Now we have files in pendrive. Insert pendrive in the School server

###Check the connection of drive with lsblk command
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

###Mount the pendrive:
	Command : ``` mount <device> /mnt/ ```
	Example : ``` mount /dev/sdb1 /mnt/ ```

###Change the directory to /mnt
	Command : ``` cd /mnt ```
	Expected output:
		```
		core@clixserver ~ $ cd /mnt/
		core@clixserver /mnt $ 
		```


###Update procedure			(Following commands should be processed in this order only)
	####code-updates:
		Extract the content from tar file
			Command : ``` sudo tar xvzf update_2017_06_01.tar.gz ```
		Apply code update patch
			Command : ``` sudo bash update_2017_06_01/code-updates/code-update.sh ```

	####oac and oat:
		Command : ``` sudo bash update_2017_06_01/oac-and-oat-updates/update-oac-and-oat.sh ```

###Restart the system
	Command : ``` sudo reboot ```
	Expected output:
		```
		core@clixserver ~ $ sudo reboot
		```
===================================================================