require("mason-lspconfig").setup {
    ensure_installed = {
                         "rust_analyzer",
                         "pyright",
                         "ts_ls",
                         "lua_ls",
                         "jsonls",
                         "kotlin_language_server",
                         "html"
                       },
}

require("lspconfig").kotlin_language_server.setup({
    cmd = { "kotlin-language-server" },
    filetypes = { "kotlin" }
})



