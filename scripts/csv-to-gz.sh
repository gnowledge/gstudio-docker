#!/bin/sh

# create gz of the file name passed as argument

gzip -c $1 > $1.gz
