local fn = vim.fn
local api = vim.api
local keymap = vim.keymap
local lsp = vim.lsp
local diagnostic = vim.diagnostic
local home = os.getenv("HOME")

require("mason-lspconfig").setup {
    ensure_installed = {
        "rust_analyzer",
        "pyright",
        "ts_ls",
        "lua_ls",
        "jdtls",
        "jsonls",
        "kotlin_language_server",
        "html"
    },
    automatic_enable = {
        -- We will enable jdtls ourselves in attach_jdtls()
        exclude = { "jdtls" }
    }
}

local function bemol()
    local bemol_dir = vim.fs.find({ '.bemol' }, { upward = true, type = 'directory' })[1]
    local ws_folders_lsp = {}
    if bemol_dir then
        local file = io.open(bemol_dir .. '/ws_root_folders', 'r')
        if file then
            for line in file:lines() do
                table.insert(ws_folders_lsp, line)
            end
            file:close()
        end
    end

    for _, line in ipairs(ws_folders_lsp) do
        vim.lsp.buf.add_workspace_folder(line)
    end
end

local custom_attach = function(client, bufnr)
    -- Mappings.
    local map = function(mode, l, r, opts)
        opts = opts or {}
        opts.silent = true
        opts.buffer = bufnr
        keymap.set(mode, l, r, opts)
    end

    map("n", "<space>dp", diagnostic.goto_prev, { desc = "previous diagnostic" })
    map("n", "<space>dn", diagnostic.goto_next, { desc = "next diagnostic" })
    map("n", "<space>sq", diagnostic.setqflist, { desc = "put diagnostic to qf" })
    map("n", "<space>df", vim.lsp.buf.definition, { desc = "go to definition" })
    map("n", "<space>dc", vim.lsp.buf.declaration, { desc = "go to declaration" })
    map("n", "<space>im", vim.lsp.buf.implementation, { desc = "go to implementation" })
    map("n", "<space>td", vim.lsp.buf.type_definition, { desc = "go to type definition" })
    map("n", "<space>gr", vim.lsp.buf.references, { desc = "show references" })
    map("n", "<space>hv", vim.lsp.buf.hover, { desc = "hover on symbol" })
    map("n", "<space>sg", vim.lsp.buf.signature_help, { desc = "signature help" })
    map("n", "<space>rn", vim.lsp.buf.rename, { desc = "varialbe rename" })
    map("n", "<space>ca", vim.lsp.buf.code_action, { desc = "LSP code action" })
    map("n", "<space>wa", vim.lsp.buf.add_workspace_folder, { desc = "add workspace folder" })
    map("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, { desc = "remove workspace folder" })
    map("n", "<space>fm", vim.lsp.buf.format, { desc = "format buffer" })
    map("n", "<space>wl", function()
        inspect(vim.lsp.buf.list_workspace_folders())
    end, { desc = "list workspace folder" })

    api.nvim_create_autocmd("CursorHold", {
        buffer = bufnr,
        callback = function()
            local float_opts = {
                focusable = false,
                close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
                border = "rounded",
                source = "always", -- show source in diagnostic popup window
                prefix = " ",
            }

            if not vim.b.diagnostics_pos then
                vim.b.diagnostics_pos = { nil, nil }
            end

            local cursor_pos = api.nvim_win_get_cursor(0)
            if
                (cursor_pos[1] ~= vim.b.diagnostics_pos[1] or cursor_pos[2] ~= vim.b.diagnostics_pos[2])
                and #diagnostic.get() > 0
            then
                diagnostic.open_float(nil, float_opts)
            end

            vim.b.diagnostics_pos = cursor_pos
        end,
    })

    -- The blow command will highlight the current variable and its usages in the buffer.
    if client.server_capabilities.documentHighlightProvider then
        vim.cmd([[
            hi! link LspReferenceRead Visual
            hi! link LspReferenceText Visual
            hi! link LspReferenceWrite Visual
        ]])

        local gid = api.nvim_create_augroup("lsp_document_highlight", { clear = true })
        api.nvim_create_autocmd("CursorHold", {
            group = gid,
            buffer = bufnr,
            callback = function()
                lsp.buf.document_highlight()
            end,
        })

        api.nvim_create_autocmd("CursorMoved", {
            group = gid,
            buffer = bufnr,
            callback = function()
                lsp.buf.clear_references()
            end,
        })
    end

    if vim.g.logging_level == "debug" then
        local msg = string.format("Language server %s started!", client.name)
        vim.notify(msg, vim.log.levels.DEBUG, { title = "Nvim-config" })
    end

    bemol()
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()
lsp.config("kotlin_language_server", {
    on_attach = custom_attach,
    cmd = {
        -- not using the mason installed language server here, instead this is locally built kotlin language server
        -- see details here: https://github.com/fwcd/kotlin-language-server/issues/600
        home .. "/kotlin/kotlin-language-server/server/build/install/server/bin/kotlin-language-server",
    },
    filetypes = { "kotlin" },
    capabilities = capabilities
})

lsp.config("vmls", {
    on_attach = custom_attach,
    flags = {
        debounce_text_changes = 500,
    },
    capabilities = capabilities,
})

lsp.config("bashls", {
    on_attach = custom_attach,
    capabilities = capabilities,
})

lsp.config("sourcekit", {
    cmd = { vim.trim(vim.fn.system("xcrun -f sourcekit-lsp")), },
    capabilities = capabilities,
    on_attach = custom_attach,
    on_init = function(client)
        -- HACK: to fix some issues with LSP
        -- more details: https://github.com/neovim/neovim/issues/19237#issuecomment-2237037154
        client.offset_encoding = "utf-8"
    end,
})

lsp.config("lua_ls", {
    on_attach = custom_attach,
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = "LuaJIT",
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { "vim" },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files,
                -- see also https://github.com/LuaLS/lua-language-server/wiki/Libraries#link-to-workspace .
                -- Lua-dev.nvim also has similar settings for lua ls, https://github.com/folke/neodev.nvim/blob/main/lua/neodev/luals.lua .
                library = {
                    fn.stdpath("data") .. "/site/pack/packer/opt/emmylua-nvim",
                    fn.stdpath("config"),
                },
                maxPreload = 2000,
                preloadFileSize = 50000,
            },
        },
    },
    capabilities = capabilities,
})
