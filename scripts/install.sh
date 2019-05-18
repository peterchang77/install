#!/bin/bash

# ==================================
# USAGE
# ==================================
#
# >> ./install.sh [package-manager], where:
# 
# [package-manager] = apt-get, yum, brew, etc depending on OS 
#
# ==================================


# DETERMINE Package Manager
if [ $# -eq 0 ]; then
    pm="apt-get"
else
    pm=$1
fi

# INSTALLATION SCRIPT OF THE FOLLOWING PROGRAMS:
# - vim (including Vunle, .vimrc configuration file, colors and plugins)
# - python3
# - silversearcher-ag
# - tmux and zsh
# - Anaconda and python 3.5
# - git
# - zsh
# - Atom

# INSTALL Vundle, vim configuration and plugins
# sudo $pm install vim-nox
# git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
# cp vim/.vimrc ~/.vimrc
# cp -r ./vim/colors ~/.vim/colors
# vim +PluginInstall qall

# INSTALL system python3 for vim
# sudo $pm install python3

# INSTALL ag
# sudo $pm install silversearcher-ag

# INSTALL tmux and zsh
# sudo $pm install tmux
# cp .tmux.conf ~/.tmux.conf
# sudo $pm install zsh
# git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
# cp .zshrc ~/.zshrc

# INSTALL sshd
# sudo apt install ssh

# INSTALL git
# sudo $pm install git

# INSTALL Atom editor
# sudo add-apt-repository ppa:webupd8team/atom
# sudo apt update
# sudo apt install atom

# INSTALL mongodb (for Ubuntu 16.04)
# website: https://docs.mongodb.com/getting-started/shell/tutorial/install-mongodb-on-ubuntu/
# sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6
# echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list
# sudo $pm update
# sudo $pm install -y mongodb-org

# INSTALL nodejs
# curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
# sudo $pm install -y nodejs
