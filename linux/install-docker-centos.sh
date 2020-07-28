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
# wget http://us.download.nvidia.com/XFree86/Linux-x86_64/440.59/NVIDIA-Linux-x86_64-440.59.run
# sudo systemctl isolate multi-user.target
# sudo bash NVIDIA-Linux-x86_64-440.59.run

# =======================================================
# INSTALL Docker
# =======================================================
echo "Install Docker runtime (y/n)?"
read proceed
if [ $proceed == "y" ]; then
    sudo yum install -y yum-utils
    sudo yum-config-manager \
        --add-repo \
        https://download.docker.com/linux/centos/docker-ce.repo
    sudo yum install docker-ce docker-ce-cli containerd.io
    sudo systemctl start docker
fi

# =======================================================
# INSTALL NVIDIA-Container Toolkit 
# =======================================================
echo "Install NVIDIA-Container Toolkit (y/n)?"
read proceed
if [ $proceed == "y" ]; then

    sudo yum update

    # --- Remove nvidia-docker2 
    if [ -x "$(command -v nvidia-docker)" ]; then
        sudo yum remove nvidia-docker2
    fi

    # --- Upgrade Docker runtime
    sudo yum upgrade docker-ce

    distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
    curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.repo | sudo tee /etc/yum.repos.d/nvidia-docker.repo
    sudo yum install -y nvidia-container-toolkit
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
