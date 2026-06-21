-- Ruff LSP server configuration (using built-in ruff server)
return {
    name = "ruff",
    config = {
        settings = {
            lint = {
                enable = true,
            },
            format = {
                enable = true,
            },
            organizeImports = true,
        },
    }
}
