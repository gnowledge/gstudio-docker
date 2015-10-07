#!/bin/bash

echo "Script for git pull"

echo "[run] go to the code folder"
cd /home/docker/code/gstudio/gnowsys-ndf/

echo "Execute git pull"
git pull origin mongokit

echo "Execute git status"
git status

