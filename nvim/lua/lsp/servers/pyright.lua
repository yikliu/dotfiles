-- Python (Pyright) language server configuration
return {
    name = "pyright",
    config = {
        settings = {
            python = {
                analysis = {
                    typeCheckingMode = "basic",
                    autoSearchPaths = true,
                    useLibraryCodeForTypes = true,
                },
            },
        },
    }
}
