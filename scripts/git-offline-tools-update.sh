#!/bin/bash


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

filename=$(basename $(ls -dr /home/docker/code/patch-*/ |  head -n 1));
patch="${filename%.*.*}";
#patch="patch-7a6c2ac-r5-20190221";    #earlier patch
#patch="patch-26eaf18-r5-20190320";    #latest patch

# git offline update Astroamer_Planet_Trek_Activity code - started
git_commit_no_Astroamer_Planet_Trek_Activity="39f1cc7cb1cd567f69477b20830bf7f9b89be4d6";              # Commit on 01/10/2018

echo -e "\n${cyan}change the directory to /softwares/Tools/Astroamer_Planet_Trek_Activity/ ${reset}"
cd /softwares/Tools/Astroamer_Planet_Trek_Activity/

echo -e "\n${cyan}changing the git branch to master";
git checkout master;

echo -e "\n${cyan}fetching git details from /home/docker/code/${patch}/tools-updates/Astroamer_Planet_Trek_Activity ${reset}";
git fetch /home/docker/code/${patch}/tools-updates/Astroamer_Planet_Trek_Activity;

echo -e "\n${cyan}merging till specified commit number (${git_commit_no_Astroamer_Planet_Trek_Activity}) from /home/docker/code/${patch}/tools-updates/Astroamer_Planet_Trek_Activity ${reset}";
git merge $git_commit_no_Astroamer_Planet_Trek_Activity;

# git offline update Astroamer_Planet_Trek_Activity code - ended


# git offline update Motions_of_the_Moon_Animation code - started
git_commit_no_Motions_of_the_Moon_Animation="c4feb76dbb784e6c4bb86c76c02d3ff73353d107";              # Commit on 08/10/2018

echo -e "\n${cyan}change the directory to /softwares/Tools/Motions_of_the_Moon_Animation/ ${reset}"
cd /softwares/Tools/Motions_of_the_Moon_Animation/

echo -e "\n${cyan}changing the git branch to master";
git checkout master;

echo -e "\n${cyan}fetching git details from /home/docker/code/${patch}/tools-updates/Motions_of_the_Moon_Animation ${reset}";
git fetch /home/docker/code/${patch}/tools-updates/Motions_of_the_Moon_Animation;

echo -e "\n${cyan}merging till specified commit number (${git_commit_no_Motions_of_the_Moon_Animation}) from /home/docker/code/${patch}/tools-updates/Motions_of_the_Moon_Animation ${reset}";
git merge $git_commit_no_Motions_of_the_Moon_Animation;

# git offline update Motions_of_the_Moon_Animation code - ended


# git offline update Rotation_of_Earth_Animation code - started
git_commit_no_Rotation_of_Earth_Animation="2c070c5b54550b519ed4429f82cc9c7358e38b18";              # Commit on 03/07/2018

echo -e "\n${cyan}change the directory to /softwares/Tools/Rotation_of_Earth_Animation/ ${reset}"
cd /softwares/Tools/Rotation_of_Earth_Animation/;

echo -e "\n${cyan}changing the git branch to master";
git checkout master;

echo -e "\n${cyan}fetching git details from /home/docker/code/${patch}/tools-updates/Rotation_of_Earth_Animation ${reset}";
git fetch /home/docker/code/${patch}/tools-updates/Rotation_of_Earth_Animation;

echo -e "\n${cyan}merging till specified commit number (${git_commit_no_Rotation_of_Earth_Animation}) from /home/docker/code/${patch}/tools-updates/Rotation_of_Earth_Animation ${reset}";
git merge $git_commit_no_Rotation_of_Earth_Animation;

# git offline update Rotation_of_Earth_Animation code - ended


#git offline update food_sharing_tool code - started
git_commit_no_food_sharing_tool="dfa73432caedb121c567f2f3484bc7d8cfd39f1a";                    # Commit on 01/02/2019

echo -e "\n${cyan}change the directory to /softwares/Tools/food_sharing_tool/ ${reset}"
cd /softwares/Tools/food_sharing_tool/;

echo -e "\n${cyan}changing the git branch to master";
git checkout master;

echo -e "\n${cyan}fetching git details from /home/docker/code/${patch}/tools-updates/food_sharing_tool ${reset}";
git fetch /home/docker/code/${patch}/tools-updates/food_sharing_tool;

echo -e "\n${cyan}merging till specified commit number (${git_commit_no_food_sharing_tool}) from /home/docker/code/${patch}/tools-updates/food_sharing_tool ${reset}";
git merge $git_commit_no_food_sharing_tool;

# git offline update food_sharing_tool code - ended


# git offline update sugarizer code - started
git_commit_no_sugarizer="239b9d716c0b0686f1389610cea31b91e58665c2";                               # Commit on 04/04/2016

echo -e "\n${cyan}change the directory to /softwares/DOER/sugarizer/ ${reset}"
cd /softwares/DOER/sugarizer/;

echo -e "\n${cyan}changing the git branch to master";
git checkout master;

#echo -e "\n${cyan}fetching git details from /home/docker/code/${patch}/tools-updates/sugarizer ${reset}";
#git fetch /home/docker/code/${patch}/tools-updates/sugarizer;

#echo -e "\n${cyan}merging till specified commit number (${git_commit_no_sugarizer}) from /home/docker/code/${patch}/tools-updates/sugarizer ${reset}";
#git merge $git_commit_no_sugarizer;

git reset --hard ${git_commit_no_sugarizer};

# git offline update sugarizer code - ended


echo -e "\n${cyan}Changing the directory to /softwares/Tools/ ${reset}";
cd /softwares/Tools/;

echo -e "\n${cyan}TurtleBlocksJS repo renamed to turtle_customized_version. ${reset}";
sudo mv TurtleBlocksJS turtle_customized_version;

echo -e "\n${cyan}Changing the directory to /softwares/DOER/ ${reset}";
cd /softwares/DOER/;

echo -e "\n${cyan}turtle repo renamed to turtle_full_version ${reset}";
sudo mv turtle turtle_full_version;

echo -e "\n${cyan}Copy/Move turtle_customized_version repo/folder from /Tools to /DOER directory. ${reset}";
sudo mv /softwares/Tools/turtle_customized_version /softwares/DOER/;

echo -e "\n${cyan}Changing the directory to /softwares/DOER/ ${reset}";
cd /softwares/DOER/;

echo -e "\n${cyan}Creating symlink for turtle_customized_version ${reset}";
ln -s turtle_customized_version turtle;                                     #for creation of link 

echo -e "\n${cyan}Changing the directory to /home/docker/code/gstudio/gnowsys_ndf ${reset}";
cd /home/docker/code/gstudio/gnowsys-ndf;

echo -e "\n${cyan}running the collectstatic in manage.py ${reset}";
echo "yes" | python manage.py collectstatic;

#echo -e "\n${cyan}running the compass watch ${reset}";
#compass watch;

echo -e "\n${cyan}Removing the ${patch} from /home/docker/code/ ${reset}";
rm -rf /home/docker/code/${patch};







