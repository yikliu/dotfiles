vim.loader.enable()

local core_conf_files = {
	"neovide.lua", -- neovide configs 
	"globals.lua", -- some global settings
	"options.vim", -- setting options in nvim
	"mappings.lua", -- all the user-defined mappings
	"plugins.vim", -- all the plugins installed and their configurations
	"colorschemes.lua", -- colorscheme settings
}

-- source all the core config files
for _, name in ipairs(core_conf_files) do
	local path = string.format("%s/core/%s", vim.fn.stdpath("config"), name)
	local source_cmd = "source " .. path
	vim.cmd(source_cmd)
end
