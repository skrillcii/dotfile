#!/bin/bash

#########################
# Kernel Configurations #
#########################
ubuntu_multi_monitor()
{
    xset -dpms
}

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


##################################
# Functions of script starts here#
##################################


oh_my_zsh_install()
{
    sudo apt-get install -y zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
}


tmux_build_from_source()
{
    sudo apt-get -y remove tmux
    sudo apt-get -y install wget tar libevent-dev libncurses-dev checkinstall
    wget https://github.com/tmux/tmux/releases/download/2.7/tmux-2.7.tar.gz
    tar xf tmux-2.7.tar.gz
    rm -f tmux-2.7.tar.gz
    cd tmux-2.7
    ./configure
    make
    sudo checkinstall

    # Deprecated
    cd -
    sudo rm -rf /usr/local/src/tmux-*
    sudo mv tmux-2.7 /usr/local/src
}


tmux_plugin_manager()
{
    # Source
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
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
    make VIMRUNTIMEDIR=/usr/local/share/vim/vim81

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


ranger_install()
{
    sudo apt-get install -y ranger
}


temperature_install()
{
    sudo apt-get install -y lm-sensors
    sudo sensors-detect
}


fzf_install()
{
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
}


skrillcii_dotfile()
{
    # Source skrillcii repo:
    cd ~
    git clone https://github.com/skrillcii/dotfile.git

    # Create symbolic link:
    ln -s ~/dotfile/.vimrc ~/.vimrc
    ln -s ~/dotfile/.tmux.conf ~/.tmux.conf
    echo 'source $HOME/dotfile/.zshrc' >> ~/.zshrc
}


pyenv_install()
{
    git clone https://github.com/pyenv/pyenv.git ~/.pyenv
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
    echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
    echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/.zshrc
}


nodejs_npm_install()
{
    sudo apt-get install -y npm
}


java_8_install()
{
    sudo add-apt-repository ppa:webupd8team/java
    sudo apt-get update
    sudo apt-get install -y oracle-java8-installer oracle-java8-set-default
}


YouCompleteMe_install()
{
    sudo apt-get install -y build-essential cmake python-dev python3-dev
    cd ~/.vim/plugged/YouCompleteMe
    /usr/bin/python3 install.py --clang-completer --cs-completer --js-completer --java-completer
}


Language_inputs_install()
{
    sudo apt-get install -y fcitx-bin fcitx-chewing fcitx-mozc
}


vim_markdown_preview_dependencies()
{
    sudo apt-get install -y xdotool
    pip install grip
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


cuda_driver()
{
    wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin
    sudo mv cuda-ubuntu1804.pin /etc/apt/preferences.d/cuda-repository-pin-600
    wget http://developer.download.nvidia.com/compute/cuda/10.2/Prod/local_installers/cuda-repo-ubuntu1804-10-2-local-10.2.89-440.33.01_1.0-1_amd64.deb
    sudo dpkg -i cuda-repo-ubuntu1804-10-2-local-10.2.89-440.33.01_1.0-1_amd64.deb
    sudo apt-key add /var/cuda-repo-10-2-local-10.2.89-440.33.01/7fa2af80.pub
    sudo apt-get update
    sudo apt-get -y install cuda

    echo 'export PATH=/usr/local/cuda/bin:${PATH}' >> ~/.zshrc
    echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64/' >> ~/.zshrc
}



##################################
# Main body of script starts here#
##################################

echo "Start custom installation"
#kernel_configurations
#vim_build_from_source
#vim_plugin_manager
#tmux_build_from_source
#tmux_plugin_manager
#oh_my_zsh_install
#nodejs_npm_install
#java_8_install
#vim_markdown_preview_dependencies
#YouCompleteMe_install
#powerline_font_install
#numix_theme

#skrillcii_dotfile
#pyenv_install
#cuda_driver
