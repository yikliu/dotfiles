--- This module will load a random colorscheme on nvim startup process.

local utils = require("utils")

local M = {}

-- Colorscheme to its directory name mapping, because colorscheme repo name is not necessarily
-- the same as the colorscheme name itself.
M.colorscheme_conf = {
	onedark = function()
		vim.cmd([[colorscheme onedark]])
	end,
	edge = function()
		vim.g.edge_enable_italic = 1
		vim.g.edge_better_performance = 1

		vim.cmd([[colorscheme edge]])
	end,
	sonokai = function()
		vim.g.sonokai_enable_italic = 1
		vim.g.sonokai_better_performance = 1

		vim.cmd([[colorscheme sonokai]])
	end,
	everforest = function()
		vim.g.everforest_enable_italic = 1
		vim.g.everforest_better_performance = 1

		vim.cmd([[colorscheme everforest]])
	end,
	nightfox = function()
		vim.cmd([[colorscheme nordfox]])
	end,
	catppuccin = function()
		-- available option: latte, frappe, macchiato, mocha
		vim.g.catppuccin_flavour = "frappe"
		require("catppuccin").setup()

		vim.cmd([[colorscheme catppuccin]])
	end,
	material = function()
		vim.g.material_style = "oceanic"
		vim.cmd("colorscheme material")
	end,
	monokai = function()
		vim.cmd("colorscheme monokai_pro")
	end,
	kanagawa = function()
		vim.cmd([[colorscheme kanagawa]])
	end,
	doom_one = function()
		vim.cmd([[colorscheme doom-one]])
	end,
	paper_light = function()
		vim.cmd([[set t_Co=256]])
		vim.cmd([[set background=light]])
		vim.cmd([[colorscheme PaperColor]])
	end,
	paper_dark = function()
		vim.cmd([[set background=dark]])
		vim.cmd([[colorscheme PaperColor]])
	end,
	teide_darker = function()
		vim.cmd([[colorscheme teide-darker]])
	end,
	teide_dark = function()
		vim.cmd([[colorscheme teide-dark]])
	end,
	teide_dimmed = function()
		vim.cmd([[colorscheme teide-dimmed]])
	end,
	teide_light = function()
		vim.cmd([[colorscheme teide-light]])
	end,
}

-- Map colorscheme config keys to their lazy.nvim plugin names
M.colorscheme_plugin = {
	onedark = "onedark.nvim",
	edge = "edge",
	sonokai = "sonokai",
	everforest = "everforest",
	nightfox = "nightfox.nvim",
	catppuccin = "catppuccin",
	material = "material.nvim",
	monokai = "monokai.nvim",
	kanagawa = "kanagawa.nvim",
	doom_one = "doom-one.vim",
	paper_light = "papercolor-theme",
	paper_dark = "papercolor-theme",
	teide_darker = "teide.nvim",
	teide_dark = "teide.nvim",
	teide_dimmed = "teide.nvim",
	teide_light = "teide.nvim",
}

--- Use a random colorscheme from the pre-defined list of colorschemes.
M.rand_colorscheme = function()
	local colorscheme = utils.rand_element(vim.tbl_keys(M.colorscheme_conf))

	if not vim.tbl_contains(vim.tbl_keys(M.colorscheme_conf), colorscheme) then
		local msg = "Invalid colorscheme: " .. colorscheme
		vim.notify(msg, vim.log.levels.ERROR, { title = "nvim-config" })
		return
	end

	-- Ensure the plugin is loaded (lazy = true means it won't be loaded yet)
	local plugin_name = M.colorscheme_plugin[colorscheme]
	if plugin_name then
		require("lazy").load({ plugins = { plugin_name } })
	end

	-- Load the colorscheme and its settings
	M.colorscheme_conf[colorscheme]()

	local msg = "Colorscheme: " .. colorscheme
	vim.notify(msg, vim.log.levels.INFO, { title = "nvim-config" })
end

-- Load a random colorscheme
M.rand_colorscheme()
-- M.colorscheme_conf["teide_darker"]()
