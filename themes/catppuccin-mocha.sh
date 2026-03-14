# Theme definition: catppuccin-mocha
# Each theme defines colors for all components

THEME_NAME="catppuccin-mocha"
KIRO_THEME="catppuccin"
NVIM_COLORSCHEME="catppuccin"
NVIM_BACKGROUND="dark"
NVIM_SETUP='vim.g.catppuccin_flavour = "mocha"; require("catppuccin").setup()'
VIVID_THEME="catppuccin-mocha"
FZF_COLORS="bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8,fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc,marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8,selected-bg:#45475a"

# Kitty colors
KITTY_THEME="
foreground              #CDD6F4
background              #1E1E2E
selection_foreground     #1E1E2E
selection_background     #F5E0DC
cursor                  #F5E0DC
cursor_text_color       #1E1E2E
url_color               #F5E0DC
active_border_color     #B4BEFE
inactive_border_color   #6C7086
bell_border_color       #F9E2AF
active_tab_foreground   #11111B
active_tab_background   #CBA6F7
inactive_tab_foreground #CDD6F4
inactive_tab_background #181825
tab_bar_background      #11111B
color0  #45475A
color8  #585B70
color1  #F38BA8
color9  #F38BA8
color2  #A6E3A1
color10 #A6E3A1
color3  #F9E2AF
color11 #F9E2AF
color4  #89B4FA
color12 #89B4FA
color5  #F5C2E7
color13 #F5C2E7
color6  #94E2D5
color14 #94E2D5
color7  #BAC2DE
color15 #A6ADC8
"

# Tmux colors
TMUX_THEME="
set -g status-style 'bg=#1e1e2e,fg=#cdd6f4'
set -g window-status-style 'bg=#1e1e2e,fg=#6c7086'
set -g window-status-current-style 'bg=#1e1e2e,fg=#cba6f7,bold'
set -g message-style 'bg=#313244,fg=#cdd6f4'
"
