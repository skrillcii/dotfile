#!/usr/bin/bash
#!/usr/bin/zsh

###################################
# Functions of script starts here #
###################################

general_install() {
    # Package install general
    sudo apt-get install -y zsh tmux vim curl xclip vlc ffmpeg \
        checkinstall redshift \
        htop glances lm-sensors mesa-utils \

    # Package install fcitx
    sudo apt-get install -y fcitx-bin fcitx-chewing fcitx-mozc

    # Package install lightdm
    sudo apt-get install -y lightdm

    # Initialize lm-sensors
    sudo sensors-detect

    # Create symbolic links
    ln -s -f ~/dotfile/vim/vimrc ~/.vimrc
    ln -s -f ~/dotfile/x/xprofile ~/.xprofile
    ln -s -f ~/dotfile/redshift/redshift.conf ~/.config/redshift.conf
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

tmux_plugin_manager_install() {
    # Package install tmux
    sudo apt-get install -y tmux

    # Source tmux-plugin-manager
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
}

oh_my_tmux_install() {
    # Source oh-my-tmux
    git clone https://github.com/gpakosz/.tmux.git "$HOME/.oh-my-tmux/"

    # Create symbolic links and source configurations
    ln -s -f "$HOME/.oh-my-tmux/.tmux.conf" "$HOME/.tmux.conf"
    ln -s -f "$HOME/.oh-my-tmux/.tmux.conf.local" "$HOME/.tmux.conf.local"
    echo 'source ~/dotfile/tmux/tmux.conf.local' >> "$HOME/.tmux.conf.local"
}

vim_build_from_source() {
    # Package install dependencies:
    sudo apt-get install -y libncurses5-dev libgnome2-dev libgnomeui-dev \
        libgtk2.0-dev libatk1.0-dev libbonoboui2-dev \
        libcairo2-dev libx11-dev libxpm-dev libxt-dev python-dev \
        python3-dev ruby-dev lua5.1 lua5.1-dev libperl-dev git \

    # Remove old vim:
    sudo apt-get remove vim vim-runtime gvim

    # Source, configure and build
    git clone https://github.com/vim/vim.git ~/
    cd vim

    # Use '$(python3-config --configdir)' to check for flag '--with-python3-config-dir'
    # To check python path in vim ':python3 import sys; print(sys.path)'
    make clean distclean
    ./configure --with-features=huge \
        --enable-multibyte \
        --enable-terminal \
        --enable-rubyinterp=yes \
        --enable-python3interp=yes \
        --with-python3-config-dir=$(python3-config --configdir) \
        --enable-perlinterp=yes \
        --enable-gui=gtk3 \
        --enable-cscope \
        --prefix=/usr/local \
        --enable-fail-if-missing \
        make VIMRUNTIMEDIR=/usr/local/share/vim/vim82

    # Install with checkinstall
    cd ~/vim
    sudo checkinstall

    # Remove directory
    cd ~
    sudo rm -rf ~/vim
}

vim_plugin_manager_install() {
    # For tagbar vim plugin
    sudo apt-get install -y exuberant-ctags

    # Source vim-plug
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    }

fzf_install() {
    # Source fzf
    git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"

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

pyenv_install() {
    # Dependencies
    sudo apt-get install -y --no-install-recommends
    make build-essential libssl-dev zlib1g-dev \
        libbz2-dev libreadline-dev libsqlite3-dev wget \
        curl llvm libncurses5-dev xz-utils tk-dev \
        libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev \

    # Source pyenv
    git clone https://github.com/pyenv/pyenv.git "$HOME/.pyenv"

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

java_11_install() {
    # Package install java-11
    sudo apt-get install -y default-jre default-jdk
}

apache_maven_install() {
    # Package install maven-3.6.3
    sudo apt-get install -y maven
}

YouCompleteMe_install() {
    # Package install dependencies:
    sudo apt-get install -y build-essential cmake python-dev python3-dev npm
    cd ~/.vim/plugged/YouCompleteMe

    # If python is installed with pyenv with --enable-shared
    python3 install.py --clang-completer --cs-completer --js-completer --java-completer

    # Else use system python
    /usr/bin/python3 install.py --clang-completer --cs-completer --js-completer --java-completer
}

vim_markdown_preview_dependencies() {
    # Package install dependencies:
    sudo apt-get install -y xdotool

    # Pip install grip
    pip install grip
}

powerline_font_install() {
    # Source powerline-fonts
    git clone https://github.com/powerline/fonts.git --depth=1 ~/

    # Install
    cd fonts
    ./install.sh

    # Clean-up
    cd ..
    rm -rf fonts
}

nerd_font_install() {
    # Source nerd-fonts
    git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git ~/

    # Install font of your choice
    ~/nerd-font/install.sh HeavyData SpaceMono
}

zsh_gruvbox_theme_install() {
    # Source gruvbox-theme
    curl -L https://raw.githubusercontent.com/sbugzu/gruvbox-zsh/master/gruvbox.zsh-theme > ~/.oh-my-zsh/custom/themes/gruvbox.zsh-theme

    # Export zshrc settings
    ZSH_THEME="gruvbox"
    SOLARIZED_THEME="dark"
}

i3_install() {
    # Package install i3
    sudo apt-get install -y i3 i3blocks

    # Package install extensions
    sudo apt-get install -y imagemagick feh playerctl

    # Pip install extensions
    pip3 install psutil netifaces

    # Source extensions
    git clone https://github.com/gabrielelana/awesome-terminal-fonts.git ~/
    cd ~/awesome-terminal-fonts && ./install.sh
    cd .. && rm -rf ~/awesome-terminal-fonts

    git clone https://github.com/tobi-wan-kenobi/bumblebee-status.git ~/
    mv ~/bumblebee-status ~/.config/i3

    # Create symbolic links
    ln -s -f ~/dotfile/i3/i3main.conf ~/.config/i3/config
    ln -s -f ~/dotfile/i3/i3status.conf ~/.i3status.conf
    sudo ln -s -f ~/dotfile/i3/i3exit.sh /usr/local/bin/i3exit
}

moonlander_install(){
    # Package install dependcies
    # Currently, only cli dependency is listed here
    sudo apt-get install -y libusb-dev

    # Download wally binary version 'gui' or 'cli'
    # Currently only wally-cli is used
    cd ~ && wget https://configure.ergodox-ez.com/wally/linux
    cd ~ && wget https://github.com/zsa/wally-cli/releases/download/2.0.0-linux/wally-cli

    # Low-level device communication kernel scripts
    sudo ln -s -f ~/dotfile/moonlander/50-oryx.rules /etc/udev/rules.d/
    sudo ln -s -f ~/dotfile/moonlander/50-wally.rules /etc/udev/rules.d/

    # Check if plugdev group exists and if user is in plugdev group, if not create and add
    groups
    sudo groupadd plugdev
    sudo usermod -aG plugdev $USER
}

screenkey_() {
    # Package install dependencies
    sudo apt-get install -y python3-gi gir1.2-gtk-3.0 python3-cairo \
        python3-setuptools python3-distutils-extra \
        fonts-font-awesome slop gir1.2-appindicator3-0.1 \

    # Source screenkey v1.2 from 'https://www.thregr.org/~wavexx/software/screenkey/'
    cd ~ && wget https://www.thregr.org/~wavexx/software/screenkey/releases/screenkey-1.2.tar.gz
    tar -xvf ./screenkey-1.2.tar.gz && cd ./screenkey-1.2.tar.gz

    # Portable without installation (preferred way of using)
    sudo ./screenkey

    # Or following if alias is set (configured in .zshrc)
    sudo screenkey

    # Install or uninstall onto system
    sudo ./setup.py install --record files.txt
    cat files.txt | xargs sudo rm -rf
}

kazam_install() {
    # Package install
    sudo apt-get install -y kazam

    # Keybindings
    # Super key + CTRL + R = Start recording.
    # Super key + CTRL + P = Pause recording, press again to resume.
    # Super key + CTRL + F = Finish recording.
    # Super key + CTRL + Q = Quit recording.
}

ffmpeg() {
    # Package install
    sudo apt-get install -y ffmpeg

    # Example usage for video compression
    ffmpeg -i input.mp4 output.mp4
}

cuda_driver_install() {
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
# ---------------------------------------------------------------------
# Deprecated as on Ubuntu 20.04, tmux version 3.0a can be installed by
# sudo apt-get install -y tmux
# ---------------------------------------------------------------------
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
# ---------------------------------------------------------------------
# Deprecated as on Ubuntu 20.04, java-11 can be installed by
# sudo apt-get install -y default-jre default-jdk
# ---------------------------------------------------------------------
#
# java_8_install() {
#     # Package install java-8 by adding apt repository
#     sudo add-apt-repository ppa:webupd8team/java
#     sudo apt-get update
#     sudo apt-get install -y oracle-java8-installer oracle-java8-set-default
# }
#
# ---------------------------------------------------------------------
# Deprecated as on Ubuntu 20.04, maven-3.6.3 can be installed by
# sudo apt-get install -y maven
# ---------------------------------------------------------------------
#
# apache_maven_install() {
#     # Source apache-maven
#     cd ~
#     wget https://ftp.riken.jp/net/apache/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz
#
#     # Extract, move to system path, create symbolic link
#     tar -xvf apache-maven-3.6.3-bin.tar.gz
#     sudo mv apache-maven-3.6.3 /usr/local/apache-maven/apache-maven-3.6.3
#     sudo ln -s /usr/local/apache-maven/apache-maven.3.6.3 /usr/local/apache-maven/apache-maven
#
#     # Clean up
#     rm ~/apache-maven-3.6.3-bin.tar.gz
# }
#
# ---------------------------------------------------------------------
# Deprecated as started using i3wm.
# Unity-tweak-tool is replaced by gnome-tweak-tool after ubuntu 17.04
# ---------------------------------------------------------------------
#
# numix_theme() {
#     # Package install numix-theme by adding apt repository
#     sudo add-apt-repository ppa:numix/ppa
#     sudo apt-get update
#     sudo apt-get install -y unity-tweak-tool numix-gtk-theme numix-icon-theme-circle
# }
