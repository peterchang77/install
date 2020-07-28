#!/bin/bash

# ================================================================
# AWS 
# ================================================================
# - NFS
# - build essential (gcc, etc)
# - java
# ================================================================

# ================================================================
# NFS  
# ================================================================
echo "Install NFS (e.g. support for Amazon EFS or other similar file systems) (y/n)?"
read proceed

if [ $proceed == "y" ]; then

    sudo apt-get -y install nfs-common
    sudo mkdir /media/efs

    # --- NFS mount instructions in fstab
    echo "Enter remote NFS address (e.g. [xxx].us-west-2.amazonaws.com):"
    read address
    echo -e "$address:/\t/media/efs\tnfs4\tnfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,_netdev\t0\t0" | sudo tee -a /etc/fstab

fi

# ================================================================
# BUILD ESSENTIAL 
# ================================================================
sudo apt-get update 
sudo apt-get install build-essential 
sudo apt-get install unzip

# ================================================================
# JAVA 
# ================================================================
sudo add-apt-repository ppa:openjdk-r/ppa
sudo apt-get install openjdk-8-jdk
sudo apt-get install icedtea-netx
