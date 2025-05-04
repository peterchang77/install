FROM ubuntu:24.04 
MAINTAINER Peter Chang <pchang077@gmail.com>

# --- Copy files
COPY environment.yml .tmux.conf .zshrc vim/.vimrc /root/
COPY wheels /root/wheels
COPY vim/colors /root/.vim/colors

# --- System packages 
RUN apt-get update && apt-get install -y wget curl bzip2 vim silversearcher-ag tmux zsh git zip unzip build-essential && \

# --- zsh / vim
    git clone https://github.com/robbyrussell/oh-my-zsh.git /root/.oh-my-zsh && \
    git clone https://github.com/VundleVim/Vundle.vim.git /root/.vim/bundle/Vundle.vim && \
    vim +PluginInstall +qall || true  && \

# --- Locale
    apt-get install -y locales && \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen && \

# --- Miniconda, environment creation
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash Miniconda3-latest-Linux-x86_64.sh -p /miniconda -b && \
    rm Miniconda3-latest-Linux-x86_64.sh && \
    /miniconda/bin/conda env create -f /root/environment.yml && \
    for whl in $(find /root/wheels/*.whl); do /miniconda/envs/jarvis/bin/pip install $whl; done && \
    /miniconda/bin/conda clean --all && \

# --- Clear NVIDIA cache (otherwise must run as root)
    rm -rf ~/.nv/ && \

# --- Clean up
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /root/wheels

COPY .bashrc /root/
COPY ./jarvis-bash.sh ./jarvis-env.sh /etc/profile.d/

ENV PATH=/miniconda/bin:$PATH
ENV TERM=xterm-256color
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8 
ENV XDG_RUNTIME_DIR=/tmp
