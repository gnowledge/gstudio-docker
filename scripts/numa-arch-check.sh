#!/bin/bash

#--------------------------------------------------------------------------------------------------------------#

export GNUM_ARC=NO_IDEA;
num_o=`numactl --show | grep -w "cpubind" | grep -v 'cpubind-' | awk '{gsub("cpubind: ", "");print}'`;
if [ $num_o == "0" ]; then
    echo "Numa arch - No" ;
    export GNUM_ARC=NO;
else
    echo "Numa arch - Yes" ;
    export GNUM_ARC=YES;
fi
