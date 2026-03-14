# Theme definition: tokyo-night
THEME_NAME="tokyo-night"
NVIM_COLORSCHEME="tokyonight"
NVIM_BACKGROUND="dark"
NVIM_SETUP='require("tokyonight").setup({ style = "night" })'
VIVID_THEME="catppuccin-mocha"
FZF_COLORS="bg+:#283457,bg:#16161e,spinner:#bb9af7,hl:#7aa2f7,fg:#c0caf5,header:#7aa2f7,info:#7dcfff,pointer:#bb9af7,marker:#9ece6a,fg+:#c0caf5,prompt:#7dcfff,hl+:#7aa2f7,selected-bg:#283457"

KITTY_THEME="
foreground              #c0caf5
background              #1a1b26
selection_foreground     #c0caf5
selection_background     #283457
cursor                  #c0caf5
cursor_text_color       #1a1b26
url_color               #73daca
active_border_color     #7aa2f7
inactive_border_color   #3b4261
bell_border_color       #e0af68
active_tab_foreground   #15161e
active_tab_background   #7aa2f7
inactive_tab_foreground #545c7e
inactive_tab_background #1a1b26
tab_bar_background      #15161e
color0  #15161e
color8  #414868
color1  #f7768e
color9  #f7768e
color2  #9ece6a
color10 #9ece6a
color3  #e0af68
color11 #e0af68
color4  #7aa2f7
color12 #7aa2f7
color5  #bb9af7
color13 #bb9af7
color6  #7dcfff
color14 #7dcfff
color7  #a9b1d6
color15 #c0caf5
"

TMUX_THEME="
set -g status-style 'bg=#16161e,fg=#c0caf5'
set -g window-status-style 'bg=#16161e,fg=#545c7e'
set -g window-status-current-style 'bg=#16161e,fg=#7aa2f7,bold'
set -g message-style 'bg=#283457,fg=#c0caf5'
"
