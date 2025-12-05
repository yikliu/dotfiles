require("conform").setup({
	-- Configure Black for Amazon Python standards (100 char line length)
	formatters = {
		black = {
			prepend_args = { "--line-length", "100" },
		},
	},
	formatters_by_ft = {
		-- Java (disabled - use brazil-build format)
		-- java = { "google-java-format" },
		-- C/C++
		c = { "clang-format" },
		cpp = { "clang-format" },
		-- Kotlin (ktlint also formats)
		kotlin = { "ktlint" },
		-- Python
		python = { "black" },
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
	-- Disabled: only format manually with <space>fm
	format_on_save = false,
	log_level = vim.log.levels.ERROR,
})
