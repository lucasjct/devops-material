#! /bin/sh

curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

sudo su

usermod -aG docker vagrant