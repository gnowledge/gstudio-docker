#!/bin/sh
# pass in the file name as an argument: ./mktable filename.csv
echo "create table $1 ( "
head -1 $1 | sed -e 's/,/ varchar(255),\n/g'
echo " varchar(255) );"
