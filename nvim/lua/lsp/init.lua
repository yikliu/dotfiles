-- Centralized LSP configuration
-- All servers use shared on_attach, capabilities, and bemol integration

local M = {}

local fn = vim.fn
local api = vim.api
local keymap = vim.keymap
local lsp = vim.lsp
local diagnostic = vim.diagnostic

-------------------------------------------------------------------------------
-- Diagnostic Configuration
-------------------------------------------------------------------------------
local function setup_diagnostics()
    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    diagnostic.config({
        underline = true,
        virtual_text = true,
        signs = true,
        severity_sort = true,
        update_in_insert = false,
    })

    lsp.handlers["textDocument/hover"] = lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
    })
end

-------------------------------------------------------------------------------
-- Bemol Integration (Brazil workspace support)
-------------------------------------------------------------------------------
function M.setup_bemol()
    local bemol_dir = vim.fs.find({ '.bemol' }, { upward = true, type = 'directory' })[1]
    if not bemol_dir then
        return {}
    end

    local ws_folders = {}
    local file = io.open(bemol_dir .. '/ws_root_folders', 'r')
    if file then
        for line in file:lines() do
            table.insert(ws_folders, line)
        end
        file:close()
    end

    for _, folder in ipairs(ws_folders) do
        lsp.buf.add_workspace_folder(folder)
    end

    return ws_folders
end

-- Find bemol root directory (useful for jdtls and other servers)
function M.find_bemol_root()
    local bemol_dir = vim.fs.find({ '.bemol' }, { upward = true, type = 'directory' })[1]
    if bemol_dir then
        return vim.fn.fnamemodify(bemol_dir, ':h')
    end
    return nil
end

-------------------------------------------------------------------------------
-- Shared Capabilities (with nvim-cmp integration)
-------------------------------------------------------------------------------
function M.get_capabilities()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    if ok then
        capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
    end
    return capabilities
end

-------------------------------------------------------------------------------
-- Shared on_attach (keymaps, document highlight, bemol)
-------------------------------------------------------------------------------
function M.on_attach(client, bufnr)
    local map = function(mode, l, r, opts)
        opts = opts or {}
        opts.silent = true
        opts.buffer = bufnr
        keymap.set(mode, l, r, opts)
    end

    -- Diagnostics navigation
    map("n", "<space>dp", diagnostic.goto_prev, { desc = "previous diagnostic" })
    map("n", "<space>dn", diagnostic.goto_next, { desc = "next diagnostic" })
    map("n", "<space>sq", diagnostic.setqflist, { desc = "put diagnostic to qf" })
    map("n", "<space>sl", diagnostic.setloclist, { desc = "diagnostics to loclist" })
    map("n", "<space>dl", diagnostic.open_float, { desc = "line diagnostics" })
    map("n", "<space>dt", function()
        diagnostic.enable(not diagnostic.is_enabled())
    end, { desc = "toggle diagnostics" })

    -- LSP navigation
    map("n", "<space>df", lsp.buf.definition, { desc = "go to definition" })
    map("n", "<space>dc", lsp.buf.declaration, { desc = "go to declaration" })
    map("n", "<space>im", lsp.buf.implementation, { desc = "go to implementation" })
    map("n", "<space>td", lsp.buf.type_definition, { desc = "go to type definition" })
    map("n", "<space>gr", lsp.buf.references, { desc = "show references" })

    -- Call hierarchy
    map("n", "<space>ci", lsp.buf.incoming_calls, { desc = "incoming calls" })
    map("n", "<space>co", lsp.buf.outgoing_calls, { desc = "outgoing calls" })

    -- Symbols
    map("n", "<space>ds", lsp.buf.document_symbol, { desc = "document symbols" })
    map("n", "<space>ws", lsp.buf.workspace_symbol, { desc = "workspace symbols" })

    -- LSP actions
    map("n", "<space>hv", lsp.buf.hover, { desc = "hover on symbol" })
    map("n", "<space>sg", lsp.buf.signature_help, { desc = "signature help" })
    map("n", "<space>rn", lsp.buf.rename, { desc = "variable rename" })
    map("n", "<space>ca", lsp.buf.code_action, { desc = "LSP code action" })
    map("n", "<space>fm", lsp.buf.format, { desc = "format buffer" })

    -- Codelens
    map("n", "<space>cl", lsp.codelens.run, { desc = "run codelens" })
    map("n", "<space>cL", lsp.codelens.refresh, { desc = "refresh codelens" })

    -- Inlay hints (Neovim 0.10+)
    map("n", "<space>ih", function()
        lsp.inlay_hint.enable(not lsp.inlay_hint.is_enabled())
    end, { desc = "toggle inlay hints" })

    -- Workspace management
    map("n", "<space>wa", lsp.buf.add_workspace_folder, { desc = "add workspace folder" })
    map("n", "<space>wr", lsp.buf.remove_workspace_folder, { desc = "remove workspace folder" })
    map("n", "<space>wl", function()
        print(vim.inspect(lsp.buf.list_workspace_folders()))
    end, { desc = "list workspace folder" })

    -- Diagnostic float on cursor hold
    api.nvim_create_autocmd("CursorHold", {
        buffer = bufnr,
        callback = function()
            local float_opts = {
                focusable = false,
                close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
                border = "rounded",
                source = "always",
                prefix = " ",
            }

            if not vim.b.diagnostics_pos then
                vim.b.diagnostics_pos = { nil, nil }
            end

            local cursor_pos = api.nvim_win_get_cursor(0)
            if (cursor_pos[1] ~= vim.b.diagnostics_pos[1] or cursor_pos[2] ~= vim.b.diagnostics_pos[2])
                and #diagnostic.get() > 0
            then
                diagnostic.open_float(nil, float_opts)
            end
            vim.b.diagnostics_pos = cursor_pos
        end,
    })

    -- Document highlight
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

    -- Setup bemol workspace folders
    M.setup_bemol()

    if vim.g.logging_level == "debug" then
        vim.notify(string.format("Language server %s started!", client.name), vim.log.levels.DEBUG, { title = "LSP" })
    end
end

-------------------------------------------------------------------------------
-- Setup function (called from lazy plugin config)
-------------------------------------------------------------------------------
function M.setup()
    setup_diagnostics()

    -- Load server configurations
    local servers = require("lsp.servers")
    local capabilities = M.get_capabilities()

    for name, config in pairs(servers) do
        -- Merge shared settings with server-specific config
        local server_config = vim.tbl_deep_extend("force", {
            on_attach = M.on_attach,
            capabilities = capabilities,
        }, config)

        lsp.config(name, server_config)
    end
end

return M
