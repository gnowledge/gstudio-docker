#!/bin/bash

# ---------------------------------------------
# Help text starts here

#Ref : - http://www.cyberciti.biz/faq/how-do-i-add-jobs-to-cron-under-linux-or-unix-oses/

# List all your cron jobs
#crontab -l

# List all your cron jobs of specific user
#crontab -u username -l

# Remove / delete all your cron jobs
#crontab -d

# Remove / delete all your cron jobs of specific user
#crontab -u username -d

# * * * * * command to be executed
# - - - - -
# | | | | |
# | | | | ----- Day of week (0 - 7) (Sunday=0 or 7)
# | | | ------- Month (1 - 12)
# | | --------- Day of month (1 - 31)
# | ----------- Hour (0 - 23)
# ------------- Minute (0 - 59)

# Your cron job looks as follows for system jobs:
# 1 2 3 4 5 USERNAME /path/to/command arg1 arg2
# OR
# 1 2 3 4 5 USERNAME /path/to/script.sh


# Few examples

# To run /path/to/command five minutes after midnight, every day, enter:
# 5 0 * * * /path/to/command

# Run /path/to/script.sh at 2:15pm on the first of every month, enter:
# 15 14 1 * * /path/to/script.sh

# Run /scripts/phpscript.php at 10 pm on weekdays, enter:
# 0 22 * * 1-5 /scripts/phpscript.php

# Run /root/scripts/perl/perlscript.pl at 23 minutes after midnight, 2am, 4am ..., everyday, enter:
# 23 0-23/2 * * * /root/scripts/perl/perlscript.pl

# Run /path/to/unixcommand at 5 after 4 every Sunday, enter:
# 5 4 * * sun /path/to/unixcommand
# How do I use operators?

# An operator allows you to specifying multiple values in a field. There are three operators:

# The asterisk (*) : This operator specifies all possible values for a field. For example, an asterisk in the hour time field would be equivalent to every hour or an asterisk in the month field would be equivalent to every month.
# The comma (,) : This operator specifies a list of values, for example: "1,5,10,15,20, 25".
# The dash (-) : This operator specifies a range of values, for example: "5-15 days" , which is equivalent to typing "5,6,7,8,9,....,13,14,15" using the comma operator.
# The separator (/) : This operator specifies a step value, for example: "0-23/" can be used in the hours field to specify command execution every other hour. Steps are also permitted after an asterisk, so if you want to say every two hours, just use */2.




# Special     stringMeaning
# @reboot     Run  once, at startup.
# @yearly     Run  once a year, "0 0 1 1 *".
# @annually   (same as @yearly)
# @monthly    Run once a month, "0 0 1 * *".
# @weekly     Run  once a week, "0 0 * * 0".
# @daily      Run   once a day, "0 0 * * *".
# @midnight   (same as @daily)
# @hourly     Run once an hour, "0 * * * *".

# Help text completes here
# ---------------------------------------------


#write out current crontab
crontab -l > mycron


# print the existing cron
echo -e "\n-------------------existing cron is starting here---------------------\n"
more mycron
echo -e "\n-------------------existing cron is ending here---------------------\n"


Command='docker ps';
Date_time='@reboot';             # * * * * * or @daily @weekly @monthly 
Output_redirections=' >> /tmp/cron-job-custom.log'
File=`readlink -e -f mycron`;
echo "File name : $File "

# check for no of matched line with our commands
got_match=$(sed -n "/$Command/p" $File | wc -l)

if [[ "$got_match" != "0" ]]  &&  [ -f $File ] ; then 
    sed -e "/$Command/ s/^\s*#*/#/" -i $File       # Example for path (log file path) search and uncomment line
    #sed -e '/\/tmp\/t.log/ s/^\s*#*/#/' -i mycron     # Example for path (log file path) search and comment line
    #sed -e '/hello/ s/^\s*#*//' -i mycron             # Example for word search and uncomment line
    #echo "Mrunal-$got_match---00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"

    #remove matched line
  #  got=$(sed -i.bak "/$Command/d" $File )          # Delete lines in a text file that containing a specific string - with backup file
    #echo "Mrunal-$got---00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
    #sed '/pattern to match/d' mycron                  # Delete lines in a text file that containing a specific string - without backup file
    #sed -i.bak '/pattern to match/d' mycron           # Delete lines in a text file that containing a specific string - with backup file
elif [[ -f $File ]] ; then
    #echo new cron into cron file
    echo "$Date_time $Command $Output_redirections" >> $File  # Delete lines in a text file that containing a specific string - without backup file
elif [[ ! -f $File ]] ; then
    #echo file does not exist
    echo -e "File does not exist - $File" 
fi


# print the new cron changes
echo -e "\n-------------------new cron changes is starting here---------------------\n"
more $File
echo -e "\n-------------------new cron changes is ending here---------------------\n"


# install / apply new cron file
crontab mycron


# print the new cron jobs
echo -e "\n-------------------new cron jobs is starting here---------------------\n"
crontab -l
echo -e "\n-------------------new cron jobs is ending here---------------------\n"

# remove the mycron file
#rm $File
