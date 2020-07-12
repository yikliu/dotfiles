-- Java (jdtls) language server configuration
-- This is handled separately via nvim-jdtls plugin but shares the common LSP setup

local M = {}

function M.attach()
    local lsp_utils = require("lsp")
    local jdtls = require("jdtls")
    local default_config = require("lspconfig.configs.jdtls").default_config
    local home = os.getenv("HOME")

    -- Find root: use .classpath (bemol-generated) first, then standard markers
    local root_dir = jdtls.setup.find_root({ ".classpath", "packageInfo" }, "Config")
        or vim.fs.root(0, { ".git", "pom.xml", "build.gradle" })
        or vim.fn.getcwd()
    root_dir = vim.fn.resolve(root_dir)

    -- Unique data dir per workspace to avoid jdtls state collisions
    local workspace_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
    local eclipse_workspace = home .. "/.local/share/eclipse/" .. workspace_name

    -- Build cmd
    local cmd = vim.deepcopy(default_config.cmd)
    local lombok_jar = vim.fn.expand("$MASON/share/jdtls/lombok.jar")
    if vim.uv.fs_stat(lombok_jar) then
        table.insert(cmd, "--jvm-arg=-javaagent:" .. lombok_jar)
    end
    table.insert(cmd, "-data")
    table.insert(cmd, eclipse_workspace)

    -- Read bemol workspace folders for init_options (must be passed at startup)
    local ws_folders_jdtls = {}
    local bemol_root = lsp_utils.find_bemol_root()
    if bemol_root then
        local ws_file = io.open(bemol_root .. "/.bemol/ws_root_folders")
        if ws_file then
            for line in ws_file:lines() do
                table.insert(ws_folders_jdtls, "file://" .. vim.fn.resolve(line))
            end
            ws_file:close()
        end
    end

    -- jdtls-specific keymaps
    vim.keymap.set("n", "<leader>co", jdtls.organize_imports, { desc = "Organize Imports", buffer = true })
    vim.keymap.set("n", "<leader>crv", jdtls.extract_variable, { desc = "Extract Variable", buffer = true })
    vim.keymap.set("n", "<leader>crc", jdtls.extract_constant, { desc = "Extract Constant", buffer = true })
    vim.keymap.set("v", "<leader>crm", function() jdtls.extract_method(true) end, { desc = "Extract Method", buffer = true })

    jdtls.start_or_attach({
        cmd = cmd,
        root_dir = root_dir,
        on_attach = lsp_utils.on_attach,
        capabilities = lsp_utils.get_capabilities(),
        init_options = {
            workspaceFolders = ws_folders_jdtls,
        },
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
