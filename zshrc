# .zshrc

# Source global definitions
if [ -f /etc/zshrc ]; then
    . /etc/zshrc
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

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

#set color to 256
export TERM=xterm-256color
force_color_prompt=yes

# PATH
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
export PATH=/usr/local/bin:/usr/local/sbin:$PATH
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="/usr/local/opt/ruby/bin:$PATH"
export PATH="/usr/local/anaconda3/bin:$PATH"
export PATH="$HOME/Library/Android/sdk/build-tools/30.0.2:$PATH"
export PATH="$HOME/.gem/ruby/X.X.0/bin:$PATH"
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export PATH="$HOME/jdtls/bin:$PATH"
export PATH="$GOPATH/bin:$PATH"
export PATH=$PATH:$HOME/.spicetify

export GOPATH=$HOME/code/go

if type rg &> /dev/null; then
  export FZF_DEFAULT_COMMAND='rg --files'
  export FZF_DEFAULT_OPTS='-m --height 50% --border'
fi

export JAVA_HOME=$(/usr/libexec/java_home)
export JAVA_TOOLS_OPTIONS="-Dlog4j2.formatMsgNoLookups=true"

export PYTHONIOENCODING=utf-8

#fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS='--color=bg+:#302D41,bg:#1E1E2E,spinner:#F8BD96,hl:#F28FAD --color=fg:#D9E0EE,header:#F28FAD,info:#DDB6F2,pointer:#F8BD96 --color=marker:#F8BD96,fg+:#F2CDCD,prompt:#DDB6F2,hl+:#F28FAD'

fpath=($fpath "$HOME/.zfunctions")

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

source ~/dotfiles/myalias
source ~/amazon
