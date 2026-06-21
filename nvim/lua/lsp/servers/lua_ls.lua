-- Lua language server configuration
local fn = vim.fn

return {
    name = "lua_ls",
    config = {
        settings = {
            Lua = {
                runtime = {
                    version = "LuaJIT",
                },
                diagnostics = {
                    globals = { "vim" },
                },
                workspace = {
                    library = {
                        fn.stdpath("data") .. "/site/pack/packer/opt/emmylua-nvim",
                        fn.stdpath("config"),
                    },
                    maxPreload = 2000,
                    preloadFileSize = 50000,
                },
            },
        },
    }
}
