#!/usr/bin/bash


##############
# Nvdia Cuda #
##############

install_cuda() {
    echo -e "\n >>> Cuda Installation Started..."

    # Install option 1:  Package install
    wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin
    sudo mv cuda-ubuntu1804.pin /etc/apt/preferences.d/cuda-repository-pin-600
    wget http://developer.download.nvidia.com/compute/cuda/10.2/Prod/local_installers/cuda-repo-ubuntu1804-10-2-local-10.2.89-440.33.01_1.0-1_amd64.deb
    sudo dpkg -i cuda-repo-ubuntu1804-10-2-local-10.2.89-440.33.01_1.0-1_amd64.deb
    sudo apt-key add /var/cuda-repo-10-2-local-10.2.89-440.33.01/7fa2af80.pub
    sudo apt-get update
    sudo apt-get -y install cuda

    echo 'export PATH=/usr/local/cuda/bin:${PATH}' >> ~/.zshrc
    echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64/' >> ~/.zshrc

    # Install option 1:  Runfile install
    sudo apt-get purge nvidia*
    sudo apt-get autoremove
    sudo dpkg -l | grep nvidia
    sudo apt-get purge ... # whatever nvidia packages left shown from last command

    sudo apt-get install build-essential gcc-multilib dkms
    sudo echo 'blacklist nouveau' >> /etc/modprobe.d/blacklist-nouveau.conf
    sudo echo 'options nouveau modeset=0' >> /etc/modprobe.d/blacklist-nouveau.conf
    sudo update-initramfs -u
    sudo systemctl stop lightdm

    wget https://developer.download.nvidia.com/compute/cuda/11.1.0/local_installers/cuda_11.1.0_455.23.05_linux.run
    chmod +x cuda_11.1.0_455.23.05_linux.run
    sudo sh cuda_11.1.0_455.23.05_linux.run

    echo -e " <<< Cuda Installation Finished!"
}


###################################
# Deprecated installation scripts #
###################################

# ---------------------------------------------------------------------
# Deprecated as on Ubuntu 20.04, tmux version 3.0a can be installed by
# sudo apt-get install -y tmux
# ---------------------------------------------------------------------

tmux_build_from_source() {
    sudo apt-get -y remove tmux
    sudo apt-get -y install wget tar libevent-dev libncurses-dev checkinstall
    wget https://github.com/tmux/tmux/releases/download/2.7/tmux-2.7.tar.gz
    tar xf tmux-2.7.tar.gz
    rm -f tmux-2.7.tar.gz
    cd tmux-2.7
    ./configure
    make
    sudo checkinstall

    cd -
    sudo rm -rf /usr/local/src/tmux-*
    sudo mv tmux-2.7 /usr/local/src
}

# ---------------------------------------------------------------------
# Deprecated as on Ubuntu 20.04, java-11 can be installed by
# sudo apt-get install -y default-jre default-jdk
# ---------------------------------------------------------------------

java_8_install() {
    # Package install java-8 by adding apt repository
    sudo add-apt-repository ppa:webupd8team/java
    sudo apt-get update
    sudo apt-get install -y oracle-java8-installer oracle-java8-set-default
}

# ---------------------------------------------------------------------
# Deprecated as on Ubuntu 20.04, maven-3.6.3 can be installed by
# sudo apt-get install -y maven
# ---------------------------------------------------------------------

apache_maven_install() {
    # Source apache-maven
    cd ~
    wget https://ftp.riken.jp/net/apache/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz

    # Extract, move to system path, create symbolic link
    tar -xvf apache-maven-3.6.3-bin.tar.gz
    sudo mv apache-maven-3.6.3 /usr/local/apache-maven/apache-maven-3.6.3
    sudo ln -s /usr/local/apache-maven/apache-maven.3.6.3 /usr/local/apache-maven/apache-maven

    # Clean up
    rm ~/apache-maven-3.6.3-bin.tar.gz
}

# ---------------------------------------------------------------------
# Deprecated as started using i3wm.
# Unity-tweak-tool is replaced by gnome-tweak-tool after ubuntu 17.04
# ---------------------------------------------------------------------

numix_theme() {
    # Package install numix-theme by adding apt repository
    sudo add-apt-repository ppa:numix/ppa
    sudo apt-get update
    sudo apt-get install -y unity-tweak-tool numix-gtk-theme numix-icon-theme-circle
}

# ---------------------------------------------------------------------
# Deprecated as started using coc.
# YouCompleteMe in general is troublesom to configure
# ---------------------------------------------------------------------

install_ycm() {
    echo -e "\n >>> YouCompleteMe Installation Started..."

    # Package install dependencies:
    sudo apt-get install -y build-essential cmake python3-dev npm \
                            default-jre default-jdk maven
    check_execution
    cd ~/.vim/plugged/YouCompleteMe

    # If python is installed with pyenv with --enable-shared
    ~/.pyenv/shims/python3 install.py --clang-completer --cs-completer --js-completer --java-completer
    check_execution

    echo -e " <<< YouCompleteMe Installation Finished!"
}

