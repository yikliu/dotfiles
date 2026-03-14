set-option -g default-shell $SHELL

# remap prefix from 'C-b' to 'C-a'
unbind C-b
set-option -g prefix C-a
bind-key C-a send-prefix

# 0 is too far from ` ;)
set -g base-index 1

set-option -g status-interval 1
set-option -g automatic-rename on
set-option -g automatic-rename-format '#{b:pane_current_path}'

set -g default-terminal "tmux-256color"
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
    'bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "xclip -selection clipboard"; bind P paste-buffer; bind -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "xclip -selection clipboard"'

set -g @open 'x'
set -g mouse on

# No delay for escape key press
set -sg escape-time 0

# reload tmux config
bind r source-file ~/.tmux.conf

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

# Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
run '~/.tmux/plugins/tpm/tpm'
