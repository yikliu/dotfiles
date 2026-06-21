-- Custom terminal management for Neovim
-- Opens terminals as regular buffers (shows in bufferline)

local M = {}

local api = vim.api
local fn = vim.fn

-- Store terminal buffers
local terminals = {}
local current_term = 1

-- Check if terminal buffer exists and is valid
local function is_term_valid(idx)
    return terminals[idx] and api.nvim_buf_is_valid(terminals[idx].buf)
end

-- Open or switch to terminal
function M.open_terminal(idx)
    idx = idx or current_term

    -- If terminal exists, switch to it
    if is_term_valid(idx) then
        vim.cmd("buffer " .. terminals[idx].buf)
        vim.cmd("startinsert")
        current_term = idx
        return
    end

    -- Create new buffer with terminal
    vim.cmd("enew")
    local chan = fn.termopen(vim.o.shell, {
        on_exit = function()
            terminals[idx] = nil
        end,
    })

    local buf = api.nvim_get_current_buf()
    api.nvim_buf_set_name(buf, "terminal-" .. idx)

    -- Keep it listed so it shows in bufferline
    vim.bo[buf].buflisted = true

    terminals[idx] = { buf = buf, chan = chan }
    current_term = idx

    vim.cmd("startinsert")
end

-- Toggle terminal (switch between terminal and previous buffer)
function M.toggle_terminal(idx)
    idx = idx or current_term

    if is_term_valid(idx) and api.nvim_get_current_buf() == terminals[idx].buf then
        vim.cmd("bprevious")
    else
        M.open_terminal(idx)
    end
end

-- Setup keymaps
function M.setup()
    local keymap = vim.keymap

    -- Toggle main terminal
    keymap.set("n", "<leader>;", function() M.toggle_terminal(1) end, { desc = "Toggle terminal" })

    -- Open specific terminals
    keymap.set("n", "<leader>t1", function() M.open_terminal(1) end, { desc = "Terminal 1" })
    keymap.set("n", "<leader>t2", function() M.open_terminal(2) end, { desc = "Terminal 2" })
    keymap.set("n", "<leader>t3", function() M.open_terminal(3) end, { desc = "Terminal 3" })
    keymap.set("n", "<leader>t4", function() M.open_terminal(4) end, { desc = "Terminal 4" })
    keymap.set("n", "<leader>t5", function() M.open_terminal(5) end, { desc = "Terminal 5" })
end

M.setup()

return M
