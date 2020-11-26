#!/usr/bin/bash


##############
# Fail Check #
##############
# REFERENCE: https://stackoverflow.com/questions/2870992/automatic-exit-from-bash-shell-script-on-error
# -e exits on error, -u errors on undefined variables, and -o (for option) pipefail exits on command pipe failures. 
# set -euxo pipefail


#############
# Functions #
#############

check_execution() {
    if [ $? -eq 0 ]; then
        echo -e "\033[34mexecution checked\e[0m"
    else
        echo -e "\033[31mexecution failed\e[0m"
    fi

    # Or pipe the following command to the execution output
    # command && echo SUCCESS || echo FAIL
}

install_desktop_environment() {
    echo -e "\n >>> General Installation Started..."

    # Package install general
    sudo apt-get install -y zsh tmux vim curl xclip vlc ffmpeg \
                            checkinstall redshift docker.io \
                            htop glances lm-sensors mesa-utils \
    check_execution

    # Package install fcitx
    sudo apt-get install -y fcitx-bin fcitx-chewing fcitx-mozc fcitx-googlepinyin
    check_execution

    # Package install lightdm
    # \\\\\\\\\\\\\\\\ #
    # Needs automation #
    # \\\\\\\\\\\\\\\\ #
    sudo apt-get install -y lightdm
    check_execution

    # Initialize lm-sensors
    # \\\\\\\\\\\\\\\\ #
    # Needs automation #
    # \\\\\\\\\\\\\\\\ #
    sudo sensors-detect

    # Create symbolic links
    ln -s -f ~/dotfiles/vim/vimrc ~/.vimrc
    ln -s -f ~/dotfiles/x/xprofile ~/.xprofile
    ln -s -f ~/dotfiles/pdb/pdbrc.py ~/.pdbrc.py
    ln -s -f ~/dotfiles/redshift/redshift.conf ~/.config/redshift.conf
    check_execution

    echo -e " <<< General Installation Finished!"
}

install_oh_my_zsh() {
    echo -e "\n >>> Oh-my-zsh Installation Started..."

    # Package install zsh
    sudo apt-get install -y zsh
    check_execution

    # Download oh-my-zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended
    check_execution

    # Download oh-my-zsh plugins
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/custom/plugins/zsh-completions
    echo 'source ~/dotfiles/zsh/zshrc' >> ~/.zshrc
    check_execution

    echo -e " <<< Oh-my-zsh Installation Finished!"
}

install_tmux_plugin_manager() {
    echo -e "\n >>> Tmux-plugin-manager Installation Started..."

    # Package install tmux
    sudo apt-get install -y tmux
    check_execution

    # Download tmux-plugin-manager
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    check_execution

    echo -e " <<< Tmux-plugin-manager Installation Finished!"
}

install_oh_my_tmux() {
    echo -e "\n >>> Oh-my-tmux Installation Started..."

    # Download oh-my-tmuxgt
    git clone https://github.com/gpakosz/.tmux.git ~/.oh-my-tmux
    check_execution

    # Create symbolic links and source configurations
    echo -e 'creating symbolic links...'
    ln -s -f ~/.oh-my-tmux/.tmux.conf ~/.tmux.conf
    ln -s -f ~/.oh-my-tmux/.tmux.conf.local ~/.tmux.conf.local
    echo 'source ~/dotfiles/tmux/tmux.conf.local' >> ~/.tmux.conf.local
    check_execution

    echo -e " <<< Oh-my-tmux Installation Finished!"
}

install_vim_build_from_source() {
    echo -e "\n >>> Vim Installation Started..."

    # Package install dependencies:
    sudo apt-get install -y libncurses5-dev libgnome2-dev libgnomeui-dev \
                            libgtk2.0-dev libatk1.0-dev libbonoboui2-dev \
                            libcairo2-dev libx11-dev libxpm-dev libxt-dev python-dev \
                            python3-dev ruby-dev lua5.1 lua5.1-dev libperl-dev git \
    check_execution

    # Remove old vim:
    sudo apt-get remove vim vim-runtime gvim
    check_execution

    # Source, configure and build
    git clone https://github.com/vim/vim.git ~/vim
    check_execution
    cd vim

    # Use '$(python3-config --configdir)' to check for flag '--with-python3-config-dir'
    # To check python path in vim ':python3 import sys; print(sys.path)'
    make clean distclean
    check_execution

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
    check_execution

    make VIMRUNTIMEDIR=/usr/local/share/vim/vim82
    check_execution

    # Install with checkinstall
    cd ~/vim
    sudo checkinstall
    check_execution

    # Remove directory
    cd ~
    sudo rm -rf ~/vim
    check_execution

    echo -e " <<< Vim Installation Finished!"
}

install_vim_plugin_manager() {
    echo -e "\n >>> Vim-plugin-manager Installation Started..."

    # For tagbar vim plugin
    sudo apt-get install -y vim exuberant-ctags
    check_execution

    # Download vim-plug
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    check_execution

    # Create symbolic links
    echo -e 'creating symbolic links...'
    ln -s -f ~/dotfiles/vim/vimrc ~/.vimrc
    check_execution

    # Install plugins
    vim -E -s -u "~/.vimrc" +PlugInstall +qall
    check_execution

    echo -e " <<< Vim-plugin-manager Installation Finished!"
}

install_pyenv() {
    echo -e "\n >>> Pyenv Installation Started..."

    # Dependencies
    sudo apt-get install -y --no-install-recommends \
                            build-essential libssl-dev zlib1g-dev libbz2-dev \
                            libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
                            xz-utils tk-dev libffi-dev liblzma-dev python-openssl git
    check_execution

    # Download pyenv
    git clone https://github.com/pyenv/pyenv.git ~/.pyenv
    check_execution

    # Environment variables settings
    echo -e 'exporting environmental variabls...'
    echo 'export PYENV_ROOT="~/.pyenv"' >> ~/.bashrc
    echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
    echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/.bashrc
    check_execution

    # Install pyenv version with --enable-shared for YouCompleteMe compatability
    # Set up global version and install YouCompleteMe extensions
    # env PYTHON_CONFIGURE_OPTS="--enable-shared" pyenv install 3.8.6
    env PYTHON_CONFIGURE_OPTS="--enable-shared" ~/.pyenv/bin/pyenv install 3.8.6
    check_execution
    ~/.pyenv/bin/pyenv global 3.8.6
    check_execution
    ~/.pyenv/shims/pip3 install -U pip autopep8 flake8 yapf ipdb pdbpp
    check_execution

    echo -e " <<< Pyenv Installation Finished!"
}

install_fzf() {
    echo -e "\n >>> Fzf Installation Started..."

    # Download fzf
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    check_execution

    # Install fzf
    ~/.fzf/install --key-bindings --completion --no-update-rc
    check_execution

    echo -e " <<< Fzf Installation Finished!"
}

install_ranger() {
    echo -e "\n >>> Ranger Installation Started..."

    # Package install ranger and other utilities
    sudo apt-get install -y ranger caca-utils w3m highlight atool poppler-utils mediainfo
    check_execution

    # Check if directory exists
    echo -e 'creating custom theme directory...'
    if [[ ! -e ~/.config/ranger ]] ; then
        mkdir -p ~/.config/ranger
    fi
    check_execution

    # Create symbolic links
    echo -e 'creating symbolic links...'
    ln -s -f ~/dotfiles/ranger/commands.py ~/.config/ranger/
    ln -s -f ~/dotfiles/ranger/commands_full.py ~/.config/ranger/
    ln -s -f ~/dotfiles/ranger/rc.conf ~/.config/ranger/
    ln -s -f ~/dotfiles/ranger/rifle.conf ~/.config/ranger/
    ln -s -f ~/dotfiles/ranger/scope.sh ~/.config/ranger/
    check_execution

    # Mount disk command, use `lsblk` to list disks and partitions
    # Then use `udisksctl` to mount the /dev/sdxY, assuming target disk is /dev/sdb1
    # Run the following commands:
    # $ lsblk
    # $ udisksctl mount -b /dev/sdb1

    echo -e " <<< Ranger Installation Finished!"
}

install_java_11() {
    echo -e "\n >>> Java-11 Installation Started..."

    # Package install java-11
    sudo apt-get install -y default-jre default-jdk maven
    check_execution

    echo -e " <<< Java-11 Installation Finished!"
}

install_java_11() {

}

install_coc() {
    echo -e "\n >>> Coc Installation Started..."

    # Package install dependcies
    sudo apt-get install -y nodejs npm
    check_execution

    # \\\\\\\\\\\\\\\\\\\\\\\\ #
    # Still need confirmation  #
    # \\\\\\\\\\\\\\\\\\\\\\\\ #
    # Vimplug install & update extensions and quit
    vim -c 'CocInstall -sync coc-python coc-java coc-html coc-css \
                             coc-json coc-xml coc-yaml \
                             coc-vimlsp coc-yank coc-snippets | q'
    vim -c 'CocUpdateSync|q'

    # \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ #
    # If coc-java has issue with jdt #
    # \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ #
    # cd ~/.config/coc/extensions/coc-java-data
    # wget https://download.eclipse.org/jdtls/milestones/0.57.0/jdt-language-server-0.57.0-202006172108.tar.gz
    # tar -xvf jdt-language-server-0.57.0-202006172108.tar.gz ./server/
    # ln -s -f ./server ~/.config/coc/extensions/coc-java-data/server

    # Create symbolic links
    ln -s -f ~/dotfiles/coc/coc-settings.json ~/.vim/coc-settings.json
    ln -s -f ~/dotfiles/coc/python.snippets ~/.config/coc/ultisnips/python.snippets

    echo -e " <<< Coc Installation Finished!"
}

install_komodo() {
    echo -e "\n >>> Komodo Installation Started..."

    cd ~ && mkdir komodo && cd komodo
    wget http://downloads.activestate.com/Komodo/releases/11.1.0/remotedebugging/Komodo-PythonRemoteDebugging-11.1.0-91033-linux-x86.tar.gz
    tar -xvf ~/komodo/Komodo-PythonRemoteDebugging-11.1.0-91033-linux-x86.tar.gz

    # Create symbolic links
    # First, create shorter reference path
    # For version 8 or greater, then you will need to move the dbgp directory, which is
    # inside pythonlib, to the same directory that contains the pydbgp executable.
    # If you don't do this then you will get an error saying "No module named dbgp.client".
    ln -s -f ~/komodo/Komodo-PythonRemoteDebugging-11.1.0-91033-linux-x86 \
            ~/komodo/dbgp
    ln -s -f ~/komodo/Komodo-PythonRemoteDebugging-11.1.0-91033-linux-x86/python3lib/dbgp \
            ~/komodo/Komodo-PythonRemoteDebugging-11.1.0-91033-linux-x86/dbgp

    # Press F5 in vim to start watiing for connection, then to start a python script
    # Note: the source code of pydbgp contant keywords 'async', modify it to 'async_' accordingly
    python3 -S ~/komodo/dbgp/pydbgp -d localhost:9000 script.py

    # Default commands:
    # F05 - start debuger
    # F02 - step over
    # F03 - step in
    # F04 - step out
    # F07 - detach
    # F06 - stop/close
    # F09 - run to cursor
    # F10 - set/unset breakpoint

    echo -e " <<< Komodo Installation Finished!"
}

install_zsh_gruvbox_theme() {
    echo -e "\n >>> Zsh-grubox-theme Installation Started..."

    # Check directory exists
    if [[ ! -e ~/.oh-my-zsh/custom/themes ]] ; then
        mkdir -p ~/.oh-my-zsh/custom/themes
    fi

    # Download gruvbox-theme
    curl -L https://raw.githubusercontent.com/sbugzu/gruvbox-zsh/master/gruvbox.zsh-theme \
        > ~/.oh-my-zsh/custom/themes/gruvbox.zsh-theme
    check_execution

    # Export zshrc settings
    # ZSH_THEME="gruvbox"
    # SOLARIZED_THEME="dark"

    echo -e " <<< Zsh-gruvbox-theme Installation Finished!"
}


####################
# Desktop Specific #
####################

install_powerline_fonts() {
    echo -e "\n >>> Powerline-fonts Installation Started..."

    # Source powerline-fonts
    git clone https://github.com/powerline/fonts.git --depth=1 ~/fonts
    check_execution

    # Install
    cd ~/fonts
    ./install.sh
    check_execution

    # Clean-up
    rm -rf ~/fonts
    check_execution

    echo -e " <<< Powerline-fonts Installation Finished!"
}

install_nerd_fonts() {
    echo -e "\n >>> Nerd-fonts Installation Started..."

    # Source nerd-fonts
    git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git ~/nerd-fonts
    check_execution

    # Install font of your choice
    ~/nerd-fonts/install.sh HeavyData SpaceMono
    check_execution

    # Clean-up
    rm -rf ~/near-fonts
    check_execution

    echo -e " <<< Nerd-fonts Installation Finished!"
}


install_i3wm() {
    echo -e "\n >>> I3wn Installation Started..."

    # Package install i3
    sudo apt-get install -y i3 i3blocks
    check_execution

    # Package install extensions
    sudo apt-get install -y imagemagick feh playerctl
    check_execution

    # Pip install extensions
    pip3 install psutil netifaces
    check_execution

    # Convert Ubuntu 20.04 default wallpaper from .jpg to .png
    convert -scale 2560x1440 /usr/share/backgrounds/matt-mcnulty-nyc-2nd-ave.jpg /usr/share/backgrounds/lockscreen.png

    # Source extensions
    git clone https://github.com/gabrielelana/awesome-terminal-fonts.git ~/awesome-terminal-fonts
    check_execution

    cd ~/awesome-terminal-fonts && ./install.sh
    check_execution

    cd .. && rm -rf ~/awesome-terminal-fonts
    check_execution

    git clone https://github.com/tobi-wan-kenobi/bumblebee-status.git ~/bumblebee-status
    check_execution

    # Check directory exists
    if [[ ! -e ~/.config/i3 ]] ; then
        mkdir -p ~/.config/i3
    fi

    mv ~/bumblebee-status ~/.config/i3/bumblebee-status
    check_execution

    # Create symbolic links
    ln -s -f ~/.config/i3/bumblebee-status/bumblebee-status ~/.config/i3/bumblebee-status/bumblebee-status.py
    ln -s -f ~/dotfiles/i3/i3main.conf ~/.config/i3/config
    ln -s -f ~/dotfiles/i3/i3status.conf ~/.i3status.conf
    sudo ln -s -f ~/dotfiles/i3/i3exit.sh /usr/local/bin/i3exit
    check_execution

    echo -e " <<< I3wm Installation Finished!"
}


#############
# Utilities #
#############

install_spotify(){
    echo -e "\n >>> Spotify Installation Started..."

    # From official release
    # Reference: https://www.spotify.com/us/download/linux/
    curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | sudo apt-key add -
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
    check_execution

    sudo apt-get update && sudo apt-get install -y spotify-client
    check_execution

    echo -e " <<< Spotify Installation Finished!"
}


install_moonlander(){
    echo -e "\n >>> Moonlander Installation Started..."

    # Package install dependcies
    # Currently, only cli dependency is listed here
    sudo apt-get install -y libusb-dev
    check_execution

    # Download wally binary version 'gui' or 'cli'
    # Currently only wally-cli is used and is already provided in dotfiles
    # cd ~ && wget https://configure.ergodox-ez.com/wally/linux
    # check_execution
    # cd ~ && wget https://github.com/zsa/wally-cli/releases/download/2.0.0-linux/wally-cli
    # check_execution

    # Low-level device communication kernel scripts
    sudo ln -s -f ~/dotfiles/moonlander/50-oryx.rules /etc/udev/rules.d/
    sudo ln -s -f ~/dotfiles/moonlander/50-wally.rules /etc/udev/rules.d/
    check_execution

    # # Check if plugdev group exists and if user is in plugdev group, if not create and add
    if [ $(getent group 'plugdev') ]; then
        echo "Group plugdev exists! Done!"
    else
        echo "Group plugdev does not exist!"
        echo "Create plugdev group..."
        sudo groupadd plugdev
        sudo usermod -aG plugdev $USER
        echo "Done!"
    fi
    check_execution

    echo -e " <<< Moonlander Installation Finished!"
}

install_screenkey() {
    echo -e "\n >>> Screenkey Installation Started..."

    # Package install dependencies
    sudo apt-get install -y python3-gi gir1.2-gtk-3.0 python3-cairo \
                            python3-setuptools python3-distutils-extra \
                            fonts-font-awesome slop gir1.2-appindicator3-0.1 \
    check_execution

    # Pip install dependencies
    pip3 install vext vext.gi

    # Source screenkey v1.2 from 'https://www.thregr.org/~wavexx/software/screenkey/'
    cd ~ && wget https://www.thregr.org/~wavexx/software/screenkey/releases/screenkey-1.2.tar.gz
    tar -xvf ~/screenkey-1.2.tar.gz
    rm -rf ~/screenkey-1.2.tar.gz
    mv ~/screenkey-1.2 ~/.config
    check_execution

    # Portable without installation (preferred way of using)
    # sudo ./screenkey

    # Set alias (e.g configure in .zshrc)
    # sudo screenkey

    # Install & uninstall onto system
    # sudo ~/screenkey-1.2/setup.py install --record files.txt
    # cat files.txt | xargs sudo rm -rf

    echo -e " <<< Screenkey Installation Finished!"
}

install_kazam() {
    echo -e "\n >>> Kazam Installation Started..."

    # Package install
    sudo apt-get install -y kazam
    check_execution

    # Keybindings
    # Super key + CTRL + R = Start recording.
    # Super key + CTRL + P = Pause recording, press again to resume.
    # Super key + CTRL + F = Finish recording.
    # Super key + CTRL + Q = Quit recording.

    echo -e " <<< Kazam Installation Finished!"
}

install_ffmpeg() {
    echo -e "\n >>> Ffmpeg Installation Started..."

    # Package install
    sudo apt-get install -y ffmpeg
    check_execution

    # Example usage for video compression
    # ffmpeg -i input.mp4 output.mp4

    echo -e " <<< Ffmpeg Installation Finished!"
}


########
# Main #
########

echo -e "\n >>> Start Custom Installation..."
sudo apt-get update

# General setup
install_desktop_environment
install_oh_my_zsh
install_tmux_plugin_manager
install_oh_my_tmux
install_vim_plugin_manager
install_pyenv
install_fzf
install_ranger
install_java_11
install_coc
install_komodo
install_zsh_gruvbox_theme

# Desktop specific
install_powerline_fonts
install_nerd_fonts
install_i3wm

# Utilities
install_spotify
install_moonlander
install_screenkey
install_kazam
install_ffmpeg

sudo apt-get autoremove -y
echo -e "\n >>> Finished All Custom Installation!"

# Reload shell
$SHELL
