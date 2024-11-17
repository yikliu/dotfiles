require("mason-lspconfig").setup {
    ensure_installed = {
                         "rust_analyzer",
                         "jdtls",
                         "pyright",
                         "ts_ls",
                         "lua_ls",
                         "jsonls",
                         "kotlin_language_server",
                         "html"
                       },
}
