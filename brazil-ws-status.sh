#!/usr/bin/env bash
set -euo pipefail

SHOW_DIFF=false
PULL_REBASE=false
for arg in "$@"; do
  case "$arg" in
    --diff) SHOW_DIFF=true ;;
    --pull) PULL_REBASE=true ;;
  esac
done

WS_ROOT=$(brazil workspace show 2>/dev/null | awk '/Root:/{print $2}')
if [[ -z "$WS_ROOT" ]]; then
  echo "Not in a Brazil workspace." >&2; exit 1
fi

SRC="$WS_ROOT/src"
PKGS=()
for pkg in "$SRC"/*/; do
  [[ -d "$pkg/.git" ]] && PKGS+=("$pkg")
done

# Parallel fetch
for pkg in "${PKGS[@]}"; do
  git -C "$pkg" fetch --quiet 2>/dev/null &
done
wait

for pkg in "${PKGS[@]}"; do
  name=$(basename "$pkg")
  branch=$(git -C "$pkg" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "detached")
  tracking=$(git -C "$pkg" rev-parse --abbrev-ref '@{u}' 2>/dev/null || echo "")

  # Working tree status
  flags=()
  if [[ -d "$pkg/.git/rebase-merge" || -d "$pkg/.git/rebase-apply" ]]; then
    flags+=("REBASE")
  elif [[ -f "$pkg/.git/MERGE_HEAD" ]]; then
    flags+=("MERGE")
  fi
  [[ -n $(git -C "$pkg" diff --name-only 2>/dev/null) ]] && flags+=("unstaged")
  [[ -n $(git -C "$pkg" diff --cached --name-only 2>/dev/null) ]] && flags+=("uncommitted")
  [[ -n $(git -C "$pkg" ls-files --others --exclude-standard 2>/dev/null) ]] && flags+=("untracked")

  # Remote status
  if [[ -z "$tracking" ]]; then
    remote_status="no upstream"
  else
    ahead=$(git -C "$pkg" rev-list --count "$tracking..HEAD" 2>/dev/null || echo 0)
    behind=$(git -C "$pkg" rev-list --count "HEAD..$tracking" 2>/dev/null || echo 0)
    if [[ "$ahead" -eq 0 && "$behind" -eq 0 ]]; then
      remote_status="up to date"
    else
      parts=()
      [[ "$ahead" -gt 0 ]] && parts+=("${ahead} ahead")
      [[ "$behind" -gt 0 ]] && parts+=("${behind} behind")
      remote_status=$(IFS=', '; echo "${parts[*]}")
    fi
  fi

  # Pull rebase if requested and behind
  if $PULL_REBASE && [[ "${behind:-0}" -gt 0 ]]; then
    if [[ ${#flags[@]} -eq 0 ]]; then
      if git -C "$pkg" pull --rebase --quiet 2>/dev/null; then
        behind=0; ahead=$(git -C "$pkg" rev-list --count "$tracking..HEAD" 2>/dev/null || echo 0)
        remote_status="pulled (rebase)"; [[ "$ahead" -gt 0 ]] && remote_status="pulled (rebase), ${ahead} ahead"
      else
        remote_status="pull FAILED — resolve manually"
      fi
    else
      remote_status="$remote_status — skipped pull (dirty tree)"
    fi
  fi

  # Local commit
  local_commit=$(git -C "$pkg" log -1 --format="%h %s" 2>/dev/null || echo "n/a")

  # Remote commit
  if [[ -n "$tracking" ]]; then
    remote_commit=$(git -C "$pkg" log -1 --format="%h %s" "$tracking" 2>/dev/null || echo "n/a")
  else
    remote_commit="n/a"
  fi

  # Display
  RST='\033[0m'
  dirty=""
  [[ ${#flags[@]} -gt 0 ]] && dirty=" [$(IFS=', '; echo "${flags[*]}")]"

  if [[ "${behind:-0}" -gt 0 ]]; then
    CLR='\033[1;31m' # red for behind
  elif [[ ${#flags[@]} -gt 0 ]]; then
    CLR='\033[1;33m' # yellow for dirty
  else
    CLR='\033[0;32m' # green for clean
  fi

  echo -e "${CLR}📦 $name ($branch)${dirty} — $remote_status${RST}"
  echo "   local:  $local_commit"
  [[ "$local_commit" != "$remote_commit" ]] && echo "   remote: $remote_commit"

  if $SHOW_DIFF; then
    diff_output=$(git -C "$pkg" diff --stat 2>/dev/null)
    cached_output=$(git -C "$pkg" diff --cached --stat 2>/dev/null)
    [[ -n "$diff_output" ]] && echo -e "   \033[0;33m--- unstaged ---${RST}" && echo "$diff_output" | sed 's/^/   /'
    [[ -n "$cached_output" ]] && echo -e "   \033[0;36m--- staged ---${RST}" && echo "$cached_output" | sed 's/^/   /'
  fi

  echo ""
done
