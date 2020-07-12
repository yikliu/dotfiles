local sessions = require("sessions")

sessions.setup({
    events = { "BufEnter" },
    session_filepath = ".nvim/session",
    absolute = false,
})

-- Keymaps (o = open session)
local map = vim.keymap.set
map("n", "<leader>os", function() sessions.save() end, { desc = "Save session" })
map("n", "<leader>ol", function() sessions.load() end, { desc = "Load session" })
map("n", "<leader>ox", function() sessions.stop() end, { desc = "Stop session tracking" })

-- Auto-save session on exit (if session is active)
vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
        sessions.save(nil, { silent = true })
    end,
})

-- Auto-load session on startup (if session file exists and no files were passed)
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        -- Only auto-load if nvim was started without file arguments
        if vim.fn.argc() == 0 then
            local session_file = vim.fn.getcwd() .. "/.nvim/session"
            if vim.fn.filereadable(session_file) == 1 then
                sessions.load(nil, { silent = true })
                -- Re-trigger filetype detection to enable treesitter highlighting
                vim.defer_fn(function()
                    vim.cmd("doautocmd BufRead")
                end, 100)
            end
        end
    end,
})
