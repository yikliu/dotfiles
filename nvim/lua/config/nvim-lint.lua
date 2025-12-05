local api = vim.api
local lint = require('lint')

-- Configure flake8 for Amazon Python standards (PEP 8 + Black compatibility)
lint.linters.flake8.args = {
    '--max-line-length=100',
    '--extend-ignore=E501,W503,E203',
    '--format=%(path)s:%(row)d:%(col)d:%(code)s:%(text)s',
    '--no-show-source',
    '-',
}

lint.linters_by_ft = {
    -- Java (disabled - use brazil-build)
    -- java = { 'checkstyle' },
    -- C/C++
    c = { 'cpplint' },
    cpp = { 'cpplint' },
    -- Kotlin
    kotlin = { 'ktlint' },
    -- Python
    python = { 'flake8' },
    -- TypeScript/JavaScript
    typescript = { 'eslint_d' },
    typescriptreact = { 'eslint_d' },
    javascript = { 'eslint_d' },
    javascriptreact = { 'eslint_d' },
    -- Go
    go = { 'golangcilint' },
    -- Bash/Shell
    sh = { 'shellcheck' },
    bash = { 'shellcheck' },
    -- Vim
    vim = { 'vint' },
    -- Lua
    lua = { 'luacheck' },
    -- Markdown
    markdown = { 'vale' },
}

api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
    callback = function()
        lint.try_lint()
    end,
})
