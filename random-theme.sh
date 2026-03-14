#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CURRENT=$("$DOTFILES/set-theme.sh" --current)

# Pick a random theme that isn't the current one
CHOICE=$(
    "$DOTFILES/set-theme.sh" --list \
    | grep -v "^${CURRENT}$" \
    | shuf -n1
)

exec "$DOTFILES/set-theme.sh" "$CHOICE"
