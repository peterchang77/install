#!/bin/bash

# =============================================================================
# DETERMINE Package Manager
# =============================================================================
if [ -x "$(command -v apt-get)" ]; then
    pm="apt-get"
elif [ -x "$(command -v yum)" ]; then
    pm="yum"
else
    if [ $# -eq 1 ]; then
        pm=$1
    else
        echo "ERROR package manager not recognized, please pass name manually: ./install.sh [package-manager]"
    fi
fi

echo "Using package-manager: $pm"

# =============================================================================
# INSTALLATION SCRIPT OF THE FOLLOWING PROGRAMS:
# =============================================================================
# - vim (including Vundle, .vimrc configuration file, colors and plugins)
# - silversearcher-ag
# - tmux and zsh
# - git
# - LaTex
# =============================================================================

# =============================================================================
# INSTALL Vundle, vim configuration and plugins
# =============================================================================
echo "Install vim and plugins (y/n)?"
read proceed
if [ $proceed == "y" ]; then
    sudo $pm install vim
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    cp vim/.vimrc ~/.vimrc
    cp -r ./vim/colors ~/.vim/colors
    vim +PluginInstall qall
    sudo $pm install silversearcher-ag
fi

# =============================================================================
# INSTALL tmux and zsh
# =============================================================================
echo "Install tmux (y/n)?"
read proceed
if [ $proceed == "y" ]; then
    sudo $pm install tmux
    cp .tmux.conf ~/.tmux.conf
fi

echo "Install zsh (y/n)?"
read proceed
if [ $proceed == "y" ]; then
    sudo $pm install zsh
    git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
    cp .zshrc ~/.zshrc
fi

# =============================================================================
# INSTALL sshd
# =============================================================================
echo "Install OpenSSH (y/n)?"
read proceed
if [ $proceed == "y" ]; then
    sudo $pm openssh-server 
fi

# =============================================================================
# INSTALL git
# =============================================================================
if ! [ -x "$(command -v git)" ]; then
    sudo $pm install git
    echo "Enter Git email address:"
    read email
    echo "Enter Git username:"
    read username
    git config --global user.email $email 
    git config --global user.name $username
    git config --global credential.helper 'cache --timeout=300'
fi

# =============================================================================
# INSTALL LaTex
# =============================================================================
echo "Install LaTeX (y/n)?"
read proceed
if [ $proceed == "y" ]; then
    sudo $pm install texlive texlive-pictures
fi
