local api = vim.api
local lint = require('lint')

lint.linters_by_ft = {
  markdown = { 'vale' },
  kotlin = { 'ktlint' },
  python = { 'flake8' },
}

api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
  callback = function()
    lint.try_lint()
  end,
})
