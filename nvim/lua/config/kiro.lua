-- Kiro CLI integration for Neovim
-- Provides keybindings to interact with Kiro CLI from within Neovim

local M = {}

local api = vim.api
local fn = vim.fn

-- Configuration
M.config = {
    -- Kiro CLI command (kiro-cli, not kiro which opens the IDE)
    -- Using full path since GUI Neovim may not have toolbox in PATH
    kiro_cmd = vim.fn.expand("~/.toolbox/bin/kiro-cli"),
}

-- State
local kiro_buf = nil
local kiro_chan = nil

-- Check if kiro is installed
local function kiro_installed()
    return fn.executable(M.config.kiro_cmd) == 1
end

-- Check if kiro buffer exists and is valid
local function is_kiro_buf_valid()
    return kiro_buf and api.nvim_buf_is_valid(kiro_buf)
end

-- Open kiro chat as a buffer
function M.open_chat()
    if not kiro_installed() then
        vim.notify("kiro-cli not found. Install with: toolbox install kiro-cli", vim.log.levels.ERROR)
        return
    end

    -- If buffer exists, just switch to it
    if is_kiro_buf_valid() then
        vim.cmd("buffer " .. kiro_buf)
        vim.cmd("startinsert")
        return
    end

    -- Create new buffer with terminal
    vim.cmd("enew")
    kiro_chan = fn.termopen(M.config.kiro_cmd .. " chat", {
        on_exit = function()
            kiro_buf = nil
            kiro_chan = nil
        end,
    })
    kiro_buf = api.nvim_get_current_buf()
    api.nvim_buf_set_name(kiro_buf, "kiro-chat")

    -- Keep it listed so it shows in bufferline
    vim.bo[kiro_buf].buflisted = true

    vim.cmd("startinsert")
end

-- Toggle kiro chat
function M.toggle_chat()
    if is_kiro_buf_valid() and api.nvim_get_current_buf() == kiro_buf then
        -- If we're in kiro buffer, go to previous buffer
        vim.cmd("bprevious")
    else
        M.open_chat()
    end
end

-- Send text to kiro chat
function M.send_to_chat(text)
    local was_closed = not is_kiro_buf_valid()

    if was_closed then
        M.open_chat()
    end

    -- Wait a bit for terminal to initialize if it was just opened
    local delay = was_closed and 500 or 0

    vim.defer_fn(function()
        if kiro_chan then
            api.nvim_chan_send(kiro_chan, text .. "\n")
            -- Switch to kiro buffer
            if is_kiro_buf_valid() then
                vim.cmd("buffer " .. kiro_buf)
            end
        end
    end, delay)
end

-- Send current selection to kiro
function M.send_selection()
    local start_pos = fn.getpos("'<")
    local end_pos = fn.getpos("'>")
    local lines = api.nvim_buf_get_lines(0, start_pos[2] - 1, end_pos[2], false)

    if #lines == 0 then
        vim.notify("No selection", vim.log.levels.WARN)
        return
    end

    if #lines == 1 then
        lines[1] = string.sub(lines[1], start_pos[3], end_pos[3])
    else
        lines[1] = string.sub(lines[1], start_pos[3])
        lines[#lines] = string.sub(lines[#lines], 1, end_pos[3])
    end

    local text = table.concat(lines, "\n")
    local filetype = vim.bo.filetype
    local prompt = string.format("```%s\n%s\n```", filetype, text)

    M.send_to_chat(prompt)
end

-- Send current buffer to kiro
function M.send_buffer()
    local lines = api.nvim_buf_get_lines(0, 0, -1, false)
    local text = table.concat(lines, "\n")
    local filetype = vim.bo.filetype
    local filename = fn.expand("%:t")
    local prompt = string.format("File: %s\n```%s\n%s\n```", filename, filetype, text)

    M.send_to_chat(prompt)
end

-- Ask kiro to explain selection
function M.explain_selection()
    local start_pos = fn.getpos("'<")
    local end_pos = fn.getpos("'>")
    local lines = api.nvim_buf_get_lines(0, start_pos[2] - 1, end_pos[2], false)

    if #lines == 0 then
        vim.notify("No selection", vim.log.levels.WARN)
        return
    end

    if #lines == 1 then
        lines[1] = string.sub(lines[1], start_pos[3], end_pos[3])
    else
        lines[1] = string.sub(lines[1], start_pos[3])
        lines[#lines] = string.sub(lines[#lines], 1, end_pos[3])
    end

    local text = table.concat(lines, "\n")
    local filetype = vim.bo.filetype
    local prompt = string.format("Explain this %s code:\n```%s\n%s\n```", filetype, filetype, text)

    M.send_to_chat(prompt)
end

-- Ask kiro to review selection
function M.review_selection()
    local start_pos = fn.getpos("'<")
    local end_pos = fn.getpos("'>")
    local lines = api.nvim_buf_get_lines(0, start_pos[2] - 1, end_pos[2], false)

    if #lines == 0 then
        vim.notify("No selection", vim.log.levels.WARN)
        return
    end

    if #lines == 1 then
        lines[1] = string.sub(lines[1], start_pos[3], end_pos[3])
    else
        lines[1] = string.sub(lines[1], start_pos[3])
        lines[#lines] = string.sub(lines[#lines], 1, end_pos[3])
    end

    local text = table.concat(lines, "\n")
    local filetype = vim.bo.filetype
    local prompt = string.format("Review this %s code for bugs, improvements, and best practices:\n```%s\n%s\n```", filetype, filetype, text)

    M.send_to_chat(prompt)
end

-- Run kiro inline (one-shot question)
function M.ask(question)
    if not kiro_installed() then
        vim.notify("kiro-cli not found. Install with: toolbox install kiro-cli", vim.log.levels.ERROR)
        return
    end

    if not question or question == "" then
        question = fn.input("Ask Kiro: ")
        if question == "" then return end
    end

    M.send_to_chat(question)
end

-- Setup keymaps
function M.setup(opts)
    M.config = vim.tbl_deep_extend("force", M.config, opts or {})

    local keymap = vim.keymap

    -- Normal mode mappings
    keymap.set("n", "<leader>kc", M.toggle_chat, { desc = "Toggle Kiro chat" })
    keymap.set("n", "<leader>ka", M.ask, { desc = "Ask Kiro" })
    keymap.set("n", "<leader>kb", M.send_buffer, { desc = "Send buffer to Kiro" })

    -- Visual mode mappings
    keymap.set("v", "<leader>ks", M.send_selection, { desc = "Send selection to Kiro" })
    keymap.set("v", "<leader>ke", M.explain_selection, { desc = "Explain selection with Kiro" })
    keymap.set("v", "<leader>kr", M.review_selection, { desc = "Review selection with Kiro" })
end

return M
