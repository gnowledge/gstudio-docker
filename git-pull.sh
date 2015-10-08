#!/bin/bash

echo "Script for git pull"

echo "[run] go to the code folder"
cd /home/docker/code/gstudio/gnowsys-ndf/

echo "[run] Execute git pull"
git pull origin mongokit

echo "[run] Git Pull completed"

echo "[run] Execute git status"
git status

