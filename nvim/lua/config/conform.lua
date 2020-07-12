require("conform").setup({
	formatters = {
		black = {
			prepend_args = { "--line-length", "100" },
		},
		prettier = {
			prepend_args = { "--print-width", "100" },
		},
		-- Ruff formatter configuration
		ruff = {
			prepend_args = { "format" },
		},
	},
	formatters_by_ft = {
		-- Java (disabled - use project-specific formatter)
		-- java = { "google-java-format" },
		-- C/C++
		c = { "clang-format" },
		cpp = { "clang-format" },
		-- Kotlin (ktlint also formats)
		kotlin = { "ktlint" },
		-- Python
		python = { "ruff" },
		-- TypeScript/JavaScript
		typescript = { "prettier" },
		typescriptreact = { "prettier" },
		javascript = { "prettier" },
		javascriptreact = { "prettier" },
		-- Go
		go = { "goimports", "gofmt" },
		-- Rust
		rust = { "rustfmt" },
		-- Bash/Shell
		sh = { "shfmt" },
		bash = { "shfmt" },
		-- Lua
		lua = { "stylua" },
		-- Swift
		swift = { "swiftformat" },
		-- Web (HTML, CSS, JSON, YAML, Markdown)
		html = { "prettier" },
		css = { "prettier" },
		json = { "prettier" },
		yaml = { "prettier" },
		markdown = { "prettier" },
	},
	format_on_save = false,
	log_level = vim.log.levels.ERROR,
})
