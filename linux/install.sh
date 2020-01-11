#!/bin/bash

# =============================================================================
# DETERMINE Package Manager
# =============================================================================
if [ $# -eq 0 ]; then
    pm=apt-get
else
    pm=$1
fi

# =============================================================================
# INSTALLATION SCRIPT OF THE FOLLOWING PROGRAMS:
# =============================================================================
# - vim (including Vunle, .vimrc configuration file, colors and plugins)
# - python3
# - silversearcher-ag
# - tmux and zsh
# - git
# - LaTex
# =============================================================================

# =============================================================================
# INSTALL Vundle, vim configuration and plugins
# =============================================================================
# sudo $pm install vim-nox
# git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
# cp vim/.vimrc ~/.vimrc
# cp -r ./vim/colors ~/.vim/colors
# vim +PluginInstall qall

# =============================================================================
# INSTALL system python3 for vim
# =============================================================================
# sudo $pm install python3

# =============================================================================
# INSTALL ag
# =============================================================================
# sudo $pm install silversearcher-ag

# =============================================================================
# INSTALL tmux and zsh
# =============================================================================
# sudo $pm install tmux
# cp .tmux.conf ~/.tmux.conf
# sudo $pm install zsh
# git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
# cp .zshrc ~/.zshrc

# =============================================================================
# INSTALL sshd
# =============================================================================
# sudo apt install ssh

# =============================================================================
# INSTALL git
# =============================================================================
# sudo $pm install git
# echo "Enter Git email address:"
# read email
# echo "Enter Git username:"
# read username
# git config --global user.email $email 
# git config --global user.name $username
# git config --global credential.helper 'cache --timeout=300'

# =============================================================================
# INSTALL LaTex
# =============================================================================
# sudo $pm install texlive texlive-pictures
