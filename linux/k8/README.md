# Kubernetes Cluster Installation and Management

This repository provides scripts and Ansible playbooks to install and manage a complete Kubernetes cluster with Docker and NVIDIA GPU support on Ubuntu systems.

## Overview

The installation supports both shell scripts and Ansible automation:
- **Shell Scripts**: Simple, direct installation on individual nodes
- **Ansible Playbooks**: Automated, reproducible installation across multiple nodes

## Prerequisites

- Ubuntu system (tested on recent versions)
- Sudo/root access on target machines
- For NVIDIA GPU support: NVIDIA GPU with compatible drivers
- For Ansible: Ansible installed on control node with SSH access to target hosts
- 2GB+ RAM per node (4GB+ recommended)

**Important**: Before running installations, check the latest Kubernetes version and update the scripts if necessary. Current scripts use K8s v1.35.

## Installation Methods

### Method 1: Shell Scripts (Manual)

This method is suitable for single-node or simple setups where you prefer direct control.

#### Step 1: Install K8 Components on Master Node

```bash
# Run the master installation script
./master-install.sh
```

This script:
- Disables swap (required by Kubernetes)
- Configures kernel modules (overlay, br_netfilter)
- Sets up sysctl parameters for bridge networking
- Configures containerd with systemd cgroup driver
- Installs Kubernetes components (kubelet, kubeadm, kubectl)

#### Step 2: Start the Cluster

```bash
# Initialize and start the cluster on master node
./master-start.sh
```

This script:
- Initializes the Kubernetes cluster using kubeadm
- Sets up kubectl configuration for the current user
- Installs Calico CNI for pod networking
- Outputs join information for worker nodes

After completion, the script exports environment variables:
- `K8_HOST`: Master node IP address
- `K8_PORT`: API server port (default 6443)
- `K8_TOKEN`: Join token for worker nodes
- `K8_HASH`: CA certificate hash for secure join

#### Step 3: Stop the Cluster (Optional)

```bash
# Reset and stop the cluster on master node
./master-stop.sh
```

This resets the Kubernetes configuration but does not remove installed packages.

### Method 2: Ansible Playbooks (Automated)

This method is recommended for multi-node clusters and reproducible deployments.

#### Step 1: Prepare Inventory

Create an Ansible inventory file (e.g., `hosts`) defining your cluster:

```ini
[masters]
master-node ansible_host=192.168.1.10 ansible_user=ubuntu

[workers]
worker-1 ansible_host=192.168.1.11 ansible_user=ubuntu
worker-2 ansible_host=192.168.1.12 ansible_user=ubuntu
```

#### Step 2: Install K8 Components on All Nodes

**Important**: Run this playbook on ALL nodes (both master and workers). Every Kubernetes node requires Docker, containerd, and Kubernetes packages to function properly.

```bash
# Install on ALL nodes (master and workers)
ansible-playbook -i hosts ansible/install_k8_main.yml

# Install on specific node
ansible-playbook -i hosts ansible/install_k8_main.yml --limit master-node
ansible-playbook -i hosts ansible/install_k8_main.yml --limit worker-1
```

The playbook performs the following stages:

**Stage 0: Cleanup**
- Removes old repository files and GPG keys to prevent conflicts

**Stage 1: Docker with NVIDIA GPU Support**
- Installs prerequisites (ca-certificates, curl, gnupg)
- Adds Docker repository with proper GPG key handling
- Installs Docker CE, containerd, and build plugins
- Configures containerd with CRI and systemd cgroup driver
- Installs NVIDIA Container Toolkit
- Configures Docker and containerd for NVIDIA runtime
- Enables Docker and containerd services

**Stage 2: Kubernetes Installation**
- Loads and persists kernel modules (overlay, br_netfilter)
- Configures sysctl parameters for bridge networking
- Adds Kubernetes repository
- Disables swap (temporarily and permanently)
- Installs kubelet, kubeadm, and kubectl
- Holds Kubernetes packages to prevent auto-upgrade
- Starts and enables kubelet service

#### Step 3: Initialize Master and Start Cluster

After `install_k8_main.yml` completes successfully on ALL nodes (master and workers), SSH into the master node and run:

```bash
# On the master node
./master-start.sh
```

This will initialize the cluster and provide join information.

#### Step 4: Join Worker Nodes

Once the master cluster is initialized, join worker nodes:

```bash
# Export variables from master-start.sh output
export K8_HOST=<master-ip>
export K8_PORT=6443
export K8_TOKEN=<token-from-master>
export K8_HASH=<hash-from-master>

# Run the worker installation playbook
ansible-playbook -i hosts ansible/install_k8_worker.yml
```

The worker playbook:
- Resets any existing K8 configuration
- Stops kubelet and cleans CNI/Calico artifacts
- Starts kubelet service
- Joins the cluster using provided credentials

#### Step 5: Cleanup Worker Nodes (Optional)

To remove worker nodes from the cluster:

```bash
# Run cleanup playbook on worker nodes
ansible-playbook -i hosts ansible/cleanup_k8_worker.yml
```

This resets the worker node configuration but does not uninstall packages.

## Cluster Operations

### Verify Cluster Status

```bash
# On master node
kubectl get nodes
kubectl get pods --all-namespaces
```

### Access Worker Nodes

After joining, verify worker node status:

```bash
# On master node
kubectl get nodes -o wide
```

### Troubleshooting

**Common Issues:**

1. **Container Runtime Issues**: Check containerd and Docker status
   ```bash
   sudo systemctl status containerd
   sudo systemctl status docker
   ```

2. **Kubelet Not Starting**: Check logs and swap status
   ```bash
   sudo journalctl -u kubelet -f
   free -h  # Verify swap is disabled
   ```

3. **Network Issues**: Check Calico pods
   ```bash
   kubectl get pods -n kube-system
   ```

4. **GPU Support**: Verify NVIDIA runtime
   ```bash
   nvidia-smi
   docker run --rm --gpus all nvidia/cuda:11.0.3-base-ubuntu20.04 nvidia-smi
   ```

## Lessons Learned

### Repository and Keyring Management

Always clean up existing repository files and GPG keys before adding new ones. Broken or outdated keys can cause apt to fail with signature verification errors.

The Ansible playbook includes proper cleanup steps before installation.

### GPG Key Processing Best Practices

Avoid shell pipes (`curl | gpg`) as they are fragile and can fail silently. The Ansible playbook uses a reliable two-step approach:

1. Download GPG key to temp file using `get_url` module
2. Dearmor using explicit shell command with error handling

This provides better validation, error handling, and reliability.

### Version Management

Before running installations:
1. Check latest Kubernetes version: `https://pkgs.k8s.io/core:/stable/`
2. Update version references in `master-install.sh` and `ansible/install_k8_main.yml`
3. Verify Docker and NVIDIA toolkit compatibility

### Package Hold

Kubernetes packages (kubelet, kubeadm, kubectl) are marked as `hold` to prevent automatic upgrades that could break the cluster. To upgrade intentionally:

```bash
sudo apt-mark unhold kubelet kubeadm kubectl
sudo apt update
sudo apt install kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
```

## References

- [Kubernetes Documentation](https://kubernetes.io/docs/home/)
- [kubeadm Installation Guide](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/)
- [Docker Installation](https://docs.docker.com/engine/install/ubuntu/)
- [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)
