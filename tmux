set-option -g default-shell $SHELL

# remap prefix from 'C-b' to backtick
unbind C-b
set-option -g prefix `
bind-key ` send-prefix

# 0 is too far from ` ;)
set -g base-index 1

set-option -g status-interval 1
set-option -g automatic-rename on
set-option -g automatic-rename-format '#{b:pane_current_path}'

set -g default-terminal "tmux-256color"
set -ag terminal-features ",xterm-kitty:RGB"
set -ag terminal-overrides ",xterm-256color:RGB"
set -g allow-passthrough on
set -g status-keys vi
set -g history-limit 10000

set -g status-justify centre           # center window list for clarity

setw -g mode-keys vi

setw -g monitor-activity off

# divide screen to left and right
bind-key | split-window -h
# divide screen to up and down
bind-key - split-window -v

# resize pane
bind-key J resize-pane -D 15
bind-key K resize-pane -U 15
bind-key H resize-pane -L 15
bind-key L resize-pane -R 15

# Shift arrow to switch windows
bind -n S-Left  previous-window
bind -n S-Right next-window

# shift + alt to move sessions
bind -n M-S-Left switch-client -n
bind -n M-S-Right switch-client -p

# Quick pane zoom
bind z resize-pane -Z

# Use Alt-arrow keys without prefix key to switch panes
bind -n M-Left select-pane -L
bind -n M-Right select-pane -R
bind -n M-Up select-pane -U
bind -n M-Down select-pane -D

# greater and lesser than keys to move windows
bind-key -r < swap-window -t -
bind-key -r > swap-window -t +

bind -T copy-mode-vi v send -X begin-selection
if-shell "uname | grep -q Darwin" \
    'bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "pbcopy"; bind P paste-buffer; bind -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "pbcopy"' \
    'set -g @yank_action "copy-pipe-and-cancel"; bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel; bind P paste-buffer; bind -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel'

set -g @open 'x'
set -g mouse on

# OSC 52 clipboard (works over SSH — sends yanked text to local terminal)
set -g set-clipboard on

# No delay for escape key press
set -sg escape-time 0

# Pane border indicator
set -g pane-border-indicators both
set -g pane-border-status top
set -g pane-border-format "#{?pane_active, 🔥🔥🔥🔥🔥 LOOK HERE!!!! 🔥🔥🔥🔥🔥 ,  #P: #T }"
set -g pane-border-lines heavy

# reload tmux config
bind r source-file ~/.tmux.conf \; display-message "Config reloaded"

# random theme (prefix + T)
bind T run-shell "~/dotfiles/random-theme.sh"

# ── Nested tmux (F12 to toggle) ────────────────────────────────────
# F12 disables local keys so all input passes to inner (remote) tmux.
# Status bar dims to show you're in "pass-through" mode.
# Press F12 again to return to local tmux.
bind -T root F12 \
    set prefix None \;\
    set key-table off \;\
    set status-style "bg=#444444,fg=#888888" \;\
    set window-status-current-style "bg=#444444,fg=#aaaaaa" \;\
    set status-left "#[bg=#666666,fg=#ffffff] REMOTE #[default] " \;\
    refresh-client -S

bind -T off F12 \
    set -u prefix \;\
    set -u key-table \;\
    set -u status-style \;\
    set -u window-status-current-style \;\
    set -u status-left \;\
    if-shell "test -f ~/dotfiles/themes/.tmux-theme.conf" "source-file ~/dotfiles/themes/.tmux-theme.conf" \;\
    refresh-client -S

# theme (managed by set-theme.sh)
if-shell "test -f ~/dotfiles/themes/.tmux-theme.conf" "source-file ~/dotfiles/themes/.tmux-theme.conf"

# tpm plugins, need prefix + I to install
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'tmux-plugins/tmux-yank'
set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @plugin 'tmux-plugins/tmux-continuum'
set -g @plugin 'tmux-plugins/tmux-open'
set -g @plugin 'wfxr/tmux-fzf-url'
set -g @fzf-url-open '~/bin/open-url'

# Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
run '~/.tmux/plugins/tpm/tpm'
