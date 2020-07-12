#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Detect platform
OS="$(uname -s)"
ARCH="$(uname -m)"

echo "==> Detected: $OS ($ARCH)"
echo "==> Dotfiles: $DOTFILES"

# ── Helper ──────────────────────────────────────────────────────────
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

# Mac-only symlinks
if [ "$OS" = "Darwin" ]; then
    link "$DOTFILES/kitty"         "$HOME/.config/kitty"
    link "$DOTFILES/aerospace.toml" "$HOME/.config/aerospace/aerospace.toml"
fi

# ── Dependencies ────────────────────────────────────────────────────
install_deps() {
    echo "==> Installing dependencies..."

    if [ "$OS" = "Darwin" ]; then
        if ! command -v brew &>/dev/null; then
            echo "    Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
        brew install neovim tmux fzf ripgrep fd coreutils vivid node python3 git
    elif [ "$OS" = "Linux" ]; then
        if command -v apt-get &>/dev/null; then
            sudo apt-get update
            sudo apt-get install -y neovim tmux fzf ripgrep fd-find nodejs python3 python3-pip git curl
        elif command -v yum &>/dev/null; then
            sudo yum install -y neovim tmux fzf ripgrep fd-find nodejs python3 git curl
        fi
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
    echo "    Leave blank to keep the placeholder."
    echo

    read -rp "    Personal Isengard account ID (12 digits): " personal_acct

    cp "$template" "$target"

    [ -n "$personal_acct" ] && sed -i.bak "s/<PERSONAL_ACCOUNT_ID>/$personal_acct/g" "$target"
    rm -f "${target}.bak"

    echo "    Created $target"
}

# ── Run ─────────────────────────────────────────────────────────────
if [[ "${1:-}" == "--deps" ]]; then
    install_deps
fi

if [ ! -f "$DOTFILES/zsh/local.zsh" ]; then
    setup_local
fi

echo "==> Done! Restart your shell or run: source ~/.zshrc"
