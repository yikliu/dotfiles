set-option -g default-shell $SHELL

# remap prefix from 'C-b' to 'C-a'
unbind C-b
set-option -g prefix C-a
bind-key C-a send-prefix

# 0 is too far from ` ;)
set -g base-index 1

# Automatically set window title
set-window-option -g automatic-rename on
set-option -g set-titles on
set -g default-terminal "tmux-256color"
set -g status-keys vi
set -g history-limit 10000

set -g window-status-style bg=colour70,fg=colour160
set -g window-status-current-style bg=colour75,fg=colour16,bold

setw -g mode-keys vi
setw -g monitor-activity on
# divide screen to left and right
bind-key v split-window -h
# divide screen to up and down
bind-key s split-window -v

# Shift arrow to switch windows
bind -n S-Left  previous-window
bind -n S-Right next-window

# resize pane
bind-key J resize-pane -D 5
bind-key K resize-pane -U 5
bind-key H resize-pane -L 5
bind-key L resize-pane -R 5

# Use Alt-arrow keys without prefix key to switch panes
bind -n M-Left select-pane -L
bind -n M-Right select-pane -R
bind -n M-Up select-pane -U
bind -n M-Down select-pane -D

# No delay for escape key press
set -sg escape-time 0

# Reload tmux config
bind r source-file ~/.tmux.conf

set -g @plugin 'tmux-plugins/tmux-resurrect'
#tpm
# List of plugins
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'

# Other examples:
# set -g @plugin 'github_username/plugin_name'
# set -g @plugin 'github_username/plugin_name#branch'
# set -g @plugin 'git@github.com:user/plugin'
# set -g @plugin 'git@bitbucket.com:user/plugin'

# Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
run '~/.tmux/plugins/tpm/tpm'
