### ADDING TO THE PATH
# First line removes the path; second line sets it. Without the first line,
# your path gets massive and fish becomes very slow.
set -e fish_user_paths
set -U fish_user_paths $HOME/.bin $HOME/.local/bin /opt/local/bin /opt/local/sbin $HOME/.cargo/bin /usr/local/opt/ruby/bin /usr/local/anaconda3/bin $HOME/Applications /Users/yikunliu/Library/Android/sdk/build-tools/30.0.2 $HOME/jdtls/bin $GOPATH/bin $GOPATH/bin $fish_user_paths

source ~/dotfiles/myalias
source ~/amazon
