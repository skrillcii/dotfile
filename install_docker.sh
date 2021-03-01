#!/usr/bin/bash


###############
# Instruction #
###############
# To run this installation script calling bash in interactive mode is required
# due to command `source ~/.bashrc` involved in the setup process.
# To install in interactive mode:
# $ bash -i ~/dotfiles/install_docker.sh


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

install_general() {
    echo -e "\n >>> General Installation Started..."

    # Package install general
    sudo apt-get install -y xclip checkinstall cmake python3-dev 
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

    echo -e " <<< Ranger Installation Finished!"
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
    ~/.pyenv/shims/pip3 install -U pip autopep8 pylint flake8 yapf ipdb pdbpp jedi
    check_execution

    echo -e " <<< Pyenv Installation Finished!"
}

install_java_11() {
    echo -e "\n >>> Java-11 Installation Started..."

    # Package install java-11
    sudo apt-get install -y default-jre default-jdk maven
    check_execution

    echo -e " <<< Java-11 Installation Finished!"
}

install_coc() {
    echo -e "\n >>> Coc Installation Started..."

    # Package install dependcies
    sudo apt-get install -y nodejs npm
    check_execution

    # \\\\\\\\\\\\\\\\\\\\\\\\ #
    # Still need confirmation  #
    # \\\\\\\\\\\\\\\\\\\\\\\\ #
    # Install all configured plugins in vimrc by 'CocEnable' command
    vim -c 'CocEnable'

    # Vimplug install & update extensions and quit
    # vim -c 'CocInstall -sync coc-python coc-java coc-html coc-css \
    #                          coc-json coc-xml coc-yaml \
    #                          coc-vimlsp coc-yank coc-snippets | q'
    # vim -c 'CocUpdateSync|q'

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


########
# Main #
########

echo -e "\n >>> Start Custom Installation..."

sudo apt-get update
install_general
install_oh_my_zsh
install_tmux_plugin_manager
install_oh_my_tmux
install_vim_plugin_manager
install_fzf
install_ranger
install_pyenv
install_java_11
install_coc
install_zsh_gruvbox_theme

echo -e "\n >>> Finished All Custom Installation!"

# Reload shell
$SHELL
