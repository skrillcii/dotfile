#
##### OS system recognition Starts
case `uname` in
    Darwin)
    function chpwd() {ls -a}
    #alias vim='/Applications/MacVim.app/Contents/MacOS/Vim'
    #alias gvim='/Applications/MacVim.app/Contents/MacOS/MacVim'
    ;;
    Linux)
        ;;
esac


##### Attaching tmux sessions Starts
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

