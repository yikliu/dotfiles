-- Rust Analyzer configuration
return {
    name = "rust_analyzer",
    config = {
        settings = {
            ["rust-analyzer"] = {
                checkOnSave = {
                    command = "clippy",
                },
            },
        },
    }
}
