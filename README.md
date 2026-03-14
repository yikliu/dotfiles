# dotfiles

Personal dotfiles for macOS and Linux (including Amazon Cloud Desktops).

## Quick Start

```bash
# Clone and bootstrap (symlinks only)
git clone <repo> ~/dotfiles
cd ~/dotfiles
./init.sh

# Install all dependencies (brew, nvim, fzf, rg, fd, oh-my-zsh, tpm)
./init.sh --deps

# Personal machine (skip work-specific config)
./init.sh --home --deps
```

## What Gets Installed

`init.sh` creates symlinks and optionally installs dependencies via Homebrew (macOS and Linux).

| Tool | Purpose |
|------|---------|
| neovim | Editor |
| tmux | Terminal multiplexer |
| fzf | Fuzzy finder |
| ripgrep | Fast grep |
| fd | Fast find |
| luarocks | Lua package manager (for Mason/luacheck) |
| Oh My Zsh | Zsh framework |
| TPM | Tmux plugin manager |

After running `--deps`, open nvim and run `:Lazy sync` to install neovim plugins.

For tmux plugins, press `prefix + I` (capital I) inside tmux.

## Directory Structure

```
├── init.sh                 # Bootstrap script
├── set-theme.sh            # Unified theme switcher
├── random-theme.sh         # Random theme picker
├── sync-dotfiles.sh        # fswatch + rsync to cloud desktops
├── themes/                 # Theme definitions (kitty + tmux + nvim + fzf + ls_colors)
│   ├── catppuccin-mocha.sh
│   ├── tokyo-night.sh
│   ├── gruvbox-dark.sh
│   └── ... (13 themes)
├── zsh/
│   ├── omz_rc              # Oh My Zsh config (→ ~/.zshrc)
│   ├── zshrc               # Main shell config
│   ├── myalias             # Aliases
│   ├── local.zsh.example   # Work-specific template
│   └── local.zsh           # Machine-specific overrides (not tracked)
├── nvim/                   # Neovim config (→ ~/.config/nvim)
├── tmux                    # Tmux config (→ ~/.tmux.conf)
├── kitty/                  # Kitty terminal config (→ ~/.config/kitty)
├── vim/                    # Vim config (→ ~/.vimrc)
├── aerospace.toml          # AeroSpace window manager (macOS)
├── ideavimrc               # IdeaVim config (→ ~/.ideavimrc)
└── sf.js                   # Surfingkeys config
```

## Profiles

| Flag | Behavior |
|------|----------|
| (none) | Symlinks + work config (`local.zsh`) |
| `--deps` | Also install dependencies via Homebrew |
| `--home` | Skip work-specific config |
| `--home --deps` | Personal machine with full deps |

The `--home` flag skips creating `zsh/local.zsh`, which contains work-specific aliases (Brazil, cloud desktops, Isengard, etc.).

## Unified Theming

All visual components share a single colorscheme managed by `set-theme.sh`.

### Components

| Component | How it's themed |
|-----------|----------------|
| Kitty | `kitty/current-theme.conf` (included by kitty.conf) |
| Tmux | `themes/.tmux-theme.conf` (sourced by tmux.conf) |
| Neovim | `themes/.nvim-theme.lua` (loaded by init.lua, auto-reloads on file change) |
| fzf | `themes/.fzf-theme.sh` (sourced by zshrc, hot-reloaded in all tmux panes) |
| LS_COLORS | `themes/.ls-colors-theme.sh` (sourced by zshrc, hot-reloaded in all tmux panes) |

### Usage

```bash
# Interactive picker (fzf)
./set-theme.sh

# Apply a specific theme
./set-theme.sh catppuccin-mocha

# Random theme (never repeats current)
./random-theme.sh

# List available / check current
./set-theme.sh --list
./set-theme.sh --current
```

### Tmux Shortcut

| Key | Action |
|-----|--------|
| `prefix + T` | Apply a random theme |

### Available Themes

| Theme | Style |
|-------|-------|
| catppuccin-latte | Light, pastel |
| catppuccin-frappe | Medium dark, pastel |
| catppuccin-macchiato | Darker, pastel |
| catppuccin-mocha | Darkest, pastel |
| dracula | Dark, purple/pink |
| everforest-dark | Dark, green/natural |
| gruvbox-dark | Dark, warm retro |
| kanagawa | Dark, Japanese ink |
| nord | Dark, cool blue |
| onedark | Dark, Atom-style |
| rose-pine | Dark, muted elegant |
| solarized-dark | Dark, classic |
| tokyo-night | Dark, neon city |

### Adding a New Theme

Create `themes/<name>.sh` with these variables:

```bash
THEME_NAME="my-theme"
NVIM_COLORSCHEME="mytheme"       # vim colorscheme name
NVIM_BACKGROUND="dark"           # "dark" or "light"
NVIM_SETUP=""                    # optional lua setup before colorscheme
VIVID_THEME="catppuccin-mocha"   # vivid theme for LS_COLORS
FZF_COLORS="bg+:#...,bg:#..."   # fzf --color string

KITTY_THEME="
foreground  #...
background  #...
color0      #...
..."

TMUX_THEME="
set -g status-style 'bg=#...,fg=#...'
set -g window-status-style 'bg=#...,fg=#...'
set -g window-status-current-style 'bg=#...,fg=#...,bold'
set -g message-style 'bg=#...,fg=#...'
"
```

Pane active/inactive styles and borders are auto-generated from the theme's background color. Inactive panes are visibly dimmed; nvim uses a transparent background so tmux dimming shows through.

## Tmux

### Key Bindings

| Key | Action |
|-----|--------|
| `C-a` | Prefix (remapped from `C-b`) |
| `prefix + \|` | Split horizontal |
| `prefix + -` | Split vertical |
| `prefix + H/J/K/L` | Resize panes |
| `prefix + r` | Reload tmux config |
| `prefix + T` | Random theme |
| `Shift + ←/→` | Switch windows |
| `Alt + ←/→/↑/↓` | Switch panes |
| `F12` | Toggle nested tmux pass-through |

### Nested Tmux (SSH)

When SSH'd into a remote machine running tmux inside local tmux:

1. Press `F12` — local tmux disables its keybindings, status bar turns grey and shows `REMOTE`
2. All shortcuts now go to the remote tmux
3. Press `F12` again — back to local tmux, theme colors restore

### Plugins (via TPM)

- tmux-sensible
- tmux-yank
- tmux-resurrect
- tmux-continuum
- tmux-open

Install with `prefix + I` after first setup.

## Cloud Desktop Sync

`sync-dotfiles.sh` watches for local changes and rsyncs to cloud desktops:

```bash
./sync-dotfiles.sh
```

Requires `DEVDSK_ARM` and `DEVDSK_X86` env vars (set in `local.zsh`), falls back to hardcoded hostnames.

After syncing, run on the remote:

```bash
bash ~/dotfiles/init.sh --deps
```

## Work Config (local.zsh)

`zsh/local.zsh` is machine-specific and not tracked in git. It's created from `local.zsh.example` on first run of `init.sh`.

Contains:
- Toolbox / Linuxbrew PATH
- Cloud desktop aliases (`arm`, `x86`, `tm_arm`, `tm_x86`)
- Brazil build aliases (`bb`, `bbr`, `bbc`, etc.)
- Midway aliases (`mac_yubi`, `dsk_yubi`)
- Isengard credentials
- Android/ADB aliases
- Kiro CLI shell integration
