. ~/dotfiles/base_profile
#
# User specific aliases and functions
. ~/dotfiles/profile

autoload -U promptinit; promptinit
prompt default

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export JAVA_TOOLS_OPTIONS="-Dlog4j2.formatMsgNoLookups=true"
