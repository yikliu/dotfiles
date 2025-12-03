-- Java (jdtls) language server configuration
-- This is handled separately via nvim-jdtls plugin but shares the common LSP setup

local M = {}

function M.attach()
    local lsp_utils = require("lsp")
    local default_config = require("lspconfig.configs.jdtls").default_config
    local cmd = default_config.cmd

    -- Lombok support
    local lombok_jar = vim.fn.expand("$MASON/share/jdtls/lombok.jar")
    if vim.uv.fs_stat(lombok_jar) then
        table.insert(cmd, string.format("--jvm-arg=-javaagent:%s", lombok_jar))
    end

    -- Find root directory (bemol or standard markers)
    local root_dir = require("jdtls.setup").find_root({ "packageInfo", ".git", "pom.xml", "build.gradle" }, "Config")

    -- Setup bemol workspaces if available
    local bemol_root = lsp_utils.find_bemol_root()
    local ws_folders = {}
    if bemol_root then
        local ws_file = io.open(bemol_root .. "/.bemol/ws_root_folders")
        if ws_file then
            for line in ws_file:lines() do
                table.insert(ws_folders, line)
            end
            ws_file:close()
        end
    end

    -- jdtls-specific keymaps
    vim.keymap.set("n", "<leader>co", require("jdtls").organize_imports, { desc = "Organize Imports", buffer = true })
    vim.keymap.set("n", "<leader>crv", require("jdtls").extract_variable, { desc = "Extract Variable", buffer = true })
    vim.keymap.set("n", "<leader>crc", require("jdtls").extract_constant, { desc = "Extract Constant", buffer = true })
    vim.keymap.set("v", "<leader>crm", function() require("jdtls").extract_method(true) end, { desc = "Extract Method", buffer = true })

    require('jdtls').start_or_attach({
        cmd = cmd,
        root_dir = root_dir or vim.fn.getcwd(),
        on_attach = function(client, bufnr)
            -- Use shared on_attach for common keymaps and features
            lsp_utils.on_attach(client, bufnr)

            -- Add bemol workspace folders after LSP is attached
            for _, folder in ipairs(ws_folders) do
                vim.lsp.buf.add_workspace_folder(folder)
            end
        end,
        capabilities = lsp_utils.get_capabilities(),
        settings = {
            java = {
                signatureHelp = { enabled = true },
                contentProvider = { preferred = "fernflower" },
                completion = {
                    favoriteStaticMembers = {
                        "org.junit.Assert.*",
                        "org.junit.Assume.*",
                        "org.junit.jupiter.api.Assertions.*",
                        "org.mockito.Mockito.*",
                    },
                },
                sources = {
                    organizeImports = {
                        starThreshold = 9999,
                        staticStarThreshold = 9999,
                    },
                },
            },
        },
    })
end

return M
