require("conform").setup({
	-- Configure Black for Amazon Python standards (100 char line length)
	formatters = {
		black = {
			prepend_args = { "--line-length", "100" },
		},
		prettier = {
			prepend_args = { "--print-width", "100" },
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
	-- Format on save with LSP fallback
	format_on_save = {
		timeout_ms = 1000,
		lsp_fallback = true, -- Use LSP formatter if conform doesn't have a formatter for the filetype
	},
	log_level = vim.log.levels.ERROR,
	-- Set up format-on-type
	on_attach = function(client, bufnr)
		if client.server_capabilities.documentFormattingProvider then
			local format_map = function()
				require("conform").format({ bufnr = bufnr })
			end
			vim.keymap.set("n", "<leader>fm", format_map, { buffer = bufnr, desc = "Format file" })
		end
	end,
})
