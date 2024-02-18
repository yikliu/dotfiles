# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

if [ -h '/usr/local/bin/vim' ]; then
    alias vim='/usr/local/bin/vim'
fi

# Path setting for Homebrew
export TERM_EDITOR=vim
export EDITOR=vim

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

#set color to 256
export TERM=xterm-256color
export LS_COLORS="$(vivid generate snazzy)"
export PYTHONIOENCODING=utf-8

force_color_prompt=yes

# PATH
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
export PATH=/usr/local/bin:/usr/local/sbin:$PATH
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="/usr/local/opt/ruby/bin:$PATH"
export PATH="/usr/local/anaconda3/bin:$PATH"
export PATH="/Users/yikunliu/Library/Android/sdk/build-tools/30.0.2:$PATH"
export PATH="/usr/local/opt/ruby/bin:$PATH"
export PATH="$HOME/.gem/ruby/X.X.0/bin:$PATH"

export GOPATH=$HOME/code/go

if type rg &> /dev/null; then
  export FZF_DEFAULT_COMMAND='rg --files'
  export FZF_DEFAULT_OPTS='-m --height 50% --border'
fi

export JAVA_HOME=$(/usr/libexec/java_home)

# fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

export JAVA_TOOLS_OPTIONS="-Dlog4j2.formatMsgNoLookups=true"

source ~/dotfiles/myalias
source ~/amazon
. "$HOME/.cargo/env"
