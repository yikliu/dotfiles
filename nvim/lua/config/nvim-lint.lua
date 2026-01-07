local api = vim.api
local lint = require('lint')

-- Configure ruff for Python linting
lint.linters.ruff = {
    cmd = "ruff",
    args = {
        "check",
        "--force-exclude",
        "--format",
        "json",
        "-",
    },
    stdin = true,
    ignore_exitcode = true,
    parser = function(output)
        local success, parsed = pcall(vim.json.decode, output, { array = true })
        if not success then
            return {}
        end

        local diagnostics = {}
        for _, diagnostic in ipairs(parsed) do
            table.insert(diagnostics, {
                source = "ruff",
                row = diagnostic.location.row,
                col = diagnostic.location.column,
                end_row = diagnostic.end_location.row,
                end_col = diagnostic.end_location.column,
                message = diagnostic.message,
                severity = lint.severities[({
                    ["E"] = "error",
                    ["W"] = "warning",
                    ["I"] = "info",
                    ["H"] = "hint",
                })[diagnostic.kind.code:sub(1, 1)] or "error"],
                code = diagnostic.kind.code,
            })
        end
        return diagnostics
    end,
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
    python = { 'ruff' },
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
