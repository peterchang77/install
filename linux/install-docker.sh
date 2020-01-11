#!/bin/bash

# =======================================================
# DOCKER
# =======================================================
# - Nvidia drivers
# - Docker runtime
# - Nvidia-Container Toolkit
# - Docker Compose
# 
# NOTE: this script is for Debian-based OS. Consider
# minor updates for alternative package managers.
# =======================================================

# =======================================================
# INSTALL NVIDIA drivers
# =======================================================
# ubuntu-drivers devices
# sudo ubuntu-drivers autoinstall

# =======================================================
# INSTALL Docker
# =======================================================
# sudo apt-get update
# sudo apt-get -y install \
#     apt-transport-https \
#     ca-certificates \
#     curl \
#     software-properties-common
# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
# sudo add-apt-repository \
#    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
#     $(lsb_release -cs) stable"
# sudo apt-get update
# sudo apt-get -y install docker-ce

# =======================================================
# INSTALL NVIDIA-Container Toolkit 
# =======================================================
# sudo apt-get remove nvidia-docker2
# sudo apt-get upgrade docker-ce
# distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
# curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
# curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
# sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
# sudo systemctl restart docker

# =======================================================
# INSTALL Docker-compose
# =======================================================
# sudo curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
# sudo chmod +x /usr/local/bin/docker-compose

# =======================================================
# MongoDB
# =======================================================
# sudo docker pull mongo:4.1.10-bionic

# =======================================================
# RedisDB 
# =======================================================
# sudo docker pull redis:5.0.5 
