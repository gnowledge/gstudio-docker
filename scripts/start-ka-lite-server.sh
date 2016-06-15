#!/bin/bash


echo "Starting ka-lite (kal3) server";
docker run -itd -h ka-lite.net  8180:80
docker start kal3
docker exec -it kal3 bash /etc/init.d/ka-lite start
echo "Started successfully ka-lite (kal3) server";
