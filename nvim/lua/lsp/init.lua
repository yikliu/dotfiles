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
    -- Enhanced diagnostic signs with better icons
    local signs = {
        Error = "●",
        Warn = "●",
        Hint = "●",
        Info = "●"
    }
    for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        fn.sign_define(hl, {
            text = icon,
            texthl = hl,
            numhl = hl,
            priority = 10
        })
    end

    -- Enhanced diagnostic configuration
    diagnostic.config({
        underline = true,
        virtual_text = {
            prefix = '●', -- Show with dots instead of full text
            spacing = 2,
            source = 'if_many', -- Show source only if multiple LSPs provide diagnostics
            max_width = 100,
            format = function(diagnostic)
                -- Shorten diagnostic messages for cleaner display
                local message = diagnostic.message:gsub("\n", " "):gsub("\t", " ")
                if #message > 80 then
                    message = message:sub(1, 77) .. "..."
                end
                return message
            end
        },
        signs = true,
        severity_sort = true,
        float = {
            focusable = false,
            style = "minimal",
            border = "rounded",
            source = "if_many", -- Show source only if multiple providers
            header = { "", "Diagnostic" },
            prefix = function(diagnostic)
                -- Different prefixes based on severity
                local prefix_map = {
                    [vim.diagnostic.severity.ERROR] = " ",
                    [vim.diagnostic.severity.WARN] = " ",
                    [vim.diagnostic.severity.HINT] = "󰌵 ",
                    [vim.diagnostic.severity.INFO] = " "
                }
                return prefix_map[diagnostic.severity] or ""
            end,
        },
        update_in_insert = false,
        severity = {
            min = vim.diagnostic.severity.HINT,
        }
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
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = {
            'documentation',
            'detail',
            'additionalTextEdits',
        }
    }

    -- Enable more LSP features for better performance
    capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true
    }
    capabilities.textDocument.codeAction = {
        dynamicRegistration = false,
        codeActionLiteralSupport = {
            codeActionKind = {
                valueSet = {
                    "",
                    "quickfix",
                    "refactor",
                    "refactor.extract",
                    "refactor.inline",
                    "refactor.rewrite",
                    "source",
                    "source.organizeImports",
                },
            },
        },
    }

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

    -- LSP navigation with improved bindings (standard vim-style mappings)
    map("n", "gd", lsp.buf.definition, { desc = "go to definition" })
    map("n", "gD", lsp.buf.declaration, { desc = "go to declaration" })
    map("n", "gi", lsp.buf.implementation, { desc = "go to implementation" })
    map("n", "gt", lsp.buf.type_definition, { desc = "go to type definition" })
    map("n", "gr", lsp.buf.references, { desc = "show references" })
    map("n", "gy", lsp.buf.type_definition, { desc = "go to type definition (alternative)" })

    -- Call hierarchy
    map("n", "<space>ci", lsp.buf.incoming_calls, { desc = "incoming calls" })
    map("n", "<space>co", lsp.buf.outgoing_calls, { desc = "outgoing calls" })

    -- Symbols
    map("n", "<space>ds", lsp.buf.document_symbol, { desc = "document symbols" })
    map("n", "<space>ws", lsp.buf.workspace_symbol, { desc = "workspace symbols" })

    -- LSP actions with better keybindings
    map("n", "K", lsp.buf.hover, { desc = "hover on symbol" })
    map("n", "gK", lsp.buf.signature_help, { desc = "signature help" })
    map("n", "<F2>", lsp.buf.rename, { desc = "variable rename" })
    map("n", "<leader>ca", lsp.buf.code_action, { desc = "LSP code action" })
    -- Use conform for formatting if available, otherwise fallback to LSP
    map("n", "<leader>fm", function()
        local conform = pcall(require, "conform")
        if conform then
            require("conform").format({ bufnr = 0 })
        else
            vim.lsp.buf.format({ bufnr = 0 })
        end
    end, { desc = "format buffer" })
    map("n", "<leader>wa", lsp.buf.add_workspace_folder, { desc = "add workspace folder" })
    map("n", "<leader>wr", lsp.buf.remove_workspace_folder, { desc = "remove workspace folder" })
    map("n", "<leader>wl", function()
        print(vim.inspect(lsp.buf.list_workspace_folders()))
    end, { desc = "list workspace folders" })

    -- Codelens
    map("n", "<space>cl", lsp.codelens.run, { desc = "run codelens" })
    map("n", "<space>cL", lsp.codelens.refresh, { desc = "refresh codelens" })

    -- Inlay hints (Neovim 0.10+)
    map("n", "<space>ih", function()
        lsp.inlay_hint.enable(not lsp.inlay_hint.is_enabled())
    end, { desc = "toggle inlay hints" })

    -- Organize imports (works with TS/JS, and other language servers that support it)
    map("n", "<leader>oi", function()
        vim.lsp.buf.execute_command({
            command = "_typescript.organizeImport",
            arguments = { vim.uri_from_bufnr(0) }
        })
    end, { desc = "organize imports" })

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

    -- Enable semantic highlighting if the server supports it
    if client.server_capabilities.semanticTokensProvider then
        -- Check if semantic tokens are supported in this Neovim version
        if vim.lsp.buf.semantic_tokens and vim.lsp.buf.semantic_tokens.full then
            local semantic_tokens_augroup = api.nvim_create_augroup("LspSemanticTokens-" .. client.id, { clear = true })
            api.nvim_create_autocmd("BufEnter", {
                group = semantic_tokens_augroup,
                buffer = bufnr,
                callback = function()
                    -- Check if buffer is valid before requesting semantic tokens
                    if api.nvim_buf_is_valid(bufnr) and api.nvim_buf_get_option(bufnr, 'buflisted') then
                        -- Wrap semantic tokens in pcall to prevent errors
                        local success, err = pcall(vim.lsp.buf.semantic_tokens.full, bufnr)
                        if not success then
                            vim.notify("Semantic tokens error: " .. tostring(err), vim.log.levels.WARN, { title = "LSP" })
                        end
                    end
                end,
            })
        end
    end

    -- Enable inlay hints if available (Neovim 0.10+)
    if client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
        vim.lsp.inlay_hint.enable(bufnr, true)
    end

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
