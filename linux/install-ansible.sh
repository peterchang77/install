#!/bin/bash

# =============================================================================
# DETERMINE Package Manager
# =============================================================================
if [ -x "$(command -v apt-get)" ]; then
    pm="apt-get"
elif [ -x "$(command -v yum)" ]; then
    pm="yum"
else
    if [ $# -eq 1 ]; then
        pm=$1
    else
        echo "ERROR package manager not recognized, please pass name manually: ./install.sh [package-manager]"
    fi
fi

echo "Using package-manager: $pm"

if [ $pm == "apt-get" ]; then

    sudo apt update
    sudo apt install -y software-properties-common
    sudo apt-add-repository --yes --update ppa:ansible/ansible
    sudo apt install -y ansible

elif [ $pm == "yum" ]; then

    sudo yum install -y ansible

fi
