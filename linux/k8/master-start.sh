#!/bin/bash

# ======================================================================================
# START CLUSTER (MASTER NODE ONLY) 
# ======================================================================================

export K8_HOST=export K8_HOST=$(host $(hostname) | awk '/has address / {print $4}')
export K8_PORT=6443

# --- Init
sudo kubeadm init --apiserver-advertise-address=$K8_HOST --pod-network-cidr=10.244.0.0/16

# --- Init kubectl conf
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# --- Container network interface
kubectl apply -f kube-flannel.yml
