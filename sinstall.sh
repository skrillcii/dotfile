#!/bin/bash


###################################
# Functions of script starts here #
###################################

general_install() {
    # Package install general
    sudo apt-get install -y zsh tmux vim curl xclip vlc redshift \
                            htop glances lm-sensors mesa-utils \
                            checkinstall \

    # Package install lightdm
    sudo apt-get install -y lightdm

    # Initialize lm-sensors
    sudo sensors-detect

    # Create symbolic links
    ln -s -f ~/dotfile/vim/vimrc ~/.vimrc
    ln -s -f ~/dotfile/x/xprofile ~/.xprofile
    ln -s -f ~/dotfile/redshift/redshift.conf ~/.config/redshift.conf
}

i3_install() {
    # Package install i3
    sudo apt-get install -y i3

    # Package install extensions
    sudo apt-get install -y imagemagick feh

    # Create symbolic links
    ln -s -f ~/dotfile/i3/i3main.conf ~/.config/i3/config
    ln -s -f ~/dotfile/i3/i3status.conf ~/.i3status.conf
    sudo ln -s -f ~/dotfile/i3/i3exit.sh /usr/local/bin/i3exit
}

oh_my_zsh_install() {
    # Package install zsh
    sudo apt-get install -y zsh

    # Source oh-my-zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

    # Source oh-my-zsh plugins
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
    echo 'source $HOME/dotfile/zsh/zshrc' >> ~/.zshrc
}

tmux_plugin_manager() {
    # Package install tmux
    sudo apt-get install -y tmux

    # Source tmux-plugin-manager
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
}

oh_my_tmux() {
    # Source oh-my-tmux
    git clone https://github.com/gpakosz/.tmux.git "$HOME/.oh-my-tmux/"

    # Create symbolic links and source configurations
    ln -s -f "$HOME/.oh-my-tmux/.tmux.conf" "$HOME/.tmux.conf"
    ln -s -f "$HOME/.oh-my-tmux/.tmux.conf.local" "$HOME/.tmux.conf.local"
    echo 'source ~/dotfile/tmux/tmux.conf.local' >> "$HOME/.tmux.conf.local"
}

vim_build_from_source() {
    # Add dependencies:
    sudo apt-get install -y libncurses5-dev libgnome2-dev libgnomeui-dev \
                            libgtk2.0-dev libatk1.0-dev libbonoboui2-dev \
                            libcairo2-dev libx11-dev libxpm-dev libxt-dev python-dev \
                            python3-dev ruby-dev lua5.1 lua5.1-dev libperl-dev git \

    # Remove old vim:
    sudo apt-get remove vim vim-runtime gvim

    # Source, configure and build
    git clone https://github.com/vim/vim.git ~/
    cd vim
    ./configure --with-features=huge \
                --enable-multibyte \
                --enable-terminal \
                --enable-rubyinterp=yes \
                --enable-python3interp=yes \
                --with-python3-config-dir=/usr/lib/python3.5/config \
                --enable-perlinterp=yes \
                --enable-gui=gtk3 \
                --enable-cscope \
                --prefix=/usr/local \
    make VIMRUNTIMEDIR=/usr/local/share/vim/vim81

    # Install with checkinstall
    cd ~/vim
    sudo checkinstall

    # Remove directory
    cd ~
    sudo rm -rf ~/vim
}

vim_plugin_manager() {
    # For tagbar vim plugin
    sudo apt-get install -y exuberant-ctags

    # Source vim-plug
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}

fzf_install() {
    # Source fzf
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    # Install fzf
    ~/.fzf/install
}

ranger_install() {
    # Package install ranger and other utilities
    sudo apt-get install -y ranger caca-utils w3m highlight atool poppler-utils mediainfo

    # Create symbolic links
    ln -s -f "$HOME/dotfile/ranger/colorschemes" "$HOME/.config/ranger/"
    ln -s -f "$HOME/dotfile/ranger/commands.py" "$HOME/.config/ranger/"
    ln -s -f "$HOME/dotfile/ranger/commands_full.py" "$HOME/.config/ranger/"
    ln -s -f "$HOME/dotfile/ranger/rc.conf" "$HOME/.config/ranger/"
    ln -s -f "$HOME/dotfile/ranger/rifle.conf" "$HOME/.config/ranger/"
    ln -s -f "$HOME/dotfile/ranger/scope.sh" "$HOME/.config/ranger/"
}

nerd_font_install() {
    # Source nerd-fonts
    git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git ~/

    # Install font of your choice
    ~/.nerd-font/install HeavyData SpaceMono
}

pyenv_install() {
    # Dependencies
    sudo apt-get install -y --no-install-recommends 
                        make build-essential libssl-dev zlib1g-dev \
                        libbz2-dev libreadline-dev libsqlite3-dev wget \
                        curl llvm libncurses5-dev xz-utils tk-dev \
                        libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev \

    # Source pyenv
    git clone https://github.com/pyenv/pyenv.git ~/.pyenv

    # Environment variables settings
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
    echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
    echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/.zshrc

    # Install pyenv version with --enable-shared for YouCompleteMe compatability
    # Set up global version and install YouCompleteMe extensions
    env PYTHON_CONFIGURE_OPTS="--enable-shared" pyenv install 3.8.6
    pyenv global 3.8.6
    pip3 install -U pip autopep8 flake8 jedi
}

java_8_install() {
    # Package install java-8 by adding apt repository
    sudo add-apt-repository ppa:webupd8team/java
    sudo apt-get update
    sudo apt-get install -y oracle-java8-installer oracle-java8-set-default
}

YouCompleteMe_install() {
    # Package install dependcies
    sudo apt-get install -y build-essential cmake python-dev python3-dev npm
    cd ~/.vim/plugged/YouCompleteMe

    # If python is installed with pyenv with --enable-shared
    python3 install.py --clang-completer --cs-completer --js-completer --java-completer

    # Else use system python
    /usr/bin/python3 install.py --clang-completer --cs-completer --js-completer --java-completer
}

vim_markdown_preview_dependencies() {
    # Package install dependcies
    sudo apt-get install -y xdotool

    # Pip install grip
    pip install grip
}

powerline_font_install() {
    # Source powerline-fonts
    git clone https://github.com/powerline/fonts.git --depth=1

    # Install
    cd fonts
    ./install.sh

    # Clean-up
    cd ..
    rm -rf fonts
}

cuda_driver() {
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
}


###################################
# Main body of script starts here #
###################################

echo "Start custom installation"


###################################
# Deprecated installation scripts #
###################################
#
# Deprecated as on Ubuntu 20.04, tmux version 3.0a can be installed by
# sudo apt-get install -y tmux
# 
# tmux_build_from_source() {
#     sudo apt-get -y remove tmux
#     sudo apt-get -y install wget tar libevent-dev libncurses-dev checkinstall
#     wget https://github.com/tmux/tmux/releases/download/2.7/tmux-2.7.tar.gz
#     tar xf tmux-2.7.tar.gz
#     rm -f tmux-2.7.tar.gz
#     cd tmux-2.7
#     ./configure
#     make
#     sudo checkinstall
#
#     cd -
#     sudo rm -rf /usr/local/src/tmux-*
#     sudo mv tmux-2.7 /usr/local/src
# }
#
# Deprecated as started using i3wm.
# Also, unity-tweak-tool is also replaced by gnome-tweak-tool after ubuntu 17.04
# numix_theme() {
#     # Package install numix-theme by adding apt repository
#     sudo add-apt-repository ppa:numix/ppa
#     sudo apt-get update
#     sudo apt-get install -y unity-tweak-tool numix-gtk-theme numix-icon-theme-circle
# }
