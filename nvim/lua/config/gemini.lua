-- Gemini CLI integration for Neovim
-- Provides a keybinding to open a Gemini chat in a new tab.

local M = {}

local fn = vim.fn

-- Configuration
M.config = {
    gemini_cmd = "gemini",
}

-- Check if gemini is installed
local function gemini_installed()
    return fn.executable(M.config.gemini_cmd) == 1
end

-- Open gemini chat in a new tab
function M.open_chat()
    if not gemini_installed() then
        vim.notify("gemini not found. Please make sure it is in your PATH.", vim.log.levels.ERROR)
        return
    end

    vim.cmd("tabnew")
    fn.termopen(M.config.gemini_cmd, {
        on_exit = function()
            vim.notify("Gemini chat exited.")
        end,
    })
    vim.cmd("startinsert")
end

-- Setup keymaps
function M.setup(opts)
    M.config = vim.tbl_deep_extend("force", M.config, opts or {})

    local keymap = vim.keymap

    -- Normal mode mappings
    keymap.set("n", "<leader>gc", M.open_chat, { desc = "Open Gemini chat" })
end

return M
