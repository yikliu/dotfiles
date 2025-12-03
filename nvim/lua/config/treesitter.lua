require("nvim-treesitter.configs").setup {
    ensure_installed = { "python", "org", "java", "cpp", "lua", "vim", "typescript", "markdown", "kotlin", "markdown_inline", "html", "bash" },
    ignore_install = {}, -- List of parsers to ignore installing
    sync_install = true,
    highlight = {
        enable = true, -- false will disable the whole extension
    },
    indent = { enable = true },
}
