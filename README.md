# Overview

This repository contains install scripts and Docker files for preparing a development environment on a new Linux machine. Note that the recommended approach as outlined in the steps below is to perform all algorithm development, testing and deployment within Dockerized **containers**. This expedites configuration of a new machine as well as ensuring model portability.

Based on this approach the only *required* steps for preparing a new machine for GPU-based training are:

1. Install appropriate NVIDIA drivers (if not done already)
2. Install Docker runtime and Nvidia-container toolkit
3. Install (pull) required Docker images

To facilitate installation, Bash scripts are provided in the `/linux/` subdirectory of this repository. By default each line of the Bash script is commented out. As needed uncomment the portions of the script relevant to your task before running.

(*optional*) Instructions for additional installation of common, useful command-line utilities is provided at the end of this README.md.

1. Installation scripts (in `/scripts/` folder)
2. Running containers, Jupyter, databased (in `/run/` folder)

# Installation

## Install NVIDIA Drivers

The NVIDIA drivers needed for your machine will vary based on underlying hardware. To check if any existing drivers are already installed, try the following command:

```bash
$ nvidia-docker
```

If one (or multiple) device(s) are listed, then drivers are installed already. If you need to install drivers, please consult the Nvidia website to find the appropriate driver for your device: https://www.nvidia.com/Download/index.aspx. If you are using a Debian-based OS (Ubuntu), the following commands will attempt to automatically identify and install the required packages:

```bash
$ ubuntu-drivers devices
$ sudo ubuntu-drivers autoinstall
```

## Install Docker

The `install-docker.sh` script within the `/linux/` subdirectory of this repository installs Docker runtime and the NVIDIA-Container Toolkit. Note that the use of the NVIDIA-Container toolkit decouples the underlying GPU and driver combination (that you just installed above) from the CUDA and cudNN library versions utilized in the Docker container, so that this container should work "out of the box" as long as the underlying Nvidia GPU is configured properly. 

More information about NVIDIA Container Toolkit can be found here: https://github.com/NVIDIA/nvidia-docker. 

## Pulling Docker Images

The following commands will pull (download) Docker images that I have created preconfigured with the necessary software and libraries for developing machine learning (and deep learning) algorithms in Python. The full Dockerfiles can be found in the `/docker/` subdirectory of the repository. For those that are interested in building the Python virtual environment manually, the corresponding Conda `*.yml` files can also be found in the respective Docker build diretories. 

There are a total of four versions of my prebuilt Docker images. The `full` versions of the images contain many useful Python modules and other software tools to reproduce a comprehensive development environment. The `lite` versions of the images contain only the minimum necessary modules to run models in a production environment. 

All Docker images are built using Tensorflow 2.0 and Python 3.6. In addition the following lists an overview of available Python modules and software:

*Python*

* ipython, ipdb (\*)
* jupyterlab, jupyterhub
* cython (\*)
* pydicom, gdcm, mudicom (\*)
* nibabel, simpleitk
* pillow, opencv
* openslide
* requests, dill, h5py, pyyaml (\*)
* scipy, scikit-image, scikit-learn (\*)
* pandas (\*)
* xlrd
* seaborn
* flask, flask-socketio
* pymongo (\*)
* redis (\*)

*Other*

* utilities (zsh, vim, wget, curl, bzip2, etc) (\*)
* OpenSlide
* X11 

(\*) indicates subset of tools available in `lite`

In addition, all Docker images are compiled as either `gpu` or `cpu` versions (the primary difference relates to Tensorflow binaries). 

To download the necessary Docker image(s) use the following commands:

```bash
$ sudo docker pull peterchang77/gpu-full:1.0
$ sudo docker pull peterchang77/gpu-lite:1.0
$ sudo docker pull peterchang77/cpu-full:1.0
$ sudo docker pull peterchang77/cpu-lite:1.0
```

# Running Docker Images

To use Docker as an interactive virtual machine, you will need to invoke a handful of command line flags to:

* run in interative mode (`-it`)
* mount the local file system at several points (`-v`)
* mount the local `.Xauthority` file and copy the `$DISPLAY` env variable for X11 forwarding
* map ports for remote access (e.g. Jupyter, database)

Furthermore, the all `full` versions of the Docker images have been configured to forward all local users (and passwords) into the Docker container, which allows for PAM authentication directly in the virtual environment (e.g. JupyterHub login).

All these configurations have been precompiled in the following Bash run scripts based in the `/scripts/` subdirectory.

* `./docker-run-gpu-full`
* `./docker-run-gpu-lite`
* `./docker-run-cpu-full`
* `./docker-run-cpu-lite`

**Usage**

```bash
$ ./docker-run-cnn [name] [prefix]
```

Here `[name]` represents the name you give to the Docker container. In addition the script will attempt to mount your local OS home folder into the Docker environment. The location of home is assumed to be `/home` unless an additional `[prefix]` is provided (e.g. if your home folder is mounted via NFS, etc). 

*Examples*

Run a new container with the name "jupyter" with (standard) /home folder location:

```bash
$ ./docker-run-gpu-full jupyter
```

Run a new container with the name "jupyter" with /mnt/nfs/home folder location:

```bash
$ ./docker-run-gpu-full jupyter /mnt/nfs
```

# Linux Utilities

A number of Bash scripts are prepared in the `/linux/` subdirectory of this repository to install several commonly used tools for improved workflow, terminal session management, etc. As before, each line in the provided Bash scripts are commented out by default; to use simply identify the items you wish to install and uncomment / re-comment as need.

## install.sh

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

```bash
$ ./install.sh [package-manager]
```

... where [package-manager] => apt-get, yum, brew, etc depending on OS.

## install-aws.sh

If you are using a brand new AWS instance, there are a handful of commands that are useful for mounting a filesystem via NFS and downloading some commonly used dependencies (GCC, Java, etc) that AWS does not include by default.

