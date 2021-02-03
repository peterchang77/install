#!/bin/bash

# =============================================================================
# LAUNCH SINGLE DOCKER CONTAINER 
# =============================================================================

USAGE="
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

"

usage() {
    echo "$USAGE"
}

# =======================================================================
# PARSE ARGUMENTS
# =======================================================================

# --- Set defaults
IMAGE="gpu-full"
HARDWARE="--gpus all"
MOUNT_HOME="/home"
MOUNT_DATA="/data"
MOUNT_MNT="/mnt"
MOUNT_ETC="/etc"
CMD="tmux"

# --- Attempt to infer hardware (GPU or CPU) 
if ! [ -x "$(command -v nvidia-smi)" ]; then
    echo "Nvidia GPU drivers not installed, defaulting to CPU mode"
    IMAGE="cpu-full"
    HARDWARE=""
fi

# --- Extract arguments 
while [[ $1 != "" ]]; do
    case "$1" in
        -n | --name)
            NAME="$2"
            shift
            ;;
        -i | --image)
            IMAGE="$2"
            shift
            ;;
        -c | --cmd | --command)
            CMD="$2"
            shift
            ;;
        -C | --cpu)
            IMAGE="cpu-full"
            HARDWARE=""
            ;;
        -x | --prefix)
            PREFIX="$2"
            shift
            ;;
        -H | --home)
            MOUNT_HOME=$2
            shift
            ;;
        -d | --data)
            MOUNT_DATA=$2
            shift
            ;;
        -m | --mnt)
            MOUNT_MNT=$2
            shift
            ;;
        -E | --etc)
            MOUNT_ETC=$2
            shift
            ;;
        -e | --entry)
            JARVIS_ENTRY_SCRIPT="$2"
            shift
            ;;
        -f | --configs)
            JARVIS_PATH_CONFIGS="$2"
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

# --- Append $PREFIX
MOUNT_HOME="$PREFIX$MOUNT_HOME"
MOUNT_DATA="$PREFIX$MOUNT_DATA"
MOUNT_MNT="$PREFIX$MOUNT_MNT"
MOUNT_ETC="$PREFIX$MOUNT_ETC"

# ==================================
# MAIN 
# ==================================

# --- Temporarily change paths if $MOUNT_HOME is not /home
if [[ "$MOUNT_HOME" != "/home" ]]; then
    export JARVIS_PATH=${JARVIS_PATH/$MOUNT_HOME/"/home"}
    export JARVIS_ENTRY_SCRIPT=${JARVIS_ENTRY_SCRIPT/$MOUNT_HOME/"/home"}
fi

sudo -E docker run $HARDWARE -it --rm \
    -v $MOUNT_MNT:/mnt:Z -v $MOUNT_HOME:/home:Z -v $MOUNT_DATA:/data:Z \
    -v $MOUNT_ETC/passwd:/root/etc/passwd:ro \
    -v $MOUNT_ETC/shadow:/root/etc/shadow:ro \
    -v $MOUNT_ETC/group:/root/etc/group:ro \
    -v $MOUNT_ETC/gshadow:/root/etc/gshadow:ro \
    -v $HOME/.Xauthority:/root/.Xauthority:Z \
    -e JARVIS_PATH=$JARVIS_PATH \
    -e JARVIS_PATH_CONFIGS=$JARVIS_PATH_CONFIGS \
    -e JARVIS_ENTRY_SCRIPT=$JARVIS_ENTRY_SCRIPT \
    --net="host" -e DISPLAY=$DISPLAY --name $NAME peterchang77/$IMAGE:latest $CMD
