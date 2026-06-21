require("mason-nvim-lint").setup({
	ensure_installed = { "ktlint" }, -- luacheck installed via brew
	ignore_install = { "custom-linter" }, -- avoid trying to install an unknown linter
})
