# PATH
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
export PATH=/usr/local/bin:/usr/local/sbin:$PATH
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
source ~/dotfiles/myalias
source ~/amazon

. "$HOME/.cargo/env"
