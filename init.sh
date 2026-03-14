#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

OS="$(uname -s)"
ARCH="$(uname -m)"

# ── Parse args ──────────────────────────────────────────────────────
PROFILE="work"  # work | home
INSTALL_DEPS=false

usage() {
    echo "Usage: $0 [--deps] [--home]"
    echo "  --deps   Install dependencies (brew, nvim, fzf, etc.)"
    echo "  --home   Personal setup (skip work-specific config)"
    exit 0
}

for arg in "$@"; do
    case "$arg" in
        --deps) INSTALL_DEPS=true ;;
        --home) PROFILE="home" ;;
        --help|-h) usage ;;
    esac
done

echo "==> Detected: $OS ($ARCH) [profile: $PROFILE]"
echo "==> Dotfiles: $DOTFILES"

# ── Helpers ─────────────────────────────────────────────────────────
link() {
    local src="$1" dst="$2"
    mkdir -p "$(dirname "$dst")"
    if [ -L "$dst" ]; then
        rm "$dst"
    elif [ -e "$dst" ]; then
        echo "    Backing up existing $dst → ${dst}.bak"
        mv "$dst" "${dst}.bak"
    fi
    ln -s "$src" "$dst"
    echo "    $dst → $src"
}

has() { command -v "$1" &>/dev/null; }

# ── Symlink ~/dotfiles to this repo ─────────────────────────────────
if [ "$DOTFILES" != "$HOME/dotfiles" ]; then
    link "$DOTFILES" "$HOME/dotfiles"
fi

# ── Symlinks ────────────────────────────────────────────────────────
echo "==> Creating symlinks..."

link "$DOTFILES/zsh/omz_rc"    "$HOME/.zshrc"
link "$DOTFILES/vim/vimrc"     "$HOME/.vimrc"
link "$DOTFILES/tmux"          "$HOME/.tmux.conf"
link "$DOTFILES/nvim"          "$HOME/.config/nvim"
link "$DOTFILES/sf.js"         "$HOME/.sf.js"
link "$DOTFILES/ideavimrc"     "$HOME/.ideavimrc"

if [ "$OS" = "Darwin" ]; then
    link "$DOTFILES/kitty"         "$HOME/.config/kitty"
    link "$DOTFILES/aerospace.toml" "$HOME/.config/aerospace/aerospace.toml"
fi

# ── Dependencies ────────────────────────────────────────────────────
install_deps() {
    echo "==> Installing dependencies..."

    if [ "$OS" = "Darwin" ]; then
        if ! has brew; then
            echo "    Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
        brew install neovim tmux fzf ripgrep fd coreutils vivid node python3 git rsync luarocks luacheck

    elif [ "$OS" = "Linux" ]; then
        if ! has brew; then
            echo "    Installing Homebrew..."
            NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        brew install neovim tmux fzf ripgrep fd node python3 git luarocks luacheck
    fi

    # Oh My Zsh
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo "    Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
    fi

    # TPM (tmux plugin manager)
    if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
        echo "    Installing TPM..."
        git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    fi

    echo "==> Dependencies done. Run 'nvim' and :Lazy sync to install neovim plugins."

    # Apply default theme if none set
    if [ ! -f "$DOTFILES/themes/.current" ] && [ -x "$DOTFILES/set-theme.sh" ]; then
        echo "==> Applying default theme..."
        "$DOTFILES/set-theme.sh" catppuccin-mocha
    fi
}

# ── Work config (local.zsh) ─────────────────────────────────────────
setup_local() {
    local target="$DOTFILES/zsh/local.zsh"
    local template="$DOTFILES/zsh/local.zsh.example"

    if [ -f "$target" ]; then
        echo "    zsh/local.zsh already exists, skipping"
        return
    fi

    if [ ! -f "$template" ]; then
        echo "    zsh/local.zsh.example not found, skipping"
        return
    fi

    echo "==> Setting up work config (zsh/local.zsh)..."

    # Non-interactive mode (e.g. remote SSH)
    if [ ! -t 0 ]; then
        cp "$template" "$target"
        echo "    Created $target (edit placeholders manually)"
        return
    fi

    echo "    Leave blank to keep the placeholder."
    echo
    read -rp "    Personal Isengard account ID (12 digits): " personal_acct

    cp "$template" "$target"
    [ -n "$personal_acct" ] && sed -i.bak "s/<PERSONAL_ACCOUNT_ID>/$personal_acct/g" "$target"
    rm -f "${target}.bak"

    echo "    Created $target"
}

# ── Run ─────────────────────────────────────────────────────────────
if [ "$INSTALL_DEPS" = true ]; then
    install_deps
fi

if [ "$PROFILE" = "work" ] && [ ! -f "$DOTFILES/zsh/local.zsh" ]; then
    setup_local
fi

# ── Work tools (Toolbox + Brazil CLI + CR) ──────────────────────────
if [ "$PROFILE" = "work" ] && [ "$INSTALL_DEPS" = true ]; then
    if [ ! -d "$HOME/.toolbox" ]; then
        echo "==> Installing Builder Toolbox..."
        curl -fLSs -b ~/.midway/cookie \
            'https://buildertoolbox-bootstrap.s3-us-west-2.amazonaws.com/toolbox-install.sh' \
            -o /tmp/toolbox-install.sh && bash /tmp/toolbox-install.sh && rm -f /tmp/toolbox-install.sh
    fi
    if [ -d "$HOME/.toolbox/bin" ]; then
        export PATH="$HOME/.toolbox/bin:$PATH"
        echo "    Installing toolbox tools..."
        for tool in brazilcli cr ada pipeline barium bemol aim \
            builder-mcp amzn-mcp code-search create gordian-knot \
            hydra kiro-cli brazil-graph; do
            toolbox install "$tool" 2>/dev/null || true
        done
    fi
fi

echo "==> Done! Restart your shell or run: source ~/.zshrc"
