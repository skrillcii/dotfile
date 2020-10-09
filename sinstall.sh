#!/bin/bash


##################################
# Functions of script starts here#
##################################

general_install()
{
    sudo apt-get install -y zsh tmux vim curl ranger xclip i3 lm-sensors lightdm vlc npm exuberant-ctags
    sudo sensors-detect
}

oh_my_zsh_install()
{
    sudo apt-get install -y zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
}


tmux_plugin_manager()
{
    # Source
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
}

oh_my_tmux()
{
    git clone https://github.com/gpakosz/.tmux.git "$HOME/.oh-my-tmux/"
    ln -s -f "$HOME/.oh-my-tmux/.tmux.conf" "$HOME/.tmux.conf"
    ln -s -f "$HOME/.oh-my-tmux/.tmux.conf.local" "$HOME/.tmux.conf.local"
    echo 'source ~/dotfile/.tmux.conf.local' >> "$HOME/.tmux.conf.local"
}

# Deprecated as on Ubuntu 20.04, tmux version 3.0a can be installed by
# sudo apt-get install -y tmux
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


fzf_install()
{
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
}


pyenv_install()
{
    # Dependencies
    sudo apt-get update; sudo apt-get install -y --no-install-recommends make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
    git clone https://github.com/pyenv/pyenv.git ~/.pyenv

    # Environment variables settings
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
    echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
    echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/.zshrc
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

    # From package manager
    wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin
    sudo mv cuda-ubuntu1804.pin /etc/apt/preferences.d/cuda-repository-pin-600
    wget http://developer.download.nvidia.com/compute/cuda/10.2/Prod/local_installers/cuda-repo-ubuntu1804-10-2-local-10.2.89-440.33.01_1.0-1_amd64.deb
    sudo dpkg -i cuda-repo-ubuntu1804-10-2-local-10.2.89-440.33.01_1.0-1_amd64.deb
    sudo apt-key add /var/cuda-repo-10-2-local-10.2.89-440.33.01/7fa2af80.pub
    sudo apt-get update
    sudo apt-get -y install cuda

    echo 'export PATH=/usr/local/cuda/bin:${PATH}' >> ~/.zshrc
    echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64/' >> ~/.zshrc

    # From runfile
    sudo apt-get purge nvidia*
    sudo apt-get autoremove
    sudo dpkg -l | grep nvidia
    sudo apt-get purge ... # whatever nvidia packages left

    sudo apt-get install build-essential gcc-multilib dkms
    sudo echo 'blacklist nouveau' >> /etc/modprobe.d/blacklist-nouveau.conf
    sudo echo 'options nouveau modeset=0' >> /etc/modprobe.d/blacklist-nouveau.conf
    sudo update-initramfs -u
    sudo systemctl stop lightdm

    wget https://developer.download.nvidia.com/compute/cuda/11.1.0/local_installers/cuda_11.1.0_455.23.05_linux.run
    chmod +x cuda_11.1.0_455.23.05_linux.run
    sudo sh cuda_11.1.0_455.23.05_linux.run
}



##################################
# Main body of script starts here#
##################################

echo "Start custom installation"

