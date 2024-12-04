local keymap = vim.keymap
keymap.set('n', "<leader>oi", "<cmd>lua require'jdtls'.organize_imports()<cr>", {desc = "organize imports"})
