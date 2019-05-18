#!/bin/bash

# --- Install NVIDIA drivers
# ubuntu-drivers devices
# sudo ubuntu-drivers autoinstall

# --- Install Docker
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

# --- Install NVIDIA-Docker (Debian)
# curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | \
#       sudo apt-key add -
# distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
# curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | \
#       sudo tee /etc/apt/sources.list.d/nvidia-docker.list
# sudo apt-get update
# sudo apt-get install -y nvidia-docker2
# sudo pkill -SIGHUP dockerd

# --- Install NVIDIA-Docker (RHEL)
# distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
# curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.repo | \
#       sudo tee /etc/yum.repos.d/nvidia-docker.repo
# sudo yum install nvidia-docker2
# sudo pkill -SIGHUP dockerd

# --- Install Docker-compose
# curl -L https://github.com/docker/compose/releases/download/1.23.0-rc2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
# chmod +x /usr/local/bin/docker-compose

# --- Pull Docker Images

# =======================================================
# MongoDB
# =======================================================
# 
# sudo docker run -it --rm -p 27017:27017 -v [local]:[remove] mongo:xenial
# 
# =======================================================

# sudo docker pull library/mongo:xenial
# sudo docker pull mongo:4.1.10-bionic

# =======================================================
# CNN-GPU environment 
# =======================================================
# 
# sudo nvidia-docker run -it --rm -v $HOME:/home/peter --net="host" peterchang77/cnn-gpu:0.5
# 
# =======================================================

# sudo docker pull peterchang77/cnn-gpu:0.5
# sudo docker pull peterchang77/cnn-cpu:0.5
