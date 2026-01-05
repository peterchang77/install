# Overview

This repository contains install scripts and Docker files for preparing a development environment on a new machine. Note that the recommended approach as outlined in the steps below is to perform all algorithm development, testing and deployment within Dockerized **containers**. This expedites configuration of a new machine as well as ensuring model portability.

Based on this approach the only *required* steps for preparing a new machine for GPU-based training are:

1. Install appropriate NVIDIA drivers (if not done already)
2. Install Docker runtime and Nvidia-container toolkit
3. Install (pull) required Docker images

### Install dependencies with Conda

There are a total of four different prebuilt environments depending on whether GPU or CPU hardware is available and whether a larger `full` or smaller `lite` installation is preferred. See information about [Pulling Docker Images](#pulling-docker-images) below for further details.

For each environment, a corresponding Conda `*.yml` file is available in the `/docker/` subdirectory. Use the `conda env create -f [file]` command to install the dependencies specified in the `*.yml` file of choice:

```bash
$ conda env create -y [path/to/repo/]docker/gpu-full/environment.yml, OR
$ conda env create -y [path/to/repo/]docker/gpu-lite/environment.yml, OR
$ conda env create -y [path/to/repo/]docker/cpu-full/environment.yml, OR
$ conda env create -y [path/to/repo/]docker/cpu-lite/environment.yml
```

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
$ sudo ubuntu-drivers list 
$ sudo ubuntu-drivers install
```

If you are using another Linux-based OS, please consult the NVIDIA website above.

## Install Docker

A Docker container image is a lightweight, standalone, executable package of software that includes everything needed to run code (dependencies such as runtime, OS, system libraries, etc) in a reliable manner from one computing environment to another. In the context of data science, this will ensure that a uniform development environment and tools (Python and libraries, Jupyter notebook, Linux OS, etc) are available regardless of the underlying operating system and software currently installed on your machine. 

More specifically, several Docker images (details below) have been prepared (pre-installed) with a number of data science tools relevant to medical imaging. Using these Docker images will provide you full access to a Ubuntu-based operating system loaded with Python, Tensorflow and the required dependencies (*regardless* of your native OS). To use these Docker images, the following must be installed:

* Docker runtime engine (baseline software to run containers): https://docs.docker.com/engine/install
* NVIDIA-Container toolkit (enables NVIDIA GPU support for containers): https://github.com/NVIDIA/nvidia-container-toolkit 

Note that the use of the NVIDIA-Container toolkit decouples the underlying GPU and driver combination (that you just installed above) from the CUDA and cuDNN library versions utilized in the Docker container, so that this container should work "out of the box" as long as the underlying NVIDIA GPU drivers are configured properly.

### Linux

For Debian-based Linux systems, Bash scripts for installing Docker runtime, NVIDIA-container toolkit and Docker Compose (optional) are provided in the `/linux/` subdirectory of this repository:

* `linux/install-docker.sh` 

Simply run the scripts and follow the prompts. If there is an error, recommend manual installation via the official Docker links above.

## Pulling Docker Images

Once Docker has been installed, the prebuilt Docker images need to be downloaded. The following commands will pull (download) Docker images that I have created preconfigured with the necessary software and libraries for developing machine learning (and deep learning) algorithms in Python. The full Dockerfiles can be found in the `/docker/` subdirectory of the repository for those interested in manually building (and modifying) the Docker images. Alternatively, the Python virtual environments (managed via Conda) installed on the Docker images are availabe in the corresponding Conda `*.yml` files in the respective Docker build directories; see above [Install dependencies with Conda](#install-dependencies-with-conda) for more information. 

There are a total of four versions of my prebuilt Docker images. The `full` versions of the images contain many useful Python modules and other software tools to reproduce a comprehensive development environment. The `lite` versions of the images contain only the minimum necessary modules to run models in a production environment. 

All Docker images are built using TensorFlow/Keras. In addition the following lists an overview of available Python modules and software:

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

To use a Docker container in this way as an interactive virtual machine, you will need to invoke the `docker run` command with the `-it` flag. A number of additional command line flags may also be used to enable specific functionality. At minimum, the following `docker run` command is recommended to launch a single interative container:

```bash
$ sudo docker run -it --rm --net="host" -v /data:/data --name my_container peterchang77/gpu-full:latest
```

Here the key flags include:

* `-it`: run in interative mode
* `--rm`: remove the container after complete
* `--net="host"`: allow communication to the container on all ports accessible to host (for example Jupyter notebooks)
* `-v /data:/data`: mount the `/data` directory on the current host into the Docker container; this allows files, code, and data to be accessed from within the Docker container and also ensures that any completed work persists after the container is closed (consider mounting additional folders as needed)
* `--name`: name of container

To facilitate invoking `docker run` with the necessary flags, a Bash script has been prepared in the `/scripts/` subdirectory.

```
./docker-run.sh

USAGE: ./docker-run.sh [-options ...] 

Launch a single Docker container

OPTIONS:

  -n or --name          Name of instantiated container (required)
  -i or --image         Name of container image to launch (default is gpu-full)
  -c or --command       Command to run upon container initialization (default is None)
  -C or --cpu           Use CPU mode (default is GPU mode)
  -h or --help          Print help

MOUNT OPTIONS:

By default, the following host volumes are mounted into the Docker container:

  /home (access to host home directory and files)
  /data (access to host data volume, if used)
  /mnt  (access to mounted volumes e.g. external hard drive, USB, etc)

If desired, alternate locations can be specified using the following flags:

  -H or --home          Alternate location of /home dir to mount (e.g. /Users for Mac OS)
  -d or --data          Alternate location of /data dir to mount 
  -m or --mnt           Alternate location of /mnt  dir to mount (e.g. /Volumes for Mac OS)
  -x or --prefix        Prefix for all location (e.g. /mnt/nfs if the above are served via NFS)

USER OPTIONS:

If the host is a *nix-based OS, users (and passwords) are copied (NOT mounted) into the container:

  /etc/passwd
  /etc/shadow
  /etc/group
  /etc/gshadow

If desired, an alternate location of the corresponding /etc folder can be specified:

  -E or --etc           Alternate location of /etc dir to copy (with users and passwords)

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

A number of Bash scripts are prepared in the `/linux/` subdirectory of this repository to install several commonly used tools for improved workflow, terminal session management, etc. 

## install.sh

This script installs a handful of common Linux tools, including:

* vim (including Vundle, .vimrc configuration file, colors and plugins)
* silversearcher-ag
* tmux and zsh
* git
* zsh

Note that the formal Python development environment is provided in Docker containers described above.

## install-aws.sh

If you are using a brand new AWS instance, there are a handful of commands that are useful for mounting a filesystem via NFS and downloading some commonly used dependencies (GCC, Java, etc) that AWS does not include by default.
