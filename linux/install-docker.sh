#!/bin/bash

# =======================================================
# DOCKER
# =======================================================
# - Nvidia drivers
# - Docker runtime
# - Nvidia-Container Toolkit
# - Docker Compose
# 
# =======================================================

# =======================================================
# INSTALL NVIDIA drivers
# =======================================================
# --- Debian
# ubuntu-drivers devices
# sudo ubuntu-drivers autoinstall
# 
# --- CentOS
# wget http://us.download.nvidia.com/XFree86/Linux-x86_64/440.59/NVIDIA-Linux-x86_64-440.59.run
# sudo systemctl isolate multi-user.target
# sudo bash NVIDIA-Linux-x86_64-440.59.run

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
# --- Debian
# sudo apt-get remove nvidia-docker2
# sudo apt-get upgrade docker-ce
# distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
# curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
# curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
# sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
# sudo systemctl restart docker

# --- CentOS
# DIST=$(sed -n 's/releasever=//p' /etc/yum.conf)
# DIST=${DIST:-$(. /etc/os-release; echo $VERSION_ID)}
# sudo rpm -e gpg-pubkey-f796ecb0
# sudo gpg --homedir /var/lib/yum/repos/$(uname -m)/$DIST/*/gpgdir --delete-key f796ecb0
# sudo gpg --homedir /var/lib/yum/repos/$(uname -m)/latest/nvidia-docker/gpgdir --delete-key f796ecb0
# sudo gpg --homedir /var/lib/yum/repos/$(uname -m)/latest/nvidia-container-runtime/gpgdir --delete-key f796ecb0
# sudo gpg --homedir /var/lib/yum/repos/$(uname -m)/latest/libnvidia-container/gpgdir --delete-key f796ecb0
# sudo yum update
# sudo yum remove nvidia-docker2
# sudo yum upgrade docker-ce
# # =======================================================
# # distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
# # curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.repo | sudo tee /etc/yum.repos.d/nvidia-docker.repo
# # sudo yum install -y nvidia-container-toolkit
# # =======================================================
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
