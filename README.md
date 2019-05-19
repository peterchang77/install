# Overview

1. Installation scripts (in `/scripts/` folder)
2. Running containers, Jupyter, databased (in `/run/` folder)

# Installation

A number of Bash scripts are prepared in the `/scripts/` folder to install and configure a new machine with commonly used tools and libraries for data science in Python. Each line in the scripts are commented out by default; to use simply identify the items you wish to install and uncomment / re-comment as need.

0. `./scripts/install.sh` (optional)

This script installs a handful of common Linux tools, including:

* vim (including Vundle, .vimrc configuration file, colors and plugins)
* python3
* silversearcher-ag
* tmux and zsh
* git
* zsh
* mongodb

Note that the formal Python development environment is provided in Docker containers described below.

**Usage**

`>> ./install.sh [package-manager]`, where:

[package-manager] = apt-get, yum, brew, etc depending on OS 

1. `./scripts/install-docker.sh`

This script installs Nvidia drivers, Docker, Nvidia-Docker and pulls my pre-built Docker images with all the requisite Python dependencies. Note that the use of Nvidia-Docker decouples the underlying GPU and driver combination from the CUDA and cudNN library versions utilized in the Docker container, so that this container should work "out of the box" as long as the underlying Nvidia GPU is configured properly. Note that the command for auto install of Nvidia drivers is a new function in Ubuntu 18.04+; for other OS you will have to manually install the needed drivers.

## Pulling Docker Images

After installing Docker, you will need to either configure your own Docker image or retrieve a preconfigured image developed by somebody else. For the purposes of developing machine learning (and deep learning) algorithms in Python, I have several preconfigured Docker images (one each for CPU and GPU machines). The images can be pulled with the following commands:

* `>> sudo docker pull peterchang77/cnn-cpu:0.5`
* `>> sudo docker pull peterchang77/cnn-gpu:0.5`

The image is prebuilt with JupyterLab and Python libraries / toolbox versions including:

* CUDA 9.0 toolbox
* cudNN 7.0 libraries
* Python 3.5
* Anaconda
* Tensorflow 1.9
* Keras 2.2.2
* Medical imaging packages: pydicom, gdcm
* Data science packages: jupyter, pandas, scipy, scikit-learn, cv2, matplotlib, ipdb, etc
* Linux utilities: zsh, vim, tmux, git, silversearcher-ag, etc
* NodeJS

2. `./scripts/install-aws.sh` 

If you are using a brand new AWS instance, there are a handful of commands that are useful for mounting a filesystem via NFS and downloading some commonly used dependencies (GCC, Java, etc) that AWS does not include by default.

# Running Docker images

To use Docker as an interactive virtual machine, you will need to use a handful of command line flags to:

* run in interative mode (`-it`)
* mount the local file system at several points (`-v`)
* mount the local `.Xauthority` file and copy the `$DISPLAY` env variable for X11 forwarding
* map ports for remote access (e.g. Jupyter, database)

Furthermore, the container has been configured to copy all the local users (and passwords) and home directories, which allows for PAM authentication directly in the virtual environment (e.g. JupyterHub login).

All these configurations have been precompiled in the following Bash run scripts based on GPU or CPU mode and/or Mac OS:

* `./run/docker-run-cnn-gpu`
* `./run/docker-run-cnn-cpu`
* `./run/docker-run-cnn-mac`

**Usage**

`>> ./docker-run-cnn [name] [prefix]`, where:

[name]   = name of Docker container 
[prefix] = prefix to /home folder(s)

*Examples*

Run a new "jupyter" containiner with default /home folder location:

`>> ./docker-run-cnn jupyter`

Run a new "jupyter" containiner with /mnt/nfs/home folder location:

`>> ./docker-run-cnn jupyter /mnt/nfs`
