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
# Desktop: 
# sudo ubuntu-drivers list 
# sudo ubuntu-drivers install
# =======================================================
# Servers: 
# sudo ubuntu-drivers list --gpgpu
# sudo ubuntu-drivers install --gpgpu
# =======================================================

# =======================================================
# INSTALL Docker
# =======================================================
echo -n "Install Docker runtime (y/n)? "
read proceed
if [ $proceed == "y" ]; then

    # --- Add Docker's official GPG key:
    sudo apt-get update
    sudo apt-get install ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    # --- Add repo 
    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
        $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    # --- Update
    sudo apt-get update

    # --- Install
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
fi

# =======================================================
# INSTALL NVIDIA-Container Toolkit 
# =======================================================
echo -n "Install NVIDIA-Container Toolkit (y/n)? "
read proceed
if [ $proceed == "y" ]; then

    # --- Add repo 
    curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
        && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
        sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
        sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

    # --- Update
    sudo apt-get update

    # --- Install
    sudo apt-get install -y \
        nvidia-container-toolkit \
        nvidia-container-toolkit-base \
        libnvidia-container-tools \
        libnvidia-container1

    # -- Configure
    sudo nvidia-ctk runtime configure --runtime=docker

    # --- Add no-cgroups = false
    sudo sed -i '/no-cgroups/s/^#//g' /etc/nvidia-container-runtime/config.toml

    # --- Restart docker
    sudo systemctl restart docker

fi
