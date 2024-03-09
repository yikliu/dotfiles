-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local keymap = vim.keymap
local api = vim.api
local uv = vim.loop

keymap.set("n", "<leader>x", "<cmd>bprevious <bar> bdelete #<cr>", {
  silent = true,
  desc = "delete buffer",
})
