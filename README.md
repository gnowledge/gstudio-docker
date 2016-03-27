# gstudio-docker
Docker file for gstudio
=======================

To build the docker image, we need to clone the project in your docker host, and run the script build-docker.sh. This script clones the gstudio code and builds the image. After clining the gstudio-docker, download and install the static javascript depedencies from http://gnowledge.org/~nagarjun/bower_components.tar.gz. unzip the contents of this file in the project directory before starting the buuild-docker.sh script.

The image uses Ubuntu 14.04, django, nginx, mongodb, and several code dependent python libraries and OS level libraries.  The image builds to about 1.6GB.  

Under development
-----------------

- autostart of mongod issue to be resolved
- schema files to be updated for course builder and course player
- single point data directory for all data (mongo, sqlite, static files, rcs files, mail queue, etc.)
- after successful completion of the above tasks the docker project to be published in dockerhub.
- security enhancements
  - run all services as non-root user
  - expose only port 80
  - gpg keys installation script for school servers joining auto-sync program.

Building the Image
------------------

Build the image by running "build-docker.sh" script from the project directory after cloning the project files. If you are re-building the image, delete the 'gstudio' directory to get the fresh updates from gstudio project. 

Script details
---------------------

	1. script name : build-docker.sh
	   execution   : bash build-docker.sh
	   use	       : used for the following -
		    1. installing docker application
		    2. building the images and starting the container
		    3. loading the imaes and starting the container 

	2. script name : initialize.sh
	   execution   : bash initialize.sh
	   use	       : used for the following -
		    1. starting the applications at the startup of a docker container
		    2. execute application related scripts

	3. script name : numa-arch-check.sh
	   execution   : bash numa-arch-check.sh
	   use	       : used for the following -
		    1. check of numa arch.

	4. script name : generate-self-certified-certificate-ssl.sh
	   execution   : bash generate-self-certified-certificate-ssl.sh
	   use	       : used for the following -
		    1. generate ssl certificate (self certified ssl certificate).

	5. script name : local_settings_changes.sh
	   execution   : bash local_settings_changes.sh
	   use	       : used for the following -
		    1. generate ssl certificate (self certified ssl certificate).

	6. script name : smtpd.sh
	   execution   : bash smtpd.sh
	   use	       : used for the following -
		    1. starting smtpd 

	7. script name : Bulk-User-creation.sh
	   execution   : bash Bulk-User-creation.sh
	   use	       : used for the following -
		    1. creating the bulk users. It makes use of "Users.csv" for creating user details for creation.
       		    Note : First add new usernames and passwords in "Users.csv".

	8. script name : git-update.sh
	   execution   : bash git-update.sh
	   use	       : used for the following -
		    1. updating the code from git

	9. script name : ss-gpg-setup.sh
	   execution   : bash ss-gpg-setup.sh
	   use	       : used for the following -  (Under developement)
		    1. take installing user and school details.
		    2. generate gpg keys.
