local pounce = require("pounce")
pounce.setup {
    do_repeat = false, -- to reuse the last pounce search
    accept_keys = "JFKDLSAHGNUVRBYTMICEOXWPQZ",
    accept_best_key = "<enter>",
    multi_window = true,
    debug = false,
}

local map = vim.keymap.set
map("n", "@", function() require'pounce'.pounce { } end)
map("x", "@", function() require'pounce'.pounce { } end)
