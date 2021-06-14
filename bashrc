# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

OS_ICON=  # Replace this with your OS icon
PS1="\n \[\033[0;34m\]╭─\[\033[0;31m\]\[\033[0;37m\]\[\033[41m\] $OS_ICON \u \[\033[0m\]\[\033[0;31m\]\[\033[44m\]\[\033[0;34m\]\[\033[44m\]\[\033[0;30m\]\[\033[44m\] \w \[\033[0m\]\[\033[0;34m\] \n \[\033[0;34m\]╰ \[\033[1;36m\]\$ \[\033[0m\]"

. ~/dotfiles/base_profile
# User specific aliases and functions
. ~/dotfiles/profile

