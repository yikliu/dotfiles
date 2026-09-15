#!/bin/bash

# Universal Search Script (q)
# Combines web history, notes, mail, and recent files.
# Usage: q           → search all sources
#        q ff        → Firefox history only
#        q notes     → notes only
#        q mail      → mail only
#        q recent    → recent files only
#        q local     → local files (~/Documents ~/Downloads ~/code ~/OneDrive ~/Dropbox)
#        q calendar  → (removed — too slow via AppleScript)

SOURCE="${1:-all}"

# ── Helpers ───────────────────────────────────────────────────────────
# Open result by type ($1=HISTORY|NOTE|MAIL|RECENT|LOCAL, $2=target)
dispatch() {
    case "$1" in
        HISTORY)
            osascript -e "tell application \"Firefox\" to activate" \
                      -e "tell application \"Firefox\" to open location \"$2\""
            ;;
        NOTE)
            ${EDITOR:-nvim} "$2"
            ;;
        MAIL|RECENT|LOCAL)
            open "$2"
            ;;
    esac
}

# ── All-in-one mode ───────────────────────────────────────────────────
run_all() {
    local tmpfile
    tmpfile=$(mktemp)
    trap 'rm -f "$tmpfile"' EXIT

    # ── Firefox history ───────────────────────────────────────────
    local places_db
    places_db=$(find "$HOME/Library/Application Support/Firefox/Profiles" \
        -name "places.sqlite" -print -quit 2>/dev/null)
    if [ -n "$places_db" ]; then
        local tmp_db
        tmp_db=$(mktemp)
        cp "$places_db" "$tmp_db"
        sqlite3 -separator $'\t' "$tmp_db" \
            "SELECT title, url FROM moz_places WHERE title IS NOT NULL AND url LIKE 'http%' ORDER BY last_visit_date DESC" \
            2>/dev/null | while IFS=$'\t' read -r title url; do
                printf 'HISTORY\t%s\t%s\n' "$title" "$url" >> "$tmpfile"
            done
        rm "$tmp_db"
    fi

    # ── Notes ─────────────────────────────────────────────────────
    if [ -d "${NOTES_DIR:-}" ]; then
        grep -r --exclude-dir=".git" "" "$NOTES_DIR" 2>/dev/null | while IFS= read -r line; do
            local filepath content
            filepath="${line%%:*}"
            content="${line#*:}"
            printf 'NOTE\t%s: %s\t%s\n' "$(basename "$filepath")" "$content" "$filepath" >> "$tmpfile"
        done
    fi

    # ── Mail ──────────────────────────────────────────────────────
    if [ -d "$HOME/Library/Mail" ]; then
        find "$HOME/Library/Mail" -name "*.emlx" -type f -exec ls -1t {} + 2>/dev/null | \
            sed 's/.*/MAIL\t&\t&/' >> "$tmpfile"
    fi

    # ── Local files ───────────────────────────────────────────────
    for dir in "$HOME/Documents" "$HOME/Downloads" "$HOME/code" "$HOME/OneDrive" "$HOME/Dropbox"; do
        [ -d "$dir" ] && fd . "$dir" --type f 2>/dev/null | sed 's/.*/LOCAL\t&\t&/' >> "$tmpfile" &
    done
    wait

    # ── Recent files ──────────────────────────────────────────────
    mdfind "kMDItemContentModificationDate > \$time.now(-24h)" 2>/dev/null | while IFS= read -r path; do
        [ -n "$path" ] && printf 'RECENT\t%s\t%s\n' "$(basename "$path")" "$path" >> "$tmpfile"
    done

    if [ ! -s "$tmpfile" ]; then
        echo "No results found."
        exit 0
    fi

    local selected
    selected=$(cat "$tmpfile" | fzf --delimiter=$'\t' \
        --nth=2 \
        --with-nth=2 \
        --preview 'echo {3}' \
        --preview-window=bottom:1:wrap \
        --prompt="All > " \
        --height=40% \
        --reverse)

    [ -n "$selected" ] && dispatch "$(echo "$selected" | cut -f1)" "$(echo "$selected" | cut -f3)"
}

# ── Firefox history ───────────────────────────────────────────────────
run_history() {
    local places_db
    places_db=$(find "$HOME/Library/Application Support/Firefox/Profiles" \
        -name "places.sqlite" -print -quit 2>/dev/null)

    if [ -z "$places_db" ]; then
        echo "Error: Firefox places.sqlite not found."
        exit 1
    fi

    local tmp_db
    tmp_db=$(mktemp)
    cp "$places_db" "$tmp_db"

    local selected
    selected=$(sqlite3 -separator $'\t' "$tmp_db" \
        "SELECT title, url FROM moz_places WHERE title IS NOT NULL AND url LIKE 'http%' ORDER BY last_visit_date DESC" | \
        fzf --delimiter=$'\t' \
            --nth=1,2 \
            --with-nth=1 \
            --preview 'echo {2}' \
            --preview-window=bottom:1:wrap \
            --prompt="Firefox History > " \
            --height=40% \
            --reverse)

    rm "$tmp_db"

    if [ -n "$selected" ]; then
        dispatch HISTORY "$(echo "$selected" | cut -f2)"
    fi
}

# ── Notes ─────────────────────────────────────────────────────────────
run_notes() {
    if [ ! -d "${NOTES_DIR:-}" ]; then
        echo "Notes directory not found: ${NOTES_DIR:-unset}"
        exit 1
    fi

    local selected
    selected=$(grep -r --exclude-dir=".git" "" "$NOTES_DIR" | \
        fzf --prompt="Notes > " --height=40% --reverse)

    [ -n "$selected" ] && dispatch NOTE "$(echo "$selected" | cut -d: -f1)"
}

# ── Mail ──────────────────────────────────────────────────────────────
MAIL_CACHE="$HOME/.cache/q/mail_index_v2.tsv"

rebuild_mail_cache() {
    mkdir -p "$(dirname "$MAIL_CACHE")"
    python3 - "$MAIL_CACHE" "$HOME/Library/Mail" <<'PY' &
from email import policy
from email.parser import BytesHeaderParser
import os
import sys

cache_path, mail_dir = sys.argv[1:]
tmp_path = f"{cache_path}.{os.getpid()}.tmp"


def header_value(message, name):
    value = message.get(name)
    return " ".join(str(value).split()) if value else ""


try:
    with open(tmp_path, "w", encoding="utf-8") as out:
        for root, _dirs, files in os.walk(mail_dir):
            for filename in files:
                if not filename.endswith(".emlx"):
                    continue
                path = os.path.join(root, filename)
                try:
                    with open(path, "rb") as mail_file:
                        content = mail_file.read(65536)
                    first_line, separator, remainder = content.partition(b"\n")
                    if separator and first_line.strip().isdigit():
                        content = remainder
                    message = BytesHeaderParser(policy=policy.default).parsebytes(content)
                    fields = (
                        header_value(message, "From"),
                        header_value(message, "Subject"),
                        header_value(message, "Date"),
                        path,
                    )
                    out.write("\t".join(fields) + "\n")
                except (OSError, UnicodeError, ValueError):
                    continue
    os.replace(tmp_path, cache_path)
finally:
    try:
        os.remove(tmp_path)
    except FileNotFoundError:
        pass
PY
}

run_mail() {
    if [ ! -f "$MAIL_CACHE" ]; then
        echo "Building mail index (one-time, ~2s)..."
        rebuild_mail_cache
        wait
    elif [ "$(find "$MAIL_CACHE" -mtime +0 2>/dev/null)" ]; then
        rebuild_mail_cache  # background refresh, use old cache for now
    fi

    if [ ! -s "$MAIL_CACHE" ]; then
        echo "No emails found."
        exit 1
    fi

    local selected
    selected=$(cat "$MAIL_CACHE" | fzf --delimiter=$'\t' \
        --with-nth=1,2,3 \
        --nth=1,2 \
        --preview 'echo {3}; echo ---; grep -ih "^Subject:\|^From:\|^To:\|^Date:" {4} 2>/dev/null' \
        --preview-window=bottom:4:wrap \
        --prompt="Emails > " \
        --height=60% \
        --reverse)

    [ -n "$selected" ] && dispatch MAIL "$(echo "$selected" | cut -f4)"
}

# ── Local files ───────────────────────────────────────────────────────
run_local() {
    local tmpfile
    tmpfile=$(mktemp)
    trap 'rm -f "$tmpfile"' EXIT

    for dir in "$HOME/Documents" "$HOME/Downloads" "$HOME/code" "$HOME/OneDrive" "$HOME/Dropbox"; do
        [ -d "$dir" ] && fd . "$dir" --type f 2>/dev/null >> "$tmpfile" &
    done
    wait

    if [ ! -s "$tmpfile" ]; then
        echo "No files found in searched directories."
        exit 0
    fi

    local selected
    selected=$(cat "$tmpfile" | fzf \
        --preview 'bat --style=numbers --color=always {} 2>/dev/null || head -50 {}' \
        --preview-window=right:50%:wrap \
        --prompt="Local Files > " \
        --height=60% \
        --reverse)

    [ -n "$selected" ] && dispatch LOCAL "$selected"
}

# ── Recent files ──────────────────────────────────────────────────────
run_recent() {
    local selected
    selected=$(mdfind "kMDItemContentModificationDate > \$time.now(-24h)" | \
        fzf --prompt="Recent Files > " --height=40% --reverse)
    [ -n "$selected" ] && dispatch RECENT "$selected"
}

# ── Main ──────────────────────────────────────────────────────────────
case "$SOURCE" in
    ""|"all")             run_all ;;
    "ff"|"history")       run_history ;;
    "notes"|"n")          run_notes ;;
    "mail"|"m")           run_mail ;;
    "recent"|"r")         run_recent ;;
    "local"|"l")          run_local ;;
    *)
        echo "Unknown source: $SOURCE"
        echo "Usage: q [all|ff|notes|mail|recent|local]"
        ;;
esac
