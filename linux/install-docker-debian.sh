#!/bin/bash

# =======================================================
# DOCKER
# =======================================================
# 
# - Docker runtime
# - Nvidia-Container Toolkit
# - Docker Compose
# 
# =======================================================

# =======================================================
# INSTALL NVIDIA drivers 
# =======================================================
# ubuntu-drivers devices
# sudo ubuntu-drivers autoinstall

# =======================================================
# INSTALL Docker
# =======================================================
echo "Install Docker runtime (y/n)?"
read proceed
if [ $proceed == "y" ]; then
    sudo apt-get update
    sudo apt-get -y install \
        apt-transport-https \
        ca-certificates \
        curl \
        software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) stable"
    sudo apt-get update
    sudo apt-get -y install docker-ce
    sudo systemctl restart docker
fi

# =======================================================
# INSTALL NVIDIA-Container Toolkit 
# =======================================================
echo "Install NVIDIA-Container Toolkit (y/n)?"
read proceed
if [ $proceed == "y" ]; then

    sudo apt-get update

    # --- Remove nvidia-docker2 
    if [ -x "$(command -v nvidia-docker)" ]; then
        sudo apt-get remove nvidia-docker2
    fi

    # --- Upgrade Docker runtime
    sudo apt-get upgrade docker-ce

    distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
    curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
    curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
    sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit nvidia-container-runtime
    sudo systemctl restart docker

fi

# =======================================================
# INSTALL Docker-compose
# =======================================================
echo "Install Docker-compose (y/n)?"
read proceed
if [ $proceed == "y" ]; then
    sudo curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
fi
