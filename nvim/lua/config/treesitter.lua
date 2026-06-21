require("nvim-treesitter.config").setup {
    ensure_installed = {
        "python", "java", "cpp", "lua", "vim", "typescript",
        "markdown", "kotlin", "markdown_inline", "html", "bash",
    },
    highlight = { enable = true, additional_vim_regex_highlighting = false },
    indent = { enable = true },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "<CR>",
            node_incremental = "<CR>",
            node_decremental = "<BS>",
        },
    },
}
