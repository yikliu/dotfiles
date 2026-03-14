vim.loader.enable()
vim.uv = vim.uv or vim.loop

local core_conf_files = {
	"neovide.lua", -- neovide configs
	"globals.lua", -- some global settings
	"options.vim", -- setting options in nvim
	"mappings.lua", -- all the user-defined mappings
	"plugins.vim", -- all the plugins installed and their configurations
	"colorschemes.lua", -- colorscheme settings (fallback if no theme set)
}

-- source all the core config files
for _, name in ipairs(core_conf_files) do
	local path = string.format("%s/core/%s", vim.fn.stdpath("config"), name)
	local source_cmd = "source " .. path
	vim.cmd(source_cmd)
end

-- Override colorscheme if set-theme.sh has been used
local theme_file = vim.fn.expand("~/dotfiles/themes/.nvim-theme.lua")
if vim.fn.filereadable(theme_file) == 1 then
	dofile(theme_file)
end

-- Auto-reload theme when changed by set-theme.sh
local uv = vim.uv or vim.loop
local theme_watch = uv.new_fs_event()
if theme_watch and vim.fn.filereadable(theme_file) == 1 then
	theme_watch:start(theme_file, {}, function()
		-- Stop and restart to avoid duplicate events
		theme_watch:stop()
		vim.schedule(function()
			dofile(theme_file)
			theme_watch:start(theme_file, {}, function()
				theme_watch:stop()
				vim.schedule(function()
					dofile(theme_file)
				end)
			end)
		end)
	end)
end
