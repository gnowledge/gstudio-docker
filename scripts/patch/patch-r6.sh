#!/bin/bash
#Created On March 2019
#This script file "patch-r6.sh" should be run using "bash patch-r6.sh"

#Following are the git commit numbers of repositories that have been modified:

 # Inside the code folder--
   # gstudio-docker= "c0463c5a55a92629edbca0ee34b8c7cbba161d3a"
   # gstudio= "235eb4e9818a333e132595664838a22c8e4b4d11"
   # qbank-gstudio-scripts="002cbdff2e596f2dab6f0b2c14efd5a561b3dae0"

 # Inside the tools folder--
   # Astroamer_Planet_Trek_Activity= "39f1cc7cb1cd567f69477b20830bf7f9b89be4d6"
   # Motions_of_the_Moon_Animation= "c4feb76dbb784e6c4bb86c76c02d3ff73353d107"
   # Rotation_of_Earth_Animation= "2c070c5b54550b519ed4429f82cc9c7358e38b18"
   # food_sharing_tool= "dfa73432caedb121c567f2f3484bc7d8cfd39f1a"
   # sugarizer= "239b9d716c0b0686f1389610cea31b91e58665c2"

# Following variables are used to store the color codes for displaying the content on terminal
black="\033[0;90m" ;
red="\033[0;91m" ;
green="\033[0;92m" ;
brown="\033[0;93m" ;
blue="\033[0;94m" ;
purple="\033[0;95m" ;
cyan="\033[0;96m" ;
grey="\033[0;97m" ;
white="\033[0;98m" ;
reset="\033[0m" ;

#ss_id stores the school ID 
ss_id=`echo  $(echo $(more /home/core/code/gstudio/gnowsys-ndf/gnowsys_ndf/server_settings.py | grep -w GSTUDIO_INSTITUTE_ID | sed 's/.*=//g')) | sed "s/'//g" | sed 's/"//g'`;

# Trim leading  whitespaces 
ss_id=$(echo ${ss_id##*( )});
# Trim trailing  whitespaces 
ss_id=$(echo ${ss_id%%*( )});

function apply_patch() {
     #For filename

      #patch=$(basename $(tar -tf /mnt/patch-*.tar.gz |  head -n 1));
      #patch="patch-7a6c2ac-r5-20190221";     #earlier patch
      #patch="patch-26eaf18-r5-20190320";     #latest patch
      patch="update-patch-c0463c5-r6-20190718";

      echo -e "\n${cyan}The folder named "$patch" is present which has all the code, data and tools updates ${reset}";

      echo -e "\n${cyan}Changing the Directory ${reset}";
      cd /mnt/update-patch-r6/;
 
      #code for checking the md5sum for file checksum started

      echo "\n${cyan}File integrity check started. Please wait";
      
      #if [ -f patch-26eaf18-r5-20190320.tar.gz.md5sum ]; then
      if [ -f ${patch}.tar.gz.md5sum ]; then
          #echo "\n${cyan}patch-26eaf18-r5-20190320.tar.gz.md5sum file is present ${reset}"
          echo "\n${cyan} ${patch}.tar.gz.md5sum file is present ${reset}"

          #if md5sum --status -c patch-26eaf18-r5-20190320.tar.gz.md5sum && echo OK; then
          if md5sum --status -c ${patch}.tar.gz.md5sum && echo OK; then
             echo "\n${cyan}File integrity check was successful ${reset}";
          else
             #echo "\n${cyan}File integrity Check Failed. Please download the correct patch-26eaf18-r5-20190320.tar.gz file ${reset}";
             echo "\n${cyan}File integrity Check Failed. Please download the correct ${patch}.tar.gz file ${reset}";
             exit;
          fi
      else
          #echo "\n${cyan}patch-26eaf18-r5-20190320.tar.gz.md5sum file not present. Please Download It ${reset}";
          echo "\n${cyan} ${patch}.tar.gz.md5sum file not present. Please Download It ${reset}";
          exit;
      fi

      #code for checking the md5sum for file checksum ended
     
      echo -e "\n${cyan}Extracting the files ${reset}";
      sudo tar -xvzf ${patch}.tar.gz;

      #code for triggering various scripts to update code,data and tools started

      echo -e "\n${cyan}Applying code updates ${reset}";
    	sudo bash ${patch}/code-updates/code-update.sh;

      #echo -e "\n${cyan}Step 1 successfully completed ${reset}";

     	echo -e "\n${cyan}Applying data updates ${reset}";
     	sudo bash ${patch}/data-updates/data-update.sh;

      #echo -e "\n${cyan}Step 2 successfully completed ${reset}";

     	echo -e "\n${cyan}Applying tools updates ${reset}";
     	sudo bash ${patch}/tools-updates/tools-update.sh;

      #echo -e "\n${cyan}Step 3 successfully completed ${reset}";  

      #code for triggering various scripts to update code,data and tools ended     

      #code to remove the patch folder created by extraction of tar file
      echo -e "\n${cyan}Removing the ${patch} folder ${reset}";
      cd /mnt/update-patch-r6/ ;
      sudo rm -rf ${patch};    
     
      echo -e "\n${cyan}Congratulations!!! Patch is applied successfully. ${reset}";

}   

apply_patch | tee update-patch-r6-${ss_id}.log && rsync -avPhz update-patch-r6-${ss_id}.log /home/core/;       # logs are stored in this file


#for restarting the system

echo -e "\n${cyan}School server will be restarting in 10 sec ${reset}";
sleep 10;
sudo reboot;


      
      


 
