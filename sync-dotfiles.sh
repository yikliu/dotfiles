#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EXCLUDE=(--exclude='.git' --exclude='.DS_Store' --exclude='.ninja-pkg-info' --exclude='zsh/local.zsh')
HOSTS=("${DEVDSK_ARM:-yikunliu-arm.aka.corp.amazon.com}" "${DEVDSK_X86:-yikunliu-x86.aka.corp.amazon.com}")
REMOTE_DIR="dotfiles"

do_sync() {
    for host in "${HOSTS[@]}"; do
        /opt/homebrew/bin/rsync -azq "${EXCLUDE[@]}" "$DOTFILES/" "$host:~/$REMOTE_DIR/" &
    done
    wait
}

echo "==> Initial sync to ${HOSTS[*]}..."
do_sync
echo "==> Watching $DOTFILES for changes (+ periodic sync every 60s)..."

# Periodic sync in background
while true; do sleep 60; do_sync; done &
PERIODIC_PID=$!
trap "kill $PERIODIC_PID 2>/dev/null" EXIT

# Immediate sync on local changes
fswatch -o -e '\.git' -e '\.DS_Store' "$DOTFILES" | while read -r _; do
    do_sync
done
