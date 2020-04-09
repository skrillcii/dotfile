
# OS system recognition Starts
case `uname` in
    Darwin)
    function chpwd() {ls -a}
    alias vim='/Applications/MacVim.app/Contents/MacOS/Vim'
    alias gvim='/Applications/MacVim.app/Contents/MacOS/MacVim'
    ;;
    Linux)
        ;;
esac

# Attaching tmux sessions Starts
function chpwd() {ls -a}

if [[ ! -n $TMUX ]]; then
    tmux -2 attach || tmux -2 new-session

else
    if [[ `\tmux -V | cut -d" " -f2` -lt 2.1 ]]
    then
        tmux set -g mode-mouse on
        tmux set -g mouse-resize-pane on
        tmux set -g mouse-select-pane on
        tmux set -g mouse-select-window on
        clear
    else
        tmux set -g mouse on
        clear
    fi
fi

# setup default text editor
#export EDITOR=/usr/bin/vim         # apt built-in
export EDITOR=/usr/local/bin/vim  # self-compiled

# fzf setting
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS='--height 40% --reverse --border'

# Japanese encoding setting
export LC_CTYPE="C.UTF-8"

# Python encoding
export PYTHONIOENCODING=utf8

# Pyenv path settings
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# CUDA and cuDNN paths
export PATH=/usr/local/cuda-9.0/bin:${PATH}
export LD_LIBRARY_PATH=/usr/local/cuda-9.0/lib64:${LD_LIBRARY_PATH}

# ROS env path
source /opt/ros/kinetic/setup.zsh

# IBM Cloud auto-completion
source /usr/local/ibmcloud/autocomplete/zsh_autocomplete

