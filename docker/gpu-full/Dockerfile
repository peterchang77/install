FROM nvidia/cuda:11.2.2-cudnn8-runtime-ubuntu20.04
MAINTAINER Peter Chang <pchang077@gmail.com>

# --- Copy files
COPY environment.yml .tmux.conf .zshrc vim/.vimrc /root/
COPY wheels /root/wheels
COPY vim/colors /root/.vim/colors

ENV DEBIAN_FRONTEND=noninteractive

# --- System packages 
RUN apt-get update && apt-get install -y wget curl bzip2 vim silversearcher-ag tmux zsh git zip unzip build-essential sudo && \
    apt-get install -y net-tools iputils-ping netcat openssh-server rsync && \
    apt-get install -y default-jre && \
    apt-get install -y ranger caca-utils highlight atool w3m poppler-utils lm-sensors && \
    apt-get install -y python3-openslide && \
    curl https://rclone.org/install.sh | bash && \

# --- dcm4che
    wget -O dcm4che.zip https://www.dropbox.com/s/zl7adkprqeebvnh/dcm4che.zip?dl=1 && \
    unzip dcm4che.zip -d /usr/local/dcm4che && \
    ln -sf /usr/local/dcm4che/bin/storescp /usr/local/bin && \
    rm dcm4che.zip && \

# --- X11
    apt-get install -y libxi6 libsm6 libxext6 libxrender-dev && \

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

# --- Clear NVIDIA cache (otherwise must run as root)
    rm -rf ~/.nv/ && \

# --- Clean up
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /root/wheels

COPY copyusers.py .bashrc /root/
COPY ./jarvis-bash.sh ./jarvis-env.sh /etc/profile.d/

ENV PATH=/miniconda/bin:$PATH
ENV TERM=xterm-256color
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8 
ENV XDG_RUNTIME_DIR=/tmp
ENV QT_XKB_CONFIG_ROOT=/usr/share/X11/xkb
ENV DCM4CHE_HOME=/usr/local/dcm4che
ENV DEBIAN_FRONTEND=
