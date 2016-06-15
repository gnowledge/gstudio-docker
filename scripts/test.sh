#!/bin/bash                                                                                                                                                         
{
    file=`readlink -e -f $0`
    echo "File : $file"
    file1=`echo $file | sed -e 's/\/scripts.*//'` ; 
    echo "echo $file1 "
    file2=`echo $file1 | sed -e 's/\//\\\\\//g'` ;
#    file3=`echo $file1 | sed -e 's:/:\\\/:g'` ;
    echo "Dir : $file1"
    echo "Dir rep : $file2"
    echo "Dir rep : $file3"
    sed -e "/hHOME/ s/=.*;/=$file2;/" -i  $file1/confs/deploy.conf;
    echo "here"
    more $file1/confs/deploy.conf | grep hHOME; 
#    sed -e '/_INTE/ s/=.*;/="1";/' -i  confs/deploy.conf; 
#    echo "File : $file1/confs/deploy.conf"
}
