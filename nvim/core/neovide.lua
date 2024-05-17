if vim.g.neovide then
    -- font
    vim.o.guifont = "AurulentSansM Nerd Font:h17:b"
 
    -- g:neovide_transparency should be 0 if you want to unify transparency of content and title bar.
    vim.g.neovide_transparency = 0.9

    -- window blurred
    vim.g.neovide_window_blurred = true
 
    vim.g.neovide_scroll_animation_length = 0.5
    vim.g.neovide_scroll_animation_far_lines = 2
 
    vim.g.neovide_cursor_animation_length = 0.05
    vim.g.neovide_cursor_trail_size = 0.5
    vim.g.neovide_cursor_antialiasing = true
    vim.g.neovide_cursor_vfx_mode = "ripple"
    vim.api.nvim_set_keymap('', '<D-v>', '+p<CR>', { noremap = true, silent = true})
    vim.api.nvim_set_keymap('!', '<D-v>', '<C-R>+', { noremap = true, silent = true})
    vim.api.nvim_set_keymap('t', '<D-v>', '<C-R>+', { noremap = true, silent = true})
    vim.api.nvim_set_keymap('v', '<D-v>', '<C-R>+', { noremap = true, silent = true})
 end


