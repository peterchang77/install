# K8s Installation Playbook

This Ansible playbook (`install_k8_main.yml`) installs a complete Kubernetes cluster with Docker and NVIDIA GPU support on Ubuntu systems.

## Prerequisites

- Ubuntu system with NVIDIA GPU
- Ansible installed on control node
- SSH access to target host(s) with sudo privileges

## Major Steps

### Stage 1: Docker with NVIDIA GPU Support

1. **Clean existing configuration** - Removes any existing Docker and NVIDIA repository files and GPG keys to prevent conflicts
2. **Install prerequisites** - Installs ca-certificates, curl, and gnupg
3. **Add Docker repository** - Downloads and dearmors Docker GPG key, configures apt repository
4. **Install Docker** - Installs docker-ce, docker-ce-cli, containerd.io, and related plugins
5. **Configure containerd** - Generates default config, enables CRI, sets systemd cgroup driver
6. **Install NVIDIA Container Toolkit** - Adds NVIDIA repository and installs toolkit packages
7. **Configure GPU support** - Configures Docker and containerd for NVIDIA runtime, starts services

### Stage 2: Kubernetes Installation

1. **Configure kernel** - Loads overlay and br_netfilter modules, configures sysctl parameters
2. **Add Kubernetes repository** - Downloads and dearmors K8s GPG key, configures apt repository
3. **Disable swap** - Disables swap temporarily and in /etc/fstab (required by K8s)
4. **Install K8s components** - Installs kubelet, kubeadm, kubectl and marks them on hold
5. **Start kubelet** - Enables and starts the kubelet service

## Usage

```bash
# Run against all hosts in inventory
ansible-playbook -i inventory install_k8_main.yml

# Run against specific host
ansible-playbook -i inventory install_k8_main.yml --limit uci-rtx1
```

## Lessons Learned

### Remove Existing Repository Files and Keychains

Always clean up existing repository files and GPG keys before adding new ones. Broken or outdated keys can cause apt to fail with signature verification errors, and conditional checks based on file existence won't detect corrupted keys.

```yaml
- name: Ensure Docker repository file is absent
  ansible.builtin.file:
    path: /etc/apt/sources.list.d/docker.list
    state: absent
  become: true

- name: Ensure Docker keyring is absent (clean start)
  ansible.builtin.file:
    path: /etc/apt/keyrings/docker.gpg
    state: absent
  become: true
```

### Avoid Shell Pipes for GPG Key Processing

The shell pipe pattern (`curl | gpg`) is fragile and can fail silently or produce invalid output. Use a two-step process with explicit file handling:

**Incorrect (fragile):**
```yaml
- shell: curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.asc
```

**Correct (reliable):**
```yaml
- name: Download Docker GPG key (Armor)
  ansible.builtin.get_url:
    url: https://download.docker.com/linux/ubuntu/gpg
    dest: /tmp/docker.asc
    mode: '0644'
    force: yes
  become: true

- name: Dearmor Docker GPG key
  shell: gpg --dearmor -o /etc/apt/keyrings/docker.gpg /tmp/docker.asc
  args:
    creates: /etc/apt/keyrings/docker.gpg
  become: true
```

This approach:
- Validates the download before processing
- Provides better error handling through ansible modules
- Uses `force: yes` to ensure fresh key downloads
- Allows separate permission setting for the final key file
