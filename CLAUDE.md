# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Bootstrap

```bash
./init.sh --work   # Work setup: symlinks + deps + work config (local.zsh)
./init.sh --home   # Personal setup: symlinks + deps, no work-specific config
```

`init.sh` always installs dependencies (Homebrew packages, Rust toolchain, nvim plugins via `:Lazy sync`, TPM). The `--work` flag additionally installs Builder Toolbox and Amazon CLI tools (`brazilcli`, `cr`, `ada`, etc.).

After running, open nvim and run `:Lazy sync` if plugins weren't auto-installed. For tmux plugins: `prefix + I`.

## Theming

All visual components (kitty, tmux, nvim, fzf, LS_COLORS, starship) share a single colorscheme:

```bash
./set-theme.sh                   # interactive fzf picker
./set-theme.sh catppuccin-mocha  # apply by name
./set-theme.sh --list            # list themes
./set-theme.sh --current         # show active theme
./random-theme.sh                # pick random (never repeats current)
```

`set-theme.sh` hot-reloads running kitty, tmux, and nvim instances without restart. The active theme name is stored in `themes/.current`.

### Theme files

Each `themes/<name>.sh` must define: `THEME_NAME`, `NVIM_COLORSCHEME`, `NVIM_BACKGROUND`, `NVIM_SETUP`, `VIVID_THEME`, `FZF_COLORS`, `KITTY_THEME`, `TMUX_THEME`. Pane active/inactive border styles are auto-generated from `KITTY_THEME`'s background color — no need to set them manually.

Generated files (written by `set-theme.sh`, not hand-edited):
- `themes/.nvim-theme.lua` — loaded by nvim at startup + watched for live reload
- `themes/.tmux-theme.conf` — sourced by tmux
- `kitty/current-theme.conf` — included by `kitty/kitty.conf`
- `themes/.fzf-theme.sh` — sourced by `zsh/zshrc`
- `themes/.ls-colors-theme.sh` — sourced by `zsh/zshrc`

## Neovim config structure

`nvim/init.lua` sources these files in order from `nvim/core/`:
1. `neovide.lua` — Neovide GUI settings
2. `globals.lua` — global vim settings
3. `options.vim` — vim options
4. `mappings.lua` — keymaps
5. `plugins.vim` — plugin list and config (via Lazy)
6. `colorschemes.lua` — fallback colorscheme if no theme is active

After loading, `init.lua` applies `themes/.nvim-theme.lua` (via `VeryLazy` autocmd) and watches it for changes using `uv.new_fs_event`.

## Shell config loading order

`~/.zshrc` → `zsh/omz_rc` (Oh My Zsh wrapper) → `zsh/zshrc` (main config) → `zsh/myalias` → `zsh/local.zsh` (machine-specific, not tracked in git)

`zsh/local.zsh` is created from `zsh/local.zsh.example` on first `init.sh --work`. It holds work aliases, cloud desktop hostnames, Isengard account IDs, etc. Never commit it.

## Secrets & sensitive data

**All API keys, tokens, and credentials belong in `zsh/local.zsh` (gitignored), never in tracked files.** `zsh/omz_rc` is tracked — do not set `ANTHROPIC_AUTH_TOKEN`, `OPENAI_API_KEY`, or similar there. Before committing, check that tracked files contain no `sk-` keys, `export ..._TOKEN=`, or `export ..._KEY=` assignments.

Other PII to keep out of tracked files and commit messages:
- Corporate emails (`@amazon.com`) — use local-only addresses for commits
- Internal hostnames (`.aka.corp.amazon.com`, `dev-dsk-*.amazon.com`)
- Home directory paths (`/Users/yikliu`) — prefer `~` or `$HOME`

## Cloud desktop sync

```bash
./sync-dotfiles.sh   # watches local changes, rsyncs to DEVDSK_ARM and DEVDSK_X86
```

Requires `DEVDSK_ARM` and `DEVDSK_X86` env vars (set in `local.zsh`); falls back to hardcoded hostnames. After sync, run `bash ~/dotfiles/init.sh --work` on the remote.
