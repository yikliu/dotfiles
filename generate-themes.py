#!/usr/bin/env python3
"""
Generate dotfiles theme .sh files from ghostty built-in themes.
Existing hand-crafted themes are never overwritten.
"""
import os
import re
import sys

GHOSTTY_THEMES = "/Applications/Ghostty.app/Contents/Resources/ghostty/themes"
DOTFILES_THEMES = os.path.join(os.path.dirname(os.path.abspath(__file__)), "themes")

# ── Vivid theme fallback table ──────────────────────────────────────────────
# Maps ghostty theme name fragments (lowercase) to vivid theme names.
# First match wins; final entry is the default.
VIVID_RULES = [
    ("catppuccin latte",    "catppuccin-latte"),
    ("catppuccin frappe",   "catppuccin-frappe"),
    ("catppuccin macchiato","catppuccin-macchiato"),
    ("catppuccin mocha",    "catppuccin-mocha"),
    ("catppuccin",          "catppuccin-mocha"),
    ("gruvbox light",       "gruvbox-light"),
    ("gruvbox dark hard",   "gruvbox-dark-hard"),
    ("gruvbox dark",        "gruvbox-dark"),
    ("gruvbox",             "gruvbox-dark"),
    ("rose pine dawn",      "rose-pine-dawn"),
    ("rose pine moon",      "rose-pine-moon"),
    ("rose pine",           "rose-pine"),
    ("tokyonight day",      "tokyonight-day"),
    ("tokyonight moon",     "tokyonight-moon"),
    ("tokyonight storm",    "tokyonight-storm"),
    ("tokyonight",          "tokyonight-night"),
    ("tokyo night day",     "tokyonight-day"),
    ("tokyo night",         "tokyonight-night"),
    ("nord",                "nord"),
    ("dracula",             "dracula"),
    ("solarized light",     "solarized-light"),
    ("solarized",           "solarized-dark"),
    ("ayu light",           "ayu"),
    ("ayu",                 "ayu"),
    ("molokai",             "molokai"),
    ("monokai",             "molokai"),
    ("zenburn",             "zenburn"),
    ("snazzy",              "snazzy"),
    ("iceberg",             "iceberg-dark"),
    ("one light",           "one-light"),
    ("one",                 "one-dark"),
    ("light",               "one-light"),   # generic light fallback
    ("",                    "one-dark"),    # default dark fallback
]

# ── NVIM colorscheme table ───────────────────────────────────────────────────
# Maps ghostty theme name fragments (lowercase) to (colorscheme, setup_lua).
NVIM_RULES = [
    ("catppuccin latte",     "catppuccin",  'vim.g.catppuccin_flavour = "latte"; require("catppuccin").setup()'),
    ("catppuccin frappe",    "catppuccin",  'vim.g.catppuccin_flavour = "frappe"; require("catppuccin").setup()'),
    ("catppuccin macchiato", "catppuccin",  'vim.g.catppuccin_flavour = "macchiato"; require("catppuccin").setup()'),
    ("catppuccin mocha",     "catppuccin",  'vim.g.catppuccin_flavour = "mocha"; require("catppuccin").setup()'),
    ("catppuccin",           "catppuccin",  'vim.g.catppuccin_flavour = "mocha"; require("catppuccin").setup()'),
    ("gruvbox",              "gruvbox",     ""),
    ("rose pine dawn",       "rose-pine",   'require("rose-pine").setup({ variant = "dawn" })'),
    ("rose pine moon",       "rose-pine",   'require("rose-pine").setup({ variant = "moon" })'),
    ("rose pine",            "rose-pine",   'require("rose-pine").setup({ variant = "main" })'),
    ("tokyonight day",       "tokyonight",  'require("tokyonight").setup({ style = "day" })'),
    ("tokyonight moon",      "tokyonight",  'require("tokyonight").setup({ style = "moon" })'),
    ("tokyonight storm",     "tokyonight",  'require("tokyonight").setup({ style = "storm" })'),
    ("tokyonight",           "tokyonight",  'require("tokyonight").setup({ style = "night" })'),
    ("tokyo night day",      "tokyonight",  'require("tokyonight").setup({ style = "day" })'),
    ("tokyo night",          "tokyonight",  'require("tokyonight").setup({ style = "night" })'),
    ("nord",                 "nord",        ""),
    ("nordfox",              "nordfox",     ""),
    ("dracula",              "dracula",     ""),
    ("everforest",           "everforest",  "vim.g.everforest_enable_italic = 1; vim.g.everforest_better_performance = 1"),
    ("solarized",            "solarized",   ""),
    ("monokai pro",          "monokai_pro", ""),
    ("monokai",              "monokai_pro", ""),
    ("sonokai",              "sonokai",     "vim.g.sonokai_enable_italic = 1; vim.g.sonokai_better_performance = 1"),
    ("one half dark",        "onehalfdark", ""),
    ("one half light",       "onehalflight",""),
    ("one dark",             "onedark",     ""),
    ("atom one dark",        "onedark",     ""),
    ("material ocean",       "material",    'vim.g.material_style = "oceanic"'),
    ("material darker",      "material",    'vim.g.material_style = "darker"'),
    ("material",             "material",    'vim.g.material_style = "oceanic"'),
    ("kanagawa dragon",      "kanagawa",    'require("kanagawa").setup({ theme = "dragon" })'),
    ("kanagawa lotus",       "kanagawa",    'require("kanagawa").setup({ theme = "lotus" })'),
    ("kanagawa",             "kanagawa",    ""),
    ("doom one",             "doom-one",    ""),
    ("paper",                "PaperColor",  'vim.cmd("set t_Co=256")'),
    ("ayu",                  "ayu",         ""),
    ("edge",                 "edge",        "vim.g.edge_enable_italic = 1; vim.g.edge_better_performance = 1"),
    ("",                     "default",     ""),
]


def parse_ghostty_theme(path):
    colors = {}
    palette = {}
    with open(path) as f:
        for line in f:
            line = line.strip()
            m = re.match(r"palette\s*=\s*(\d+)=#([0-9a-fA-F]{6})", line)
            if m:
                palette[int(m.group(1))] = "#" + m.group(2).upper()
                continue
            m = re.match(r"(\S+)\s*=\s*#([0-9a-fA-F]{6})", line)
            if m:
                colors[m.group(1)] = "#" + m.group(2).upper()
    return colors, palette


def luminance(hex_color):
    h = hex_color.lstrip("#")
    r, g, b = int(h[0:2], 16), int(h[2:4], 16), int(h[4:6], 16)
    # Perceived luminance
    return 0.2126 * r + 0.7152 * g + 0.0722 * b


def is_light(bg):
    return luminance(bg) > 128


def adjust_color(hex_color, offset):
    h = hex_color.lstrip("#")
    r = max(0, min(255, int(h[0:2], 16) + offset))
    g = max(0, min(255, int(h[2:4], 16) + offset))
    b = max(0, min(255, int(h[4:6], 16) + offset))
    return f"#{r:02X}{g:02X}{b:02X}"


def match_rule(name_lower, rules):
    for fragment, *rest in rules:
        if fragment in name_lower:
            return rest
    return rules[-1][1:]


def make_slug(ghostty_name):
    return re.sub(r"[^a-z0-9]+", "-", ghostty_name.lower()).strip("-")


def fzf_colors(colors, palette, light):
    bg   = colors.get("background", "#1E1E2E")
    fg   = colors.get("foreground", "#CDD6F4")
    sel  = colors.get("selection-background", palette.get(8, adjust_color(bg, 30 if not light else -30)))
    hl   = palette.get(4, "#89B4FA")   # blue
    hl2  = palette.get(1, "#F38BA8")   # red/pink
    acc1 = palette.get(5, "#CBA6F7")   # purple/magenta
    acc2 = palette.get(2, "#A6E3A1")   # green
    acc3 = palette.get(3, "#F9E2AF")   # yellow
    ptr  = palette.get(13, acc1)
    mrk  = palette.get(12, hl)
    sel_bg = sel

    return (
        f"bg+:{adjust_color(bg, 20 if not light else -20)},"
        f"bg:{bg},"
        f"spinner:{ptr},"
        f"hl:{hl},"
        f"fg:{fg},"
        f"header:{hl},"
        f"info:{acc1},"
        f"pointer:{ptr},"
        f"marker:{mrk},"
        f"fg+:{fg},"
        f"prompt:{acc1},"
        f"hl+:{hl2},"
        f"selected-bg:{sel_bg}"
    )


def kitty_theme(colors, palette):
    bg  = colors.get("background", "#1E1E2E")
    fg  = colors.get("foreground", "#CDD6F4")
    cur = colors.get("cursor-color", fg)
    cur_text = colors.get("cursor-text", bg)
    sel_bg = colors.get("selection-background", palette.get(8, "#585B70"))
    sel_fg = colors.get("selection-foreground", fg)
    url = palette.get(4, fg)
    active_border = palette.get(12, palette.get(4, fg))
    inactive_border = palette.get(8, adjust_color(bg, 30))
    bell = palette.get(11, palette.get(3, fg))
    active_tab_fg = bg
    active_tab_bg = palette.get(13, palette.get(5, fg))
    inactive_tab_fg = fg
    inactive_tab_bg = adjust_color(bg, 10)
    tab_bar_bg = adjust_color(bg, -5)

    lines = [
        f"foreground              {fg}",
        f"background              {bg}",
        f"selection_foreground     {sel_fg}",
        f"selection_background     {sel_bg}",
        f"cursor                  {cur}",
        f"cursor_text_color       {cur_text}",
        f"url_color               {url}",
        f"active_border_color     {active_border}",
        f"inactive_border_color   {inactive_border}",
        f"bell_border_color       {bell}",
        f"active_tab_foreground   {active_tab_fg}",
        f"active_tab_background   {active_tab_bg}",
        f"inactive_tab_foreground {inactive_tab_fg}",
        f"inactive_tab_background {inactive_tab_bg}",
        f"tab_bar_background      {tab_bar_bg}",
    ]
    for i in range(16):
        c = palette.get(i)
        if c:
            lines.append(f"color{i:<3} {c}")

    return "\n".join(lines)


def tmux_theme(colors, palette):
    bg  = colors.get("background", "#1E1E2E")
    fg  = colors.get("foreground", "#CDD6F4")
    dim = palette.get(8, adjust_color(bg, 20))
    acc = palette.get(13, palette.get(5, fg))
    msg_bg = palette.get(0, adjust_color(bg, 15))

    return "\n".join([
        f"set -g status-style 'bg={bg},fg={fg}'",
        f"set -g window-status-style 'bg={bg},fg={dim}'",
        f"set -g window-status-current-style 'bg={bg},fg={acc},bold'",
        f"set -g message-style 'bg={msg_bg},fg={fg}'",
    ])


def generate(ghostty_name, dry_run=False):
    slug = make_slug(ghostty_name)
    out_path = os.path.join(DOTFILES_THEMES, f"{slug}.sh")

    if os.path.exists(out_path):
        return "skip"

    src = os.path.join(GHOSTTY_THEMES, ghostty_name)
    colors, palette = parse_ghostty_theme(src)

    bg = colors.get("background", "#1E1E2E")
    fg = colors.get("foreground", "#CDD6F4")
    light = is_light(bg)
    name_lower = ghostty_name.lower()

    vivid = match_rule(name_lower, VIVID_RULES)[0]
    nvim_cs, nvim_setup = match_rule(name_lower, NVIM_RULES)
    nvim_bg = "light" if light else "dark"

    kit = kitty_theme(colors, palette)
    tmux = tmux_theme(colors, palette)
    fzf = fzf_colors(colors, palette, light)

    lines = [
        f"# Theme: {slug} (generated from ghostty '{ghostty_name}')",
        f'THEME_NAME="{slug}"',
        f'GHOSTTY_THEME="{ghostty_name}"',
        f'NVIM_COLORSCHEME="{nvim_cs}"',
        f'NVIM_BACKGROUND="{nvim_bg}"',
        f"NVIM_SETUP='{nvim_setup}'",
        f'VIVID_THEME="{vivid}"',
        f'FZF_COLORS="{fzf}"',
        "",
        "KITTY_THEME=\"",
        kit,
        "\"",
        "",
        "TMUX_THEME=\"",
        tmux,
        "\"",
    ]

    if not dry_run:
        with open(out_path, "w") as f:
            f.write("\n".join(lines) + "\n")

    return "created"


def main():
    dry_run = "--dry-run" in sys.argv
    only_filter = next((a for a in sys.argv[1:] if not a.startswith("-")), None)

    skipped = created = 0
    names = sorted(os.listdir(GHOSTTY_THEMES))

    for name in names:
        if only_filter and only_filter.lower() not in name.lower():
            continue
        result = generate(name, dry_run=dry_run)
        if result == "skip":
            skipped += 1
        else:
            slug = make_slug(name)
            marker = "(dry)" if dry_run else ""
            print(f"  {marker}created  {slug}  ← '{name}'")
            created += 1

    print(f"\n{created} created, {skipped} skipped (already exist)")


if __name__ == "__main__":
    main()
