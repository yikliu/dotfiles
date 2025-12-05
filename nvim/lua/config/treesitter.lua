require("nvim-treesitter.configs").setup {
    ensure_installed = { "python", "org", "java", "cpp", "lua", "vim", "typescript", "markdown", "kotlin", "markdown_inline", "html", "bash" },
    ignore_install = {}, -- List of parsers to ignore installing
    sync_install = true,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    indent = { enable = true },
    -- Better code understanding
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "<CR>",
            node_incremental = "<CR>",
            node_decremental = "<BS>",
        },
    },
}
