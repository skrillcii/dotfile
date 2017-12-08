#!/bin/bash

#########################
# Kernel Configurations #
#########################

kernel_configurations()
{
# Edit /etc/default/grub
sudo gedit /etc/default/grub

# Change GRUB_CMDLINE_LINUX_DEFAULT
# splash: show splash
# quiet: hide bootup test
GRUB_CMDLINE_LINUX_DEFAULT="quite splash"
GRUB_CMDLINE_LINUX_DEFAULT="splash"
GRUB_CMDLINE_LINUX_DEFAULT="quite"
GRUB_CMDLINE_LINUX_DEFAULT=""

# After configuration, run update
sudo update-grub
}


######################
# Graphic PC address #
######################

# Seigyo
#ssh morikuni@192.168.50.4

# Archti
#ssh morikuni@192.168.11.13

# Ogasa Allegro
#http://183.181.4.144/git/allegro_hand_ros_catkin_fork.git
#user:handteam 
#pass:shigeki2

##################################
# Functions of script starts here#
##################################

install_google_chrome()
{
    # Add Key:
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -

    # Set repository:
    echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list

    # Install package:
    sudo apt-get update 
    sudo apt-get install google-chrome-stable -y
}


vim_build_from_source()
{
    # Add dependencies:
    sudo apt-get install libncurses5-dev libgnome2-dev libgnomeui-dev \
        libgtk2.0-dev libatk1.0-dev libbonoboui2-dev \
        libcairo2-dev libx11-dev libxpm-dev libxt-dev python-dev \
        python3-dev ruby-dev lua5.1 lua5.1-dev libperl-dev git \
        checkinstall -y

    # Remove old vim:
    sudo apt-get remove vim vim-runtime gvim

    # Source, configure and build
    cd ~
    git clone https://github.com/vim/vim.git
    cd vim
    ./configure --with-features=huge \
                --enable-multibyte \
                --enable-terminal \
                --enable-rubyinterp=yes \
                --enable-python3interp=yes \
                --with-python3-config-dir=/usr/lib/python3.5/config \
                --enable-perlinterp=yes \
                --enable-gui=gtk2 \
                --enable-cscope \
                --prefix=/usr/local
    make VIMRUNTIMEDIR=/usr/local/share/vim/vim80

    # Install with checkinstall
    cd ~/vim
    sudo checkinstall

    # Remove directory
    cd ~
    sudo rm -rf ~/vim
}


vim_plugin_manager()
{
    # Install curl
    sudo apt-get install curl -y

    # Source vim-plug
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}


tmux_build_from_source()
{
    VERSION=2.5
    sudo apt-get -y remove tmux
    sudo apt-get -y install wget tar libevent-dev libncurses-dev
    wget https://github.com/tmux/tmux/releases/download/2.5/tmux-2.5.tar.gz
    tar xf tmux-2.5.tar.gz
    rm -f tmux-2.5.tar.gz
    cd tmux-2.5
    ./configure
    make
    sudo make install
    cd -
    sudo rm -rf /usr/local/src/tmux-*
    sudo mv tmux-2.5 /usr/local/src
}


tmux_plugin_manager()
{
    # Source
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
}


zsh_prezto_install()
{
    # Install zsh:
    sudo apt-get install zsh -y

    # Start zsh:
    zsh

    # Source prezto:
    git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"

    # Create a new zsh configuration by copying the zsh configuration files provided:
    setopt EXTENDED_GLOB
    for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md; do
      ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
    done

    # Set zsh as the default shell
    chsh -s /bin/zsh
}


powerline_font_install()
{
    # clone
    git clone https://github.com/powerline/fonts.git --depth=1

    # install
    cd fonts
    ./install.sh

    # clean-up a bit
    cd ..
    rm -rf fonts
}


numix_theme()
{
    sudo add-apt-repository ppa:numix/ppa
    sudo apt-get update
    sudo apt-get install unity-tweak-tool numix-gtk-theme numix-icon-theme-circle -y
}


skrillcii_dotfile()
{
    # Source skrillcii repo:
    cd ~
    git clone https://github.com/skrillcii/dotfile.git

    # Create symbolic link:
    ln -s ~/dotfile/.vimrc ~/.vimrc
    ln -s ~/dotfile/.gvimrc ~/.gvimrc
    ln -s ~/dotfile/.tmux.conf ~/.tmux.conf
    echo 'source $HOME/dotfile/.zshrc' >> ~/.zshrc
}


pyenv_install()
{
    curl -L https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | zsh

    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
    echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
    echo 'eval "$(pyenv init -)"' >> ~/.zshrc
    echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.zshrc
    exec "$SHELL"
}


cuda_driver()
{
    # Install dependencies
    sudo apt-get install openjdk-8-jdk git python-dev python3-dev \
            donepython-numpy python3-numpy python-six python3-six \
            build-essential python-pip python3-pip python-virtualenv \
            swig python-wheel python3-wheel libcurl3-dev libcupti-dev -y

    # Install cuda
    cd ~
    wget https://developer.nvidia.com/compute/cuda/8.0/Prod2/local_installers/cuda_8.0.61_375.26_linux-run
    wget https://developer.nvidia.com/compute/cuda/9.0/Prod/local_installers/cuda_9.0.176_384.81_linux-run
    sudo sh cuda_8.0.61_375.26_linux.run --override --silent --toolkit
    sudo sh cuda_9.0.176_384.81_linux.run --override --silent --toolkit

    # Go to website download CudNN
    tar -xzvf cudnn-8.0-linux-x64-v6.0.tgz
    tar -xzvf cudnn-9.0-linux-x64-v7.0.tgz

    sudo cp cuda/include/cudnn.h /usr/local/cuda/include
    sudo cp cuda/lib64/libcudnn* /usr/local/cuda/lib64
    sudo chmod a+r /usr/local/cuda/include/cudnn.h /usr/local/cuda/lib64/libcudnn*


    echo 'export PATH=/usr/local/cuda-8.0/bin:${PATH}' >> ~/.zshrc
    echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64/' >> ~/.zshrc
    echo 'export PATH=/usr/local/cuda-9.0/bin:${PATH}' >> ~/.zshrc
    echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64/' >> ~/.zshrc
}



##################################
# Main body of script starts here#
##################################

echo "Start custom installation"
#kernel_configurations
#install_google_chrome
#vim_build_from_source
#vim_plugin_manager
#tmux_build_from_source
#tmux_plugin_manager
#zsh_prezto_install
#powerline_font_install
#numix_theme

#skrillcii_dotfile
#pyenv_install
#cuda_driver
