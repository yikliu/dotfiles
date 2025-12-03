local utils = require("utils")
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    }
end
vim.opt.rtp:prepend(lazypath)

local plugin_specs = {

    -- LSP stuff --
    {
        "williamboman/mason.nvim",
        config = function()
            require("config.mason")
        end
    },

    {
        "neovim/nvim-lspconfig",
        event = { "BufRead", "BufNewFile" },
        config = function()
            require("config.nvim-lspconfig")
        end
    },

    {
        "williamboman/mason-lspconfig.nvim",
        event = { "BufRead", "BufNewFile" },
        config = function()
            require("config.mason-lspconfig")
        end
    },

    {
        "mfussenegger/nvim-jdtls",
        ft = "java",
        config = function()
            require("config.jdtls")
        end
    },

    {
        "mfussenegger/nvim-lint",
        event = { "BufRead", "BufNewFile" },
        config = function()
            require("config.nvim-lint")
        end
    },


    -- Kiro CLI integration (local plugin)
    {
        dir = vim.fn.stdpath("config") .. "/lua/config",
        name = "kiro",
        config = function()
            require("config.kiro").setup()
        end
    },

    { "vijaymarupudi/nvim-fzf" },

    {
        "mikavilpas/yazi.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        event = "VeryLazy",
        config = function()
            require("config.yazi")
        end
    },

    {
        's1n7ax/nvim-terminal',
        config = function()
            vim.o.hidden = true
            require('config.nvim-terminal')
        end
    },

    -- auto-completion engine
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-omni",
            "hrsh7th/cmp-emoji",
            "hrsh7th/cmp-buffer",           -- source for text in buffer
            "hrsh7th/cmp-path",             -- source for file system paths
            "L3MON4D3/LuaSnip",             -- snippet engine
            "saadparwaiz1/cmp_luasnip",     -- for autocompletion
            "rafamadriz/friendly-snippets", -- useful snippets
            "onsails/lspkind.nvim",         -- vs-code like pictograms
        },
        config = function()
            require("config.nvim-cmp")
        end,
    },

    -- swift format
    {
        "stevearc/conform.nvim",
        event = { "BufNewFile" },
        config = function()
            require("config.conform")
        end,
    },

    -- workspace
    {
        "natecraddock/workspaces.nvim",
        config = function()
            require("config.workspaces")
        end,
    },

    -- Session
    {
        "natecraddock/sessions.nvim",
        config = function()
            require("config.sessions")
        end,
    },

    {
        "nvim-lua/plenary.nvim"
    },

    {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        config = function()
            require("config.telescope")
        end,
        dependencies = {
            "nvim-telescope/telescope-symbols.nvim",
            "nvim-lua/plenary.nvim",
        },
    },

    -- Treesitter for syntax highlighting
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require("config.treesitter")
        end,
    },

    {
        "lukas-reineke/headlines.nvim",
        dependencies = "nvim-treesitter/nvim-treesitter",
        config = true, -- or `opts = {}`
    },

    { "machakann/vim-swap",    event = "VeryLazy" },

    -- Super fast buffer jump
    {
        "rlane/pounce.nvim",
        event = "VeryLazy",
        config = function()
            require("config.nvim-pounce")
        end,
    },

    -- Show match number and index for searching
    {
        "kevinhwang91/nvim-hlslens",
        branch = "main",
        keys = { "*", "#", "n", "N" },
        config = function()
            require("config.hlslens")
        end,
    },

    -- A list of colorscheme plugin you may want to try. Find what suits you.
    { "navarasu/onedark.nvim",       lazy = true },
    { "sainnhe/edge",                lazy = true },
    { "sainnhe/sonokai",             lazy = true },
    { "shaunsingh/nord.nvim",        lazy = true },
    { "sainnhe/everforest",          lazy = true },
    { "EdenEast/nightfox.nvim",      lazy = true },
    { "rebelot/kanagawa.nvim",       lazy = true },
    { "catppuccin/nvim",             as = "catppuccin", lazy = true },
    { "tanvirtin/monokai.nvim",      lazy = true },
    { "marko-cerovac/material.nvim", lazy = true },
    { "NLKNguyen/papercolor-theme",  lazy = true },
    { "romgrk/doom-one.vim",         lazy = true },
    { "sonph/onehalf",               lazy = true },

    { "nvim-tree/nvim-web-devicons", opts = {} },

    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        config = function()
            require("config.statusline")
        end,
    },

    {
        "akinsho/bufferline.nvim",
        event = { "BufEnter" },
        config = function()
            require("config.bufferline")
        end,
    },

    -- Highlight URLs inside vim
    { "itchyny/vim-highlighturl", event = "VimEnter" },

    -- notification plugin
    {
        "rcarriga/nvim-notify",
        event = "BufEnter",
        config = function()
            vim.defer_fn(function()
                require("config.nvim-notify")
            end, 2000)
        end,
    },

    -- fancy start screen
    {
        "nvimdev/dashboard-nvim",
        config = function()
            require("config.dashboard-nvim")
        end,
        dependencies = { { 'nvim-tree/nvim-web-devicons' } }
    },

    {
        "lukas-reineke/indent-blankline.nvim",
        event = "VeryLazy",
        main = 'ibl',
        config = function()
            require("config.indent-blankline")
        end,
    },

    -- Highlight URLs inside vim
    { "itchyny/vim-highlighturl", event = "VeryLazy" },

    -- notification plugin
    {
        "rcarriga/nvim-notify",
        event = "VeryLazy",
        config = function()
            require("config.nvim-notify")
        end,
    },

    -- For Windows and Mac, we can open an URL in the browser. For Linux, it may
    -- not be possible since we maybe in a server which disables GUI.
    {
        "tyru/open-browser.vim",
        enabled = function()
            if vim.g.is_win or vim.g.is_mac then
                return true
            else
                return false
            end
        end,
        event = "VeryLazy",
    },

    -- Only install these plugins if ctags are installed on the system
    -- show file tags in vim window
    {
        "liuchengxu/vista.vim",
        enabled = function()
            if utils.executable("ctags") then
                return true
            else
                return false
            end
        end,
        cmd = "Vista",
    },


    -- Automatic insertion and deletion of a pair of characters
    { "Raimondi/delimitMate",   event = "InsertEnter" },

    -- Comment plugin
    { "tpope/vim-commentary",   event = "VeryLazy" },

    -- Multiple cursor plugin like Sublime Text?
    -- 'mg979/vim-visual-multi'

    -- Autosave files on certain events
    { "907th/vim-auto-save",    event = "InsertEnter" },

    -- Show undo history visually
    { "simnalamburt/vim-mundo", cmd = { "MundoToggle", "MundoShow" } },

    -- better UI for some nvim actions
    { "stevearc/dressing.nvim" },

    -- Manage your yank history
    {
        "gbprod/yanky.nvim",
        cmd = { "YankyRingHistory" },
        config = function()
            require("config.yanky")
        end,
    },

    -- Handy unix command inside Vim (Rename, Move etc.)
    { "tpope/vim-eunuch",          cmd = { "Rename", "Delete" } },

    -- Repeat vim motions
    { "tpope/vim-repeat",          event = "VeryLazy" },

    { "nvim-zh/better-escape.vim", event = { "InsertEnter" } },

    {
        "lyokha/vim-xkbswitch",
        enabled = function()
            if vim.g.is_mac and utils.executable("xkbswitch") then
                return true
            end
            return false
        end,
        event = { "InsertEnter" },
    },

    {
        "Neur1n/neuims",
        enabled = function()
            if vim.g.is_win then
                return true
            end
            return false
        end,
        event = { "InsertEnter" },
    },

    -- Auto format tools
    { "sbdchd/neoformat",          cmd = { "Neoformat" } },

    -- Better git log display
    { "rbong/vim-flog",            cmd = { "Flog" } },

    { "akinsho/git-conflict.nvim", version = "*",        config = true },

    {
        "ruifm/gitlinker.nvim",
        event = "User InGitRepo",
        config = function()
            require("config.git-linker")
        end,
    },

    -- Better git commit experience
    { "rhysd/committia.vim",             lazy = true },

    {
        "sindrets/diffview.nvim"
    },

    {
        "kevinhwang91/nvim-bqf",
        ft = "qf",
        config = function()
            require("config.bqf")
        end,
    },

    {
        "folke/zen-mode.nvim",
        cmd = "ZenMode",
        config = function()
            require("config.zen-mode")
        end,
    },

    {
        "rhysd/vim-grammarous",
        enabled = function()
            if vim.g.is_mac then
                return true
            end
            return false
        end,
        ft = { "markdown" },
    },

    { "chrisbra/unicode.vim",            event = "VeryLazy" },

    -- Additional powerful text object for vim, this plugin should be studied
    -- carefully to use its full power
    { "wellle/targets.vim",              event = "VeryLazy" },

    -- Plugin to manipulate character pairs quickly
    { "machakann/vim-sandwich",          event = "VeryLazy" },

    -- Add indent object for vim (useful for languages like Python)
    { "michaeljsmith/vim-indent-object", event = "VeryLazy" },

    -- Since tmux is only available on Linux and Mac, we only enable these plugins
    -- for Linux and Mac
    -- .tmux.conf syntax highlighting and setting check
    {
        "tmux-plugins/vim-tmux",
        enabled = function()
            if utils.executable("tmux") then
                return true
            end
            return false
        end,
        ft = { "tmux" },
    },

    -- Modern matchit implementation
    { "andymass/vim-matchup",     event = "BufRead" },
    { "tpope/vim-scriptease",     cmd = { "Scriptnames", "Message", "Verbose" } },

    -- Asynchronous command execution
    { "skywind3000/asyncrun.vim", lazy = true,                                  cmd = { "AsyncRun" } },
    { "cespare/vim-toml",         ft = { "toml" },                              branch = "main" },

    -- Edit text area in browser using nvim
    {
        "glacambre/firenvim",
        enabled = function()
            if vim.g.is_win or vim.g.is_mac then
                return true
            end
            return false
        end,
        build = function()
            vim.fn["firenvim#install"](0)
        end,
        lazy = true,
    },

    -- Debugger plugin
    {
        "sakhnik/nvim-gdb",
        enabled = function()
            if vim.g.is_win or vim.g.is_linux then
                return true
            end
            return false
        end,
        build = { "bash install.sh" },
        lazy = true,
    },

    -- Session management plugin
    { "tpope/vim-obsession",   cmd = "Obsession" },

    {
        "ojroques/vim-oscyank",
        enabled = function()
            if vim.g.is_linux then
                return true
            end
            return false
        end,
        cmd = { "OSCYank", "OSCYankReg" },
    },

    -- The missing auto-completion for cmdline!
    {
        "gelguy/wilder.nvim",
        build = ":UpdateRemotePlugins",
    },

    -- showing keybindings
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        config = function()
            require("config.which-key")
        end,
    },

    -- show and trim trailing whitespaces
    { "jdhao/whitespace.nvim", event = "VeryLazy" },

    -- file explorer
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("config.nvim-tree")
        end,
    },

    { "ii14/emmylua-nvim", ft = "lua" },

    {
        "sontungexpt/url-open",
        event = "VeryLazy",
        cmd = "URLOpenUnderCursor",
        config = function()
            local status_ok, url_open = pcall(require, "url-open")
            if not status_ok then
                return
            end
            url_open.setup({})
        end,
    },

    {
        "2kabhishek/tdo.nvim",
        dependencies = '2kabhishek/pickme.nvim',
        cmd = { 'Tdo', 'TdoEntry', 'TdoNote', 'TdoTodos', 'TdoToggle', 'TdoFind', 'TdoFiles' },
        keys = { '[t', ']t' },
    }
}

-- configuration for lazy itself.
local lazy_opts = {
    ui = {
        border = "rounded",
        title = "Plugin Manager",
        title_pos = "center",
    },
}

require("lazy").setup(plugin_specs, lazy_opts)
