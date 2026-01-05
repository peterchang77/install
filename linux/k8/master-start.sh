#!/bin/bash

set -e

# ======================================================================================
# START CLUSTER (MASTER NODE ONLY)
# ======================================================================================

# Get primary IP address (fallback to hostname if ip command fails)
export K8_HOST=$(ip route get 1 | awk '{print $7}' | head -n 1 2>/dev/null || hostname -I | awk '{print $1}' || hostname)
export K8_PORT=6443

echo "Using K8_HOST: $K8_HOST"
echo "Using K8_PORT: $K8_PORT"

# --- Init
echo "Initializing Kubernetes cluster..."
sudo kubeadm init --apiserver-advertise-address=$K8_HOST --pod-network-cidr=10.244.0.0/16 || {
    echo "ERROR: kubeadm init failed"
    exit 1
}

# --- Init kubectl conf
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# --- Container network interface
echo "Installing Calico CNI..."
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.1/manifests/calico.yaml || {
    echo "ERROR: Calico CNI installation failed"
    exit 1
}

# --- Wait for control plane to be ready
echo "Waiting for control plane to be ready..."
kubectl wait --for=condition=ready node --timeout=300s -l node-role.kubernetes.io/control-plane

# --- Install NVIDIA device plugin
echo "Installing NVIDIA device plugin for GPU support..."
kubectl create -f nvidia-device-plugin.yml || {
    echo "WARNING: NVIDIA device plugin installation failed"
    echo "Note: This is expected on CPU-only nodes"
    echo "GPU nodes should have the device plugin running successfully"
}

# --- Verify GPU resources are available (if any GPU nodes exist)
echo "Checking for GPU resources..."
sleep 10
kubectl get nodes -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.status.allocatable.nvidia\.com/gpu}{"\n"}{end}' 2>/dev/null || echo "No GPU resources found yet"

# --- Get join token and hash
echo "Retrieving join token..."
export K8_TOKEN=$(kubeadm token list | awk 'NR==2 {print $1}')
echo "Retrieving CA certificate hash..."
export K8_HASH=$(openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //')

echo ""
echo "Cluster initialization complete!"
echo ""
echo "Environment variables exported:"
echo "  K8_HOST=$K8_HOST"
echo "  K8_PORT=$K8_PORT"
echo "  K8_TOKEN=$K8_TOKEN"
echo "  K8_HASH=$K8_HASH"
echo ""
echo "To join worker nodes, run:"
echo "  ansible-playbook -i hosts ansible/install_k8_worker.yml"
