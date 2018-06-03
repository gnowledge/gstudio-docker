#!/bin/bash

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

echo -e "\n${cyan}copy files (drop_database.sql and pg_dump_all_working.sql) in /home/core/data ${reset}"
rsync  -avPh  /mnt/drop_database.sql  /mnt/pg_dump_all_working.sql  /home/core/data/

echo -e "\n${cyan}school server instance config - setting postgres database ${reset}"
docker exec -it gstudio /bin/sh -c "echo 'psql -f /data/drop_database.sql;' | sudo su - postgres"
docker exec -it gstudio /bin/sh -c "echo 'psql -f /data/pg_dump_all_working.sql;' | sudo su - postgres"

cd /home/core/
docker-compose restart

exit