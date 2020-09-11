#!/bin/bash

# ======================================================================================
# START CLUSTER (MASTER NODE ONLY) 
# ======================================================================================

# --- Init
sudo kubeadm init --apiserver-advertise-address=172.0.0.117 --pod-network-cidr=10.244.0.0/16

# --- Init kubectl conf
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# --- Container network interface
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
