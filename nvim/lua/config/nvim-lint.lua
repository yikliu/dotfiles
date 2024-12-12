local api = vim.api
local lint = require('lint')

lint.linters_by_ft = {
  markdown = { 'vale' },
  kotlin = { 'ktlint'}
}

api.nvim_create_autocmd({ "BufWritePost" }, {
  callback = function()
    lint.try_lint()
  end,
})
