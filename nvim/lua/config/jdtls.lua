-- Java (jdtls) setup via nvim-jdtls plugin
-- Uses shared LSP configuration from lua/lsp/

local jdtls_config = require("lsp.servers.jdtls")

vim.api.nvim_create_autocmd("FileType", {
    pattern = "java",
    callback = jdtls_config.attach
})

-- Attach immediately if already in a java file
if vim.bo.filetype == "java" then
    jdtls_config.attach()
end
