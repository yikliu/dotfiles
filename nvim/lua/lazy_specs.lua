local utils = require("utils")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    }
end
vim.opt.rtp:prepend(lazypath)

local plugin_specs = {

    -----------------------------------------------------------------------
    -- Core / Dependencies
    -----------------------------------------------------------------------
    -- Lua functions library
    { "nvim-lua/plenary.nvim" },
    -- File icons
    { "nvim-tree/nvim-web-devicons",       opts = {} },

    -----------------------------------------------------------------------
    -- LSP & Completion
    -----------------------------------------------------------------------
    -- LSP installer
    { "williamboman/mason.nvim",           lazy = false, config = function() require("config.mason") end },
    -- LSP config
    { "neovim/nvim-lspconfig",             lazy = false, config = function() require("config.nvim-lspconfig") end },
    -- Mason-LSP bridge
    { "williamboman/mason-lspconfig.nvim", lazy = false, config = function() require("config.mason-lspconfig") end },
    -- Java LSP
    { "mfussenegger/nvim-jdtls",           ft = "java",  config = function() require("config.jdtls") end },
    -- Linting
    { "mfussenegger/nvim-lint",            lazy = false, config = function() require("config.nvim-lint") end },
    -- Auto-completion
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-omni",
            "hrsh7th/cmp-emoji",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",
            "onsails/lspkind.nvim",
        },
        config = function() require("config.nvim-cmp") end,
    },

    -----------------------------------------------------------------------
    -- Treesitter & Syntax
    -----------------------------------------------------------------------
    -- Syntax highlighting
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        lazy = false,
        config = function()
            require("config.treesitter")
        end
    },
    -- Function argument highlighting
    {
        "m-demare/hlargs.nvim",
        lazy = false,
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = function()
            require("hlargs").setup()
        end
    },
    -- Markdown live preview
    {
        "iamcco/markdown-preview.nvim",
        ft = "markdown",
        build = "cd app && npm install",
        config = function()
            vim.g.mkdp_auto_close = 0
            vim.keymap.set("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", { desc = "Toggle markdown preview" })
            vim.keymap.set("n", "<leader>ms", "<cmd>MarkdownPreviewStop<cr>", { desc = "Stop markdown preview" })
        end
    },

    -----------------------------------------------------------------------
    -- Formatting & Code Quality
    -----------------------------------------------------------------------
    -- Code formatter
    {
        "stevearc/conform.nvim",
        lazy = false,
        config = function()
            require("config.conform")
        end
    },
    -- Auto format (legacy)
    { "sbdchd/neoformat",             cmd = { "Neoformat" } },

    -----------------------------------------------------------------------
    -- AI Assistants (loaded in core/plugins.vim)
    -----------------------------------------------------------------------

    -----------------------------------------------------------------------
    -- File Navigation & Search
    -----------------------------------------------------------------------
    -- Fuzzy finder
    {
        "nvim-telescope/telescope.nvim",
        lazy = false,
        config = function()
            require("config.telescope")
        end,
        dependencies = { "nvim-telescope/telescope-symbols.nvim", "nvim-lua/plenary.nvim" }
    },
    -- File explorer
    {
        "nvim-tree/nvim-tree.lua",
        lazy = false,
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("config.nvim-tree")
        end
    },
    -- Yazi file manager
    {
        "mikavilpas/yazi.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        event = "VeryLazy",
        config = function()
            require("config.yazi")
        end
    },
    -- FZF integration
    { "vijaymarupudi/nvim-fzf" },

    -----------------------------------------------------------------------
    -- Terminal
    -----------------------------------------------------------------------
    -- Custom terminal buffers
    {
        dir = vim.fn.stdpath("config") .. "/lua/config",
        name = "nvim-terminal",
        lazy = false,
        config = function()
            vim.o.hidden = true; require("config.nvim-terminal")
        end
    },

    -----------------------------------------------------------------------
    -- UI Components
    -----------------------------------------------------------------------
    -- Status line
    {
        "nvim-lualine/lualine.nvim",
        lazy = false,
        config = function()
            require("config.statusline")
        end
    },
    -- Buffer tabs
    {
        "akinsho/bufferline.nvim",
        lazy = false,
        config = function()
            require("config.bufferline")
        end
    },
    -- Start screen
    {
        "nvimdev/dashboard-nvim",
        lazy = false,
        config = function()
            require("config.dashboard-nvim")
        end,
        dependencies = { "nvim-tree/nvim-web-devicons" }
    },
    -- Notifications
    {
        "rcarriga/nvim-notify",
        lazy = false,
        config = function()
            require("config.nvim-notify")
        end
    },
    -- Indent guides
    {
        "lukas-reineke/indent-blankline.nvim",
        lazy = false,
        main = "ibl",
        config = function()
            require("config.indent-blankline")
        end
    },
    -- Better UI prompts
    { "stevearc/dressing.nvim", lazy = false },
    -- Keybinding hints
    {
        "folke/which-key.nvim",
        lazy = false,
        config = function()
            require("config.which-key")
        end
    },
    -- Zen mode
    {
        "folke/zen-mode.nvim",
        cmd = "ZenMode",
        config = function()
            require("config.zen-mode")
        end
    },

    -----------------------------------------------------------------------
    -- Navigation & Motion
    -----------------------------------------------------------------------
    -- Fast buffer jump
    {
        "rlane/pounce.nvim",
        event = "VeryLazy",
        config = function()
            require("config.nvim-pounce")
        end
    },
    -- Search match counter
    {
        "kevinhwang91/nvim-hlslens",
        branch = "main",
        keys = { "*", "#", "n", "N" },
        config = function()
            require("config.hlslens")
        end
    },
    -- Modern matchit
    { "andymass/vim-matchup",            event = "BufRead" },

    -----------------------------------------------------------------------
    -- Editing Enhancements
    -----------------------------------------------------------------------
    -- Auto pairs
    { "Raimondi/delimitMate",            event = "InsertEnter" },
    -- Comment toggle
    { "tpope/vim-commentary",            event = "VeryLazy" },
    -- Surround text objects
    { "machakann/vim-sandwich",          event = "VeryLazy" },
    -- Swap arguments
    { "machakann/vim-swap",              event = "VeryLazy" },
    -- Extended text objects
    { "wellle/targets.vim",              event = "VeryLazy" },
    -- Indent text object
    { "michaeljsmith/vim-indent-object", event = "VeryLazy" },
    -- Repeat plugin commands
    { "tpope/vim-repeat",                event = "VeryLazy" },
    -- Better escape
    { "nvim-zh/better-escape.vim",       event = { "InsertEnter" } },
    -- Autosave
    { "907th/vim-auto-save",             event = "InsertEnter" },
    -- Whitespace trimmer
    { "jdhao/whitespace.nvim",           event = "VeryLazy" },
    -- Unicode helper
    { "chrisbra/unicode.vim",            event = "VeryLazy" },

    -----------------------------------------------------------------------
    -- Git
    -----------------------------------------------------------------------
    -- Git conflict markers
    { "akinsho/git-conflict.nvim",       version = "*",            config = true },
    -- Git linker
    {
        "ruifm/gitlinker.nvim",
        event = "User InGitRepo",
        config = function()
            require("config.git-linker")
        end
    },
    -- Git log viewer
    { "rbong/vim-flog",        cmd = { "Flog" } },
    -- Better commit UI
    { "rhysd/committia.vim",   lazy = true },
    -- Diff viewer
    { "sindrets/diffview.nvim" },

    -----------------------------------------------------------------------
    -- Session & Workspace
    -----------------------------------------------------------------------
    -- Workspace manager
    {
        "natecraddock/workspaces.nvim",
        lazy = false,
        config = function()
            require("config.workspaces")
        end
    },
    -- Session manager
    {
        "natecraddock/sessions.nvim",
        lazy = false,
        config = function()
            require("config.sessions")
        end
    },
    -- Session obsession
    { "tpope/vim-obsession",      cmd = "Obsession" },

    -----------------------------------------------------------------------
    -- Utilities
    -----------------------------------------------------------------------
    -- Global note
    {
        "backdround/global-note.nvim",
        lazy = false,
        config = function()
            require("config.global-note")
        end
    },
    -- Yank history
    {
        "gbprod/yanky.nvim",
        cmd = { "YankyRingHistory" },
        config = function()
            require("config.yanky")
        end
    },
    -- Undo tree
    { "simnalamburt/vim-mundo",   cmd = { "MundoToggle", "MundoShow" } },
    -- Unix commands
    { "tpope/vim-eunuch",         cmd = { "Rename", "Delete" } },
    -- Async commands
    { "skywind3000/asyncrun.vim", lazy = true,                         cmd = { "AsyncRun" } },
    -- URL highlighter
    { "itchyny/vim-highlighturl", event = "VeryLazy" },
    -- URL opener
    {
        "sontungexpt/url-open",
        event = "VeryLazy",
        cmd = "URLOpenUnderCursor",
        config = function()
            local ok, url = pcall(require, "url-open"); if ok then url.setup({}) end
        end
    },
    -- Open in browser
    { "tyru/open-browser.vim", enabled = function() return vim.g.is_win or vim.g.is_mac end, event = "VeryLazy" },
    -- Quickfix enhancements
    {
        "kevinhwang91/nvim-bqf",
        ft = "qf",
        config = function()
            require("config.bqf")
        end
    },
    -- Tags viewer
    { "liuchengxu/vista.vim",  enabled = function() return utils.executable("ctags") end,    cmd = "Vista" },
    -- Cmdline completion
    { "gelguy/wilder.nvim",    build = ":UpdateRemotePlugins" },
    -- Vim script debug
    { "tpope/vim-scriptease",  cmd = { "Scriptnames", "Message", "Verbose" } },
    -- Todo manager
    { "2kabhishek/tdo.nvim",   dependencies = "2kabhishek/pickme.nvim",                      cmd = { "Tdo", "TdoEntry", "TdoNote", "TdoTodos", "TdoToggle", "TdoFind", "TdoFiles" }, keys = { "[t", "]t" } },

    -----------------------------------------------------------------------
    -- Language Specific
    -----------------------------------------------------------------------
    -- Lua annotations
    { "ii14/emmylua-nvim",     ft = "lua" },
    -- TOML syntax
    { "cespare/vim-toml",      ft = { "toml" },                                              branch = "main" },
    -- Tmux config
    { "tmux-plugins/vim-tmux", enabled = function() return utils.executable("tmux") end,     ft = { "tmux" } },
    -- Grammar checker
    { "rhysd/vim-grammarous",  enabled = function() return vim.g.is_mac end,                 ft = { "markdown" } },

    -----------------------------------------------------------------------
    -- Input Method
    -----------------------------------------------------------------------
    -- Mac keyboard switch
    {
        "lyokha/vim-xkbswitch",
        enabled = function()
            return vim.g.is_mac and
                utils.executable("xkbswitch")
        end,
        event = { "InsertEnter" }
    },
    -- Windows IME
    { "Neur1n/neuims",               enabled = function() return vim.g.is_win end,                   event = { "InsertEnter" } },

    -----------------------------------------------------------------------
    -- Browser Integration
    -----------------------------------------------------------------------
    -- Edit browser text
    {
        "glacambre/firenvim",
        enabled = function() return vim.g.is_win or vim.g.is_mac end,
        build = function()
            vim.fn["firenvim#install"](0)
        end,
        lazy = true
    },

    -----------------------------------------------------------------------
    -- Debugging
    -----------------------------------------------------------------------
    -- GDB integration
    { "sakhnik/nvim-gdb",            enabled = function() return vim.g.is_win or vim.g.is_linux end, build = { "bash install.sh" },    lazy = true },

    -----------------------------------------------------------------------
    -- Clipboard
    -----------------------------------------------------------------------
    -- OSC52 yank (SSH)
    { "ojroques/vim-oscyank",        enabled = function() return vim.g.is_linux end,                 cmd = { "OSCYank", "OSCYankReg" } },

    -----------------------------------------------------------------------
    -- Colorschemes
    -----------------------------------------------------------------------
    { "navarasu/onedark.nvim",       lazy = true },
    { "sainnhe/edge",                lazy = true },
    { "sainnhe/sonokai",             lazy = true },
    { "shaunsingh/nord.nvim",        lazy = true },
    { "sainnhe/everforest",          lazy = true },
    { "EdenEast/nightfox.nvim",      lazy = true },
    { "rebelot/kanagawa.nvim",       lazy = true },
    { "catppuccin/nvim",             as = "catppuccin",                                              lazy = true },
    { "tanvirtin/monokai.nvim",      lazy = true },
    { "marko-cerovac/material.nvim", lazy = true },
    { "NLKNguyen/papercolor-theme",  lazy = true },
    { "romgrk/doom-one.vim",         lazy = true },
    { "sonph/onehalf",               lazy = true },
}

local lazy_opts = {
    ui = {
        border = "rounded",
        title = "Plugin Manager",
        title_pos = "center",
    },
}

require("lazy").setup(plugin_specs, lazy_opts)
