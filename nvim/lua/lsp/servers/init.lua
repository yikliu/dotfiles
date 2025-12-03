-- Server registry
-- Each server file returns its specific configuration
-- Add new servers by creating a file in this directory

local servers = {}

-- Helper to safely load a server config
local function load_server(name)
    local ok, config = pcall(require, "lsp.servers." .. name)
    if ok and config then
        servers[config.name or name] = config.config or {}
    end
end

-- Load all server configurations
load_server("lua_ls")
load_server("kotlin")
load_server("sourcekit")
load_server("bash")
load_server("pyright")
load_server("typescript")
load_server("json")
load_server("html")
load_server("rust")
load_server("vimls")

return servers
