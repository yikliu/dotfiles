-- Ruff LSP server configuration
return {
    name = "ruff_lsp",
    config = {
        -- Ruff supports formatting, linting, and more
        settings = {
            -- Enable linting and formatting
            lint = {
                enable = true,
            },
            format = {
                enable = true,
            },
            -- Add any specific ruff configuration
            organizeImports = true,
        },
    }
}