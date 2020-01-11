#!/bin/bash

# ==================================
# Copy passwords (backup to Docker)
# ==================================
if [ -f /root/temp/passwd ]; then

    cat /root/temp/passwd >> /etc/passwd
    cat /root/temp/shadow >> /etc/shadow
    cat /root/temp/group >> /etc/group
    cat /root/temp/gshadow >> /etc/gshadow
    rm /root/temp/passwd
    rm /root/temp/shadow
    rm /root/temp/group
    rm /root/temp/gshadow

fi
