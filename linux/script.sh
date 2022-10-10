#! /bin/bash

###### Provisionamento servidor web apache2 #######
######              10/22                   #######

sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install apache2 -y
sudo apt-get install unzip


cd /tmp
wget https://github.com/denilsonbonatti/linux-site-dio/archive/refs/heads/main.zip
unzip main.zip

cd linux-site-dio-main
cp -R * /var/www/html/
