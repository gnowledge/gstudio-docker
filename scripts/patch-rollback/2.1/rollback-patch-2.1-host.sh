#!/bin/bash

# File to be triggered from host system

patch_no="2.1";

# get server id (Remove single quote {'} and Remove double quote {"})
ss_id=`docker exec -it gstudio bash -c "more /home/docker/code/gstudio/gnowsys-ndf/gnowsys_ndf/server_settings.py | grep -w GSTUDIO_INSTITUTE_ID | sed 's/.*=//g' | sed \"s/'//g\" | sed 's/\"//g'"`
ss_id=`tr -dc '[[:print:]]' <<< "$ss_id"`

# get state code
state_code=${ss_id:0:2};

# get server code (Remove single quote {'} and Remove double quote {"})
ss_code=`docker exec -it gstudio bash -c "more /home/docker/code/gstudio/gnowsys-ndf/gnowsys_ndf/server_settings.py | grep -w GSTUDIO_INSTITUTE_ID_SECONDARY | sed 's/.*=//g' | sed \"s/'//g\" | sed 's/\"//g'"`
ss_code=`tr -dc '[[:print:]]' <<< "$ss_code"`

# get server name (Remove single quote {'} and Remove double quote {"})
#ss_name=`docker exec -it gstudio bash -c "more /home/docker/code/gstudio/gnowsys-ndf/gnowsys_ndf/server_settings.py | grep -w GSTUDIO_INSTITUTE_NAME | sed 's/.*=//g' | sed \"s/'//g\" | sed 's/\"//g'"`
ss_name=`tr -dc '[[:print:]]' <<< "$ss_name"`

# dir name
dir_name=${patch_no}-${ss_id}-$(date +%Y%m%d-%H%M%S);

if [[ ! -d /mnt/${dir_name}/ ]]; then
    mkdir -p /mnt/${dir_name}/
fi

echo -e "copy rollback-patch-2.1-container.sh from /mnt/ in /home/core/setup-software/"
rsync -avzPh /mnt/rollback-patch-2.1-container.sh /mnt/git-log-details.sh /home/core/setup-software/;

echo -e "Trigger/execute git-log-details.sh inside gstudio container (before)"
docker exec -it gstudio /bin/sh -c "/bin/bash /softwares/git-log-details.sh > /softwares/git-log-details-before.log";

echo -e "\nBackup oac-index.html(/home/core/setup-software/oac/index.html) in /mnt/${dir_name}/index-oac-before.html \n" 
rsync -avzPh /home/core/setup-software/oac/index.html /mnt/${dir_name}/index-oac-before.html

echo -e "Trigger/execute  rollback-patch-2.1-container.sh inside gstudio container"
docker exec -it gstudio /bin/sh -c "/bin/bash /softwares/rollback-patch-2.1-container.sh";

echo -e "rename oac and oat dir inside /home/core/setup-software/ to oac-cs.tiss.edu and oat-cs.tiss.edu respectively"
mv /home/core/setup-software/oac /home/core/setup-software/oac-cs.tiss.edu;
mv /home/core/setup-software/oat /home/core/setup-software/oat-cs.tiss.edu;

echo -e "rsync/copy new oac and oat from /mnt/oac-oat to /home/core/setup-software/"
rsync -avzPh /mnt/oac-oat/oac oac-oat/oat /home/core/setup-software/;

echo -e "Trigger/execute git-log-details.sh inside gstudio container (after)"
docker exec -it gstudio /bin/sh -c "/bin/bash /softwares/git-log-details.sh > /softwares/git-log-details-after.log";

echo -e "\nBackup oac-index.html(/home/core/setup-software/oac/index.html) in /mnt/${dir_name}/index-oac-after.html \n" 
rsync -avzPh /home/core/setup-software/oac/index.html /mnt/${dir_name}/index-oac-after.html



# move new oac and oat from /home/core/setup-software/ to /mnt/${dir_name}/ 
rsync -avzPh /home/core/setup-software/git-log-details-before.log /home/core/setup-software/git-log-details-after.log /home/core/data/server_settings.py /home/core/setup-software/git-log-details-before.log /mnt/${dir_name}/;
