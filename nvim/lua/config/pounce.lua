local keymap = vim.keymap
local pounce = require("hop")
pounce.setup {
  case_insensitive = true,
  char2_fallback_key = "<CR>",
  keys = 'etovxqpdygfblzhckisuran',
  quit_key = "<Esc>",
}

keymap.set({ "n", "v", "o" }, "f", "", {
  silent = true,
  noremap = true,
  callback = function()
    pounce.hint_char2()
  end,
  desc = "nvim-hop char2",
})
