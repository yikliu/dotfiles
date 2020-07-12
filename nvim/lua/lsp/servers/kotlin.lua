-- Kotlin language server configuration
local home = os.getenv("HOME")

return {
    name = "kotlin_language_server",
    config = {
        cmd = {
            -- Using locally built kotlin language server
            -- See: https://github.com/fwcd/kotlin-language-server/issues/600
            home .. "/kotlin/kotlin-language-server/server/build/install/server/bin/kotlin-language-server",
        },
        filetypes = { "kotlin" },
    }
}
