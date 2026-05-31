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
# INSTALL basic updates 
# =============================================================================
echo -n "Update package manager (y/n)? "
read proceed
if [ $proceed == "y" ]; then
    sudo $pm update 
fi

# =============================================================================
# INSTALL vim-plug, neovim configuration and plugins
# =============================================================================
echo -n "Install vim/neovim and plugins (y/n)? "
read proceed
if [ $proceed == "y" ]; then
    sudo $pm install -y neovim
    curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    mkdir -p ~/.config/nvim/colors
    cp vim/.vimrc ~/.vimrc
    ln -sf ~/.vimrc ~/.config/nvim/init.vim
    cp -r ./vim/colors/* ~/.config/nvim/colors/
    nvim +PlugInstall +qall
    if [ $pm == "apt-get" ]; then
        sudo $pm install -y silversearcher-ag
    fi
fi

# =============================================================================
# INSTALL git
# =============================================================================
if ! [ -x "$(command -v git)" ]; then
    sudo $pm install -y git
    echo -n "Enter Git email address: "
    read email
    echo -n "Enter Git username: "
    read username
    git config --global user.email $email 
    git config --global user.name $username
    git config --global credential.helper 'cache --timeout=300'
fi

# =============================================================================
# INSTALL tmux and zsh
# =============================================================================
echo -n "Install tmux (y/n)? "
read proceed
if [ $proceed == "y" ]; then
    sudo $pm install -y tmux
    cp .tmux.conf ~/.tmux.conf
fi

echo -n "Install zsh (y/n)? "
read proceed
if [ $proceed == "y" ]; then
    sudo $pm install -y zsh
    git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
    cp .zshrc ~/.zshrc
fi

echo -n "Change default shell to zsh [NOTE: must be logged in as user] (y/n)? "
read proceed
if [ $proceed == "y" ]; then
    chsh -s $(which zsh)
fi

# =============================================================================
# INSTALL sshd
# =============================================================================
echo -n "Install OpenSSH (y/n)? "
read proceed
if [ $proceed == "y" ]; then
    sudo $pm install openssh-server 
fi

# =============================================================================
# INSTALL LaTex
# =============================================================================
echo -n "Install LaTeX (y/n)? "
read proceed
if [ $proceed == "y" ]; then
    sudo $pm install -y texlive texlive-pictures
fi
