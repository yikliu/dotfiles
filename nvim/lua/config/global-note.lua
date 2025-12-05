require("global-note").setup({
    filename = "global-note.md",
    directory = vim.fn.expand("~/Dropbox/global-note/"),
})

vim.keymap.set("n", "<leader>n", function()
    require("global-note").toggle_note()
end, { desc = "Toggle global note" })
