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
export PYTHONPATH="/Library/Python/3.8/site-packages"
export ML_PATH="/Users/yikunliu/code/ml"

if type rg &> /dev/null; then
  export FZF_DEFAULT_COMMAND='rg --files'
  export FZF_DEFAULT_OPTS='-m --height 50% --border'
fi

JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_231.jdk/Contents/Home
export JAVA_HOME;

source ~/dotfiles/myalias
source ~/amazon
export JAVA_TOOLS_OPTIONS="-Dlog4j2.formatMsgNoLookups=true"
