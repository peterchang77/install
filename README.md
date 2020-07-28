# Overview

This repository contains install scripts and Docker files for preparing a development environment on a new machine. Note that the recommended approach as outlined in the steps below is to perform all algorithm development, testing and deployment within Dockerized **containers**. This expedites configuration of a new machine as well as ensuring model portability.

Based on this approach the only *required* steps for preparing a new machine for GPU-based training are:

1. Install appropriate NVIDIA drivers (if not done already)
2. Install Docker runtime and Nvidia-container toolkit
3. Install (pull) required Docker images

(*optional*) Instructions for additional installation of common, useful command-line utilities is provided at the end of this README.md.

## Platform Support

**Important**: At this time, these instructions *only* work for Linux-basd operating systems. Currently, Windows Docker does not support the use of NVIDIA GPU in containers. In addition, Mac OS does not support NVIDIA hardware. 

To setup an appropriate development environment on non-Linux operating systems, consider the following steps:

1. Install appropriate NVIDIA drivers (if not done already; see information below)
2. Install CUDA Toolkit 10.1: https://developer.nvidia.com/cuda-toolkit-archive
3. Install cuDNN 7.6: https://developer.nvidia.com/cudnn
4. Install Anaconda (Python package manager): https://docs.anaconda.com/anaconda/install/
5. Install Python dependencies using Anaconda

The 

# Installation

## Install NVIDIA Drivers

If a NVIDIA GPU card was built-in to your current machine upon purchase, then GPU drivers are likely already installed. If you purchased a NVIDIA GPU card separately, then you will likely need to install drivers separately. Note that the NVIDIA drivers needed for your machine will vary based on underlying hardware. If you need to install drivers, please consult the NVIDIA website to find the appropriate driver for your device: https://www.nvidia.com/Download/index.aspx. 

### Linux

To check if any existing drivers are already installed, try the following Bash command:

```bash
$ nvidia-smi
```

If one (or multiple) device(s) are listed, then drivers are installed already. If you are using a Debian-based OS (Ubuntu), the following commands will attempt to automatically identify and install the required packages:

```bash
$ ubuntu-drivers devices
$ sudo ubuntu-drivers autoinstall
```

If you are using another Linux-based OS, please consult the NVIDIA website above.

## Install Docker

A Docker container image is a lightweight, standalone, executable package of software that includes everything needed to run code (dependencies such as runtime, OS, system libraries, etc) in a reliable manner from one computing environment to another. In the context of data science, this will ensure that a uniform development environment and tools (Python and libraries, Jupyter notebook, Linux OS, etc) are available regardless of the underlying operating system and software currently installed on your machine. 

More specifically, several Docker images (details below) have been prepared (pre-installed) with a number of data science tools relevant to medical imaging. Using these images will provide you full access to a Ubuntu-based operating system loaded with Python, Tensorflow and the required dependencies (*regardless* of your native OS). To use these Docker images, the following must be installed:

* Docker runtime engine: baseline software to run containers
* NVIDIA-Container toolkit: enables NVIDIA GPU support for containers

More information about NVIDIA Container Toolkit can be found here: https://github.com/NVIDIA/nvidia-docker. 

### Linux

The `install-docker.sh` script within the `/linux/` subdirectory of this repository installs Docker runtime and the NVIDIA-Container Toolkit. Note that the use of the NVIDIA-Container toolkit decouples the underlying GPU and driver combination (that you just installed above) from the CUDA and cudNN library versions utilized in the Docker container, so that this container should work "out of the box" as long as the underlying NVIDIA GPU drivers are configured properly. 

### Windows

1. Install Docker runtime: https://docs.docker.com/docker-for-windows/install/
2. Install 

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
$ sudo docker pull peterchang77/gpu-full:latest
$ sudo docker pull peterchang77/gpu-lite:latest
$ sudo docker pull peterchang77/cpu-full:latest
$ sudo docker pull peterchang77/cpu-lite:latest
```

# Docker for Data Science

The power of Docker containerization is the ability to consolidate all runtime dependencies (including OS) into a single portable package. The most common use-case of this technology is in the setting of software deployment where an entire application (including necessary source code) is packaged inside a Docker image. When the container is instatiated, a single line of code or script is invoked to launch the prepared application; when complete, the container is removed. 

In the context of data science, several key modifications to the conventional workflow can be implemented to use Docker containers as a persistent environment for active software development. In this strategy, the instantiated container is run *interactively* so that it can be used as a stand-in replacement for your underlying OS to write, test and debug code.

To use a Docker container in this way as an interactive virtual machine, you will need to invoke the `docker run` command with command line flags to:

* run in interative mode (`-it`)
* mount the local file system at several points (`-v`)
* mount the local `.Xauthority` file and copy the `$DISPLAY` env variable for X11 forwarding
* map ports for remote access (e.g. Jupyter, database)

To facilitate invoking `docker run` with the necessary flags, a Bash script has been prepared in the `/scripts/` subdirectory.

```
./docker-run.sh

USAGE: ./docker-run.sh [-options ...] 

Launch a single Docker container

By default, the /home, /data and /mnt folders will be mounted from host

OPTIONS:

  -i or --image         Name of container image to launch (default is gpu-full)
  -n or --name          Name of instantiated container
  -x or --prefix        Prefix of /data and /home to mount (e.g. /mnt/nfs)
  -c or --command       Command to run
  -h or --help          Print help

```

*Examples*

1. Run a new container with the name "jupyter" with (standard) /home folder location:

```bash
$ ./docker-run.sh -n jupyter
```

Then, once **inside** the container , launch JupyterHub:

```bash
$ jupyterhub
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
