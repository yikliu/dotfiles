require("mason-lspconfig").setup {
    ensure_installed = { 
                         "rust_analyzer",
                         "jdtls",
                         "pyright",
                         "ruby_ls",
                         "tsserver",
                         "lua_ls",
                         "jsonls",
                         "html"
                       },
}
