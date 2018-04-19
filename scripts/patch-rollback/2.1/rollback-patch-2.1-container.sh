#!/bin/bash

# File that will be triggered from host system

# change directory to /home/docker/code/gstudio/gnowsys-ndf/qbank-lite/ 
cd /home/docker/code/gstudio/gnowsys-ndf/qbank-lite/

# git checkout .
git checkout .

# git stash
git stash

# git checkout clixserver branch
git checkout clixserver

