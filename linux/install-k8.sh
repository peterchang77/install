#!/bin/bash

# ======================================================================================
# INSTALL k8 CLUSTER USING kubeadmin
# ======================================================================================
# 
# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
# 
# ======================================================================================

# ======================================================================================
# INSTALL DOCKER 
# ======================================================================================

# --- Set up requirements 
sudo yum install -y yum-utils device-mapper-persistent-data lvm2

# --- Install docker
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum update -y
sudo yum install -y containerd.io-1.2.13 docker-ce-19.03.11 docker-ce-cli-19.03.11

# --- Set up docker daemon
sudo mkdir /etc/docker
echo 'cat > /etc/docker/daemon.json <<EOF
{
      "exec-opts": ["native.cgroupdriver=systemd"],
        "log-driver": "json-file",
        "log-opts": {
            "max-size": "100m"

    },
      "storage-driver": "overlay2",
      "storage-opts": [
          "overlay2.override_kernel_check=true"

      ]

}
EOF' | sudo -s
sudo mkdir -p /etc/systemd/system/docker.service.d
sudo systemctl daemon-reload
sudo systemctl restart docker
sudo systemctl enable docker

# ======================================================================================
# LETTING IPTABLES SEE BRIDGED TRAFFIC 
# ======================================================================================
sudo modprobe br_netfilter
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system

# ======================================================================================
# ENSURE REQUIRED PORTS ARE OPEN 
# ======================================================================================

# ======================================================================================
# INSTALL kubeadm, kubectl, kubelet 
# ======================================================================================

# --- Set up repo
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF

# --- Set SELinux in permissive mode (effectively disabling it)
sudo setenforce 0
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

# --- Install
sudo yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
sudo systemctl enable --now kubelet

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
