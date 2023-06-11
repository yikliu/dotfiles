. ~/dotfiles/base_profile

#
# User specific aliases and functions
. ~/dotfiles/profile

#fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export FZF_DEFAULT_OPTS='--color=bg+:#302D41,bg:#1E1E2E,spinner:#F8BD96,hl:#F28FAD --color=fg:#D9E0EE,header:#F28FAD,info:#DDB6F2,pointer:#F8BD96 --color=marker:#F8BD96,fg+:#F2CDCD,prompt:#DDB6F2,hl+:#F28FAD'

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export PATH="$HOME/jdtls/bin:$PATH"
export JAVA_TOOLS_OPTIONS="-Dlog4j2.formatMsgNoLookups=true"

export HOMEBREW_GITHUB_API_TOKEN=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
fpath=($fpath "/Users/yikliu/.zfunctions")

# bun completions
[ -s "/Users/yikunliu/.bun/_bun" ] && source "/Users/yikunliu/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export GOPATH=$HOME/go
export PATH="$GOPATH/bin:$PATH"

source ~/dotfiles/myalias
source ~/amazon

# bun completions
[ -s "/Users/yikliu/.bun/_bun" ] && source "/Users/yikliu/.bun/_bun"

export PATH=$PATH:/Users/yikliu/.spicetify
