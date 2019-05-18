#!/bin/bash

# --- Install nfs
# sudo apt-get -y install nfs-common

# --- Make mount directory
# sudo mkdir /media/efs

# --- NFS mount instructions in fstab
# echo -e "fs-5d2e88f4.efs.us-west-2.amazonaws.com:/\t/media/efs\tnfs4\tnfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,_netdev\t0\t0" | sudo tee -a /etc/fstab

# --- Build essential (GCC, make, etc) 
# sudo apt-get update 
# sudo apt-get install build-essential 
# sudo apt-get install unzip

# --- Java
# sudo add-apt-repository ppa:openjdk-r/ppa
# sudo apt-get install openjdk-8-jdk
# sudo apt-get install icedtea-netx
