#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

OS="$(uname -s)"
ARCH="$(uname -m)"

# ── Parse args ──────────────────────────────────────────────────────
PROFILE=""

usage() {
    echo "Usage: $0 <--work|--home>"
    echo "  --work   Work setup (includes cloud desktop, Isengard config)"
    echo "  --home   Personal setup (skip work-specific config)"
    exit 0
}

for arg in "$@"; do
    case "$arg" in
        --home) PROFILE="home" ;;
        --work) PROFILE="work" ;;
        --help|-h) usage ;;
    esac
done

if [ -z "$PROFILE" ]; then
    echo "Error: profile is required. Use --work or --home"
    usage
fi

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
link "$DOTFILES/starship.toml" "$HOME/.config/starship.toml"
link "$DOTFILES/sf.js"         "$HOME/.sf.js"
link "$DOTFILES/ideavimrc"     "$HOME/.ideavimrc"
link "$DOTFILES/q"             "$HOME/bin/q"

if [ "$OS" = "Darwin" ]; then
    link "$DOTFILES/kitty"         "$HOME/.config/kitty"
    link "$DOTFILES/aerospace.toml" "$HOME/.config/aerospace/aerospace.toml"
fi

# ── Dependencies ────────────────────────────────────────────────────
install_deps() {
    echo "==> Installing/updating dependencies..."

    local brew_pkgs="neovim tmux fzf ripgrep fd node python3 git luarocks luacheck deno vale shellcheck shfmt stylua prettier clang-format ctags yazi go golangci-lint starship uv tree-sitter ruff mosh ffmpeg"

    if [ "$OS" = "Darwin" ]; then
        if ! has brew; then
            echo "    Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
        brew_pkgs="$brew_pkgs coreutils vivid rsync swiftformat"
    elif [ "$OS" = "Linux" ]; then
        if ! has brew; then
            echo "    Installing Homebrew..."
            NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
        if [ -f /home/linuxbrew/.linuxbrew/bin/brew ]; then
            eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        elif [ -f "$HOME/.linuxbrew/bin/brew" ]; then
            eval "$("$HOME/.linuxbrew/bin/brew" shellenv)"
        fi
        brew_pkgs="$brew_pkgs ruby"
    fi

    # Install missing, upgrade existing
    brew install $brew_pkgs 2>/dev/null
    brew upgrade $brew_pkgs 2>/dev/null

    # Nvim: pip-based linters (use uv if available, fallback to pip)
    if has uv; then
        uv tool install cpplint 2>/dev/null || true
        uv tool install vim-vint 2>/dev/null || true
    else
        python3 -m pip install --user --break-system-packages --upgrade --quiet cpplint vint 2>/dev/null || \
        python3 -m pip install --user --upgrade --quiet cpplint vint 2>/dev/null || true
    fi

    # Nvim: node-based tools
    npm install -g eslint_d 2>/dev/null || true

    # Rust toolchain (provides rustfmt, rust-analyzer)
    if ! has rustup; then
        echo "    Installing Rust toolchain..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --quiet
        . "$HOME/.cargo/env"
    else
        rustup update 2>/dev/null || true
    fi
    rustup component add rust-analyzer 2>/dev/null || true

    # Vale styles
    if has vale && [ -f "$HOME/.vale.ini" ]; then
        echo "    Syncing vale styles..."
        (cd "$HOME" && vale sync 2>/dev/null) || true
    fi

    # TPM (tmux plugin manager)
    if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
        echo "    Installing TPM..."
        git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    fi

    echo "==> Syncing nvim plugins..."
    nvim --headless "+Lazy! sync" +qa 2>/dev/null || true
    echo "==> Installing treesitter parsers..."
    nvim --headless "+TSUpdateSync" +qa 2>/dev/null || true
    echo "==> Nvim setup done."

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
    read -rp "    Amazon alias (e.g. jdoe): " alias
    read -rp "    Personal Isengard account ID (12 digits): " personal_acct
    read -rp "    Ponte Alpha account ID (12 digits): " ponte_alpha
    read -rp "    Ponte Beta account ID (12 digits): " ponte_beta

    cp "$template" "$target"
    [ -n "$alias" ]         && sed -i.bak "s/<YOUR_ALIAS>/$alias/g" "$target"
    [ -n "$personal_acct" ] && sed -i.bak "s/<PERSONAL_ACCOUNT_ID>/$personal_acct/g" "$target"
    [ -n "$ponte_alpha" ]   && sed -i.bak "s/<PONTE_ALPHA_ACCOUNT_ID>/$ponte_alpha/g" "$target"
    [ -n "$ponte_beta" ]    && sed -i.bak "s/<PONTE_BETA_ACCOUNT_ID>/$ponte_beta/g" "$target"
    rm -f "${target}.bak"

    echo "    Created $target"
}

# ── Run ─────────────────────────────────────────────────────────────
install_deps

if [ ! -f "$DOTFILES/zsh/local.zsh" ]; then
    if [ "$PROFILE" = "work" ]; then
        setup_local
    else
        echo "# Home profile — add personal overrides here" > "$DOTFILES/zsh/local.zsh"
        echo "    Created zsh/local.zsh (home)"
    fi
fi

# ── AL2023 Cloud Desktop fixes ──────────────────────────────────────
# AL2023 doesn't ship krb5-workstation (needed for kinit/GitFarm/wiki/cr)
if [ "$OS" = "Linux" ] && [ -f /etc/os-release ] && \
   grep -q '^ID="amzn"' /etc/os-release && \
   grep -q '^VERSION_ID="2023"' /etc/os-release; then
    if ! [ -x /usr/bin/kinit ]; then
        echo "==> AL2023 detected: installing krb5-workstation..."
        sudo dnf install -y krb5-workstation
    fi
    if [ -f /etc/krb5.conf ] && ! grep -q '^\s*default_realm\s*=' /etc/krb5.conf; then
        echo "    Setting default_realm = ANT.AMAZON.COM in /etc/krb5.conf"
        sudo sed -i '/\[libdefaults\]/a\    default_realm = ANT.AMAZON.COM' /etc/krb5.conf
    fi
fi

# ── Work tools (Toolbox + Brazil CLI + CR) ──────────────────────────
if [ "$PROFILE" = "work" ]; then
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
            hydra kiro-cli brazil-graph personal-stacks batscli; do
            toolbox install "$tool" 2>/dev/null || true
        done
    fi
fi

echo "==> Done! Restart your shell or run: source ~/.zshrc"
