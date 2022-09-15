. ~/dotfiles/base_profile

#
# User specific aliases and functions
. ~/dotfiles/profile

#fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export FZF_DEFAULT_OPTS='--color=bg+:#302D41,bg:#1E1E2E,spinner:#F8BD96,hl:#F28FAD --color=fg:#D9E0EE,header:#F28FAD,info:#DDB6F2,pointer:#F8BD96 --color=marker:#F8BD96,fg+:#F2CDCD,prompt:#DDB6F2,hl+:#F28FAD'

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export JAVA_TOOLS_OPTIONS="-Dlog4j2.formatMsgNoLookups=true"

# Set typewritten ZSH as a prompt
fpath+=$HOME/.zsh/typewritten
autoload -U promptinit; promptinit
prompt typewritten
export TYPEWRITTEN_COLOR_MAPPINGS="primary:#9580FF;secondary:#8AFF80;accent:#FFFF80;info_negative:#FF80BF;info_positive:#8AFF80;info_neutral_1:#FF9580;info_neutral_2:#FFFF80;info_special:#80FFEA"
export TYPEWRITTEN_SYMBOL="->"
export TYPEWRITTEN_CURSOR="block"

export HOMEBREW_GITHUB_API_TOKEN=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
fpath=($fpath "/Users/yikliu/.zfunctions")

# bun completions
[ -s "/Users/yikunliu/.bun/_bun" ] && source "/Users/yikunliu/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
fpath=($fpath "/Users/yikliu/.zfunctions")
fpath=($fpath "/Users/yikliu/.zfunctions")
