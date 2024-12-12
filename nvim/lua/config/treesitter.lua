require("nvim-treesitter.configs").setup {
    ensure_installed = { "python", "java", "cpp", "lua", "vim", "typescript", "markdown", "kotlin", "markdown_inline", "html", "bash" },
    ignore_install = {}, -- List of parsers to ignore installing
    sync_install = true,
    highlight = {
        enable = true, -- false will disable the whole extension
    },
    indent = { enable = true },
}

local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.org = {
  install_info = {
    url = 'https://github.com/milisims/tree-sitter-org',
    revision = 'main',
    files = { 'src/parser.c', 'src/scanner.c' },
  },
  filetype = 'org',
}
