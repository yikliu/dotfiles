# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

. ~/dotfiles/base_profile

# User specific aliases and functions
. ~/dotfiles/profile 

# fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

export JAVA_TOOLS_OPTIONS="-Dlog4j2.formatMsgNoLookups=true"

source ~/dotfiles/myalias
source ~/amazon
