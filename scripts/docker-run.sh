#!/bin/bash

# =============================================================================
# LAUNCH SINGLE DOCKER CONTAINER 
# =============================================================================

USAGE="
USAGE: ./docker-run.sh [-options ...] 

Launch a single Docker container

By default, the /home, /data and /mnt folders will be mounted from host

OPTIONS:

  -i or --image         Name of container image to launch (default is gpu-full)
  -n or --name          Name of instantiated container
  -x or --prefix        Prefix of /data and /home to mount (e.g. /mnt/nfs)
  -c or --command       Command to run
  -h or --help          Print help

"

usage() {
    echo "$USAGE"
}

# =======================================================================
# PARSE ARGUMENTS
# =======================================================================

# --- Extract arguments 
while [[ $1 != "" ]]; do
    case "$1" in
        -i | --image)
            IMAGE="$2"
            shift
            ;;
        -n | --name)
            NAME="$2"
            shift
            ;;
        -x | --prefix)
            PREFIX="$2"
            shift
            ;;
        -c | --cmd | --command)
            CMD="$2"
            shift
            ;;
        -h | --help)
            usage
            exit
            ;;
        *)
            echo "ERROR unknown parameter <$1>"
            usage
            exit 1
            ;;
    esac
    shift
done

# --- Required 
if [[ -z $NAME ]]; then
    echo "ERROR name of instantiated container must be provided via -n flag"
    usage
    exit
fi

# --- Set defaults
IMAGE=${IMAGE:-"gpu-full"}

# =======================================================================
# FUNCTIONS 
# =======================================================================

copy_users() {

    if [ ! -d "$HOME/temp/etc" ]; then
        mkdir "$HOME/temp/etc"
    fi

    sudo cp $PREFIX/etc/passwd $HOME/temp/etc
    sudo cp $PREFIX/etc/shadow $HOME/temp/etc
    sudo cp $PREFIX/etc/group $HOME/temp/etc
    sudo cp $PREFIX/etc/gshadow $HOME/temp/etc

}

# ==================================
# MAIN 
# ==================================

# --- Copy users
copy_users

sudo -E docker run --gpus all -it --rm \
    -v /mnt:/mnt:Z -v $PREFIX/home:/home:Z -v $PREFIX/data:/data:Z \
    -v $HOME/temp/etc:/root/temp:Z -v $HOME/.Xauthority:/root/.Xauthority:Z \
    --net="host" -e DISPLAY=$DISPLAY --name $NAME peterchang77/$IMAGE:latest $CMD
