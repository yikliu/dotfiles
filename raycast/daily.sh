#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Note
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 📝
# @raycast.packageName Notes

NOTES_DIR="$HOME/Dropbox/Notes"
mkdir -p "$NOTES_DIR"

FILE="$NOTES_DIR/$(date +%Y-%m-%d).md"

if [ ! -f "$FILE" ]; then
    echo "# $(date +%Y-%m-%d)" > "$FILE"
fi

/opt/homebrew/bin/neovide "$FILE"
