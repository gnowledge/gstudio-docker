#!/bin/bash

# Code for calculating 7 days  --- days
day=$(date  --date="today" +"%Y%m%d");
echo "$day ------ Days";
echo;
i=0;
for (( i=7; i>=1; i-- )); do
    day1=$(date --date="$i days ago" +"%Y%m%d");
    echo "i is $i...                  $day1";
done 

echo;
echo;

# Code for calculating 7 wed   --- weeks
day=$(date --date="today" +"%Y%m%d");
echo "$day ------ Weeks";
echo;
day=$(date --date="this Wed" +"%Y%m%d");
echo "This Wed: $day";
echo;
i=0;
for (( i=7; i>=1; i-- )); do
    day1=$(date --date="this Wed "$i" week ago" +"%Y%m%d");
    echo "i is $i...                  $day1";
done 

# Code for calculating 7 years   --- years
day=$(date --date="today" +"%Y%m%d");
echo "$day ------ Years";
echo;
day=$(date --date="today" +"%Y");
echo "This year: $day";
echo;
i=0;
for (( i=7; i>=1; i-- )); do
    day1=$(date --date="this year "$i" year ago" +"%Y");
    echo "i is $i...                  $day1";
done 

