-- Mason-lspconfig setup
-- Handles automatic installation and enabling of LSP servers

require("mason-lspconfig").setup {
    ensure_installed = {
        "rust_analyzer",
        "pyright",
        "ts_ls",
        "lua_ls",
        "jdtls",
        "jsonls",
        "kotlin_language_server",
        "html",
        "bashls",
        "vimls",
        "ruff_lsp",
    },
    automatic_enable = {
        -- jdtls is handled by nvim-jdtls plugin
        exclude = { "jdtls" }
    }
}
