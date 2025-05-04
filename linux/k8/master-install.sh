#!/bin/bash

# ======================================================================================
# INSTALL k8 CLUSTER USING kubeadm on Debian-based OS 
# ======================================================================================
# 
# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
# 
# ======================================================================================
# PREREQUISITES
# ======================================================================================
#
# Docker (see install-docker.sh)
#
# ======================================================================================

# ======================================================================================
# TURN OFF SWAP 
# ======================================================================================
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# ======================================================================================
# LETTING IPTABLES SEE BRIDGED TRAFFIC 
# ======================================================================================
sudo modprobe overlay
sudo modprobe br_netfilter

sudo tee /etc/modules-load.d/k8s.conf <<EOF
overlay
br_netfilter
EOF

sudo tee /etc/sysctl.d/k8s.conf <<EOF
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

sudo sysctl --system

# ======================================================================================
# CONFIGURE CONTAINERD 
# ======================================================================================
sudo mkdir -p /etc/containerd
sudo sh -c "containerd config default > /etc/containerd/config.toml"
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml
sudo systemctl restart containerd

# ======================================================================================
# INSTALL kubeadm, kubectl, kubelet 
# ======================================================================================

# --- Set up repo
sudo apt-get update
sudo apt-get install curl ca-certificates apt-transport-https  -y
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list

# --- Install
sudo apt update
sudo apt install kubelet kubeadm kubectl -y
