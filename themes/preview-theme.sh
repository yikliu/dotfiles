#!/usr/bin/env bash
# Render a color preview of a theme for use as an fzf --preview command.
# Usage: preview-theme.sh <theme-name>
#
# Parses the theme's KITTY_THEME palette and prints truecolor swatches so the
# actual colors (not just hex codes) show in the fzf preview pane.

THEMES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
theme="${1:-}"
theme_file="$THEMES_DIR/${theme}.sh"

[ -f "$theme_file" ] || { echo "No such theme: $theme"; exit 0; }

# shellcheck disable=SC1090
source "$theme_file"

# #RRGGBB -> "R G B"
hex_rgb() {
    local h="${1#\#}"
    printf '%d %d %d' "0x${h:0:2}" "0x${h:2:2}" "0x${h:4:2}"
}

# Solid block of the given hex color, $2 = width in chars (default 2)
swatch() {
    local hex="$1" width="${2:-2}" r g b pad
    [ -n "$hex" ] || { printf '%*s' "$width" ''; return; }
    read -r r g b < <(hex_rgb "$hex")
    printf -v pad '%*s' "$width" ''
    printf '\e[48;2;%d;%d;%dm%s\e[0m' "$r" "$g" "$b" "$pad"
}

# Look up a value from the KITTY_THEME block by key (key followed by whitespace)
getcolor() {
    echo "$KITTY_THEME" | grep -m1 "^$1[[:space:]]" | awk '{print $2}'
}

fg="$(getcolor foreground)"
bg="$(getcolor background)"
cur="$(getcolor cursor)"

# Header
printf '  %s' "${THEME_NAME:-$theme}"
[ -n "${NVIM_BACKGROUND:-}" ] && printf '  \e[2m(%s)\e[0m' "$NVIM_BACKGROUND"
printf '\n'
printf '  \e[2mghostty:\e[0m %s  \e[2mnvim:\e[0m %s\n' "${GHOSTTY_THEME:-–}" "${NVIM_COLORSCHEME:-–}"
[ -n "${VIVID_THEME:-}" ] && printf '  \e[2mvivid:\e[0m %s\n' "$VIVID_THEME"
printf '\n'

# fg / bg / cursor
printf '  bg %s %s   fg %s %s\n' "$(swatch "$bg" 4)" "$bg" "$(swatch "$fg" 4)" "$fg"
printf '  cursor %s %s\n\n' "$(swatch "$cur" 4)" "$cur"

# 16-color ANSI palette, two rows of 8
printf '  \e[2mansi palette\e[0m\n'
for row in 0 8; do
    printf '  '
    for i in $(seq "$row" $((row + 7))); do
        swatch "$(getcolor "color${i}")" 4
    done
    printf '\n'
done
printf '\n'

# Sample text rendered in the theme's fg-on-bg, with a few accents
if [ -n "$fg" ] && [ -n "$bg" ]; then
    read -r fr fg_g fb < <(hex_rgb "$fg")
    read -r br bg_g bb < <(hex_rgb "$bg")
    setbg() { printf '\e[48;2;%d;%d;%dm' "$br" "$bg_g" "$bb"; }
    txt() { # $1 hex, $2 text
        local r g b; read -r r g b < <(hex_rgb "${1:-$fg}")
        printf '\e[38;2;%d;%d;%dm%s' "$r" "$g" "$b" "$2"
    }
    setbg; txt "$fg"       '  the quick brown fox  '; printf '\e[0m\n'
    setbg; txt "$(getcolor color2)"  '  ~/dev'; txt "$(getcolor color4)" ' git:('; \
        txt "$(getcolor color1)" 'main'; txt "$(getcolor color4)" ')'; \
        txt "$fg" ' $ '; printf '   \e[0m\n'
fi
