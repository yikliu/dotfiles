-- Swift/SourceKit language server configuration
return {
    name = "sourcekit",
    config = {
        cmd = { vim.trim(vim.fn.system("xcrun -f sourcekit-lsp")) },
        on_init = function(client)
            -- HACK: fix some LSP issues
            -- https://github.com/neovim/neovim/issues/19237#issuecomment-2237037154
            client.offset_encoding = "utf-8"
        end,
    }
}
