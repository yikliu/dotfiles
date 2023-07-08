local api = vim.api
local fn = vim.fn

local utils = require("utils")

-- The root dir to install all plugins. Plugins are under opt/ or start/ sub-directory.
vim.g.plugin_home = fn.stdpath("data") .. "/site/pack/packer"

--- Install packer if it has not been installed.
--- Return:
--- true: if this is a fresh install of packer
--- false: if packer has been installed
local function packer_ensure_install()
  -- Where to install packer.nvim -- the package manager (we make it opt)
  local packer_dir = vim.g.plugin_home .. "/opt/packer.nvim"

  if fn.glob(packer_dir) ~= "" then
    return false
  end
  
  -- Auto-install packer in case it hasn't been installed.
  vim.api.nvim_echo({ { "Installing packer.nvim", "Type" } }, true, {})

  local packer_repo = "https://github.com/wbthomason/packer.nvim"
  local install_cmd = string.format("!git clone --depth=1 %s %s", packer_repo, packer_dir)
  vim.cmd(install_cmd)

  return true
end

local fresh_install = packer_ensure_install()

-- Load packer.nvim
vim.cmd("packadd packer.nvim")

local packer = require("packer")
local packer_util = require("packer.util")

-- check if firenvim is active
local firenvim_not_active = function()
  return not vim.g.started_by_firenvim
end

packer.startup {
  function(use)
    use { "wbthomason/packer.nvim", opt = true }

    use { "onsails/lspkind-nvim", event = "VimEnter" }
    -- auto-completion engine
    use { "hrsh7th/nvim-cmp", after = "lspkind-nvim", config = [[require('config.nvim-cmp')]] }

    -- nvim-cmp completion sources
    use { "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" }
    use { "hrsh7th/cmp-path", after = "nvim-cmp" }
    use { "hrsh7th/cmp-buffer", after = "nvim-cmp" }
    use { "hrsh7th/cmp-omni", after = "nvim-cmp" }

    if vim.g.is_mac then
      use { "hrsh7th/cmp-emoji", after = "nvim-cmp" }
    end

    use {
      's1n7ax/nvim-terminal',
      config = function()
          vim.o.hidden = true
          require('nvim-terminal').setup({
            window = {
                -- Do `:h :botright` for more information
                -- NOTE: width or height may not be applied in some "pos"
                position = 'botright',
                -- Do `:h split` for more information
                split = 'sp',
                -- Width of the terminal
                width = 50,
                -- Height of the terminal
                height = 20,
            },

            -- keymap to disable all the default keymaps
            disable_default_keymaps = false,
            -- keymap to toggle open and close terminal window
            toggle_keymap = '<leader>;',
            -- increase the window height by when you hit the keymap
            window_height_change_amount = 2,
            -- increase the window width by when you hit the keymap
            window_width_change_amount = 2,
            -- keymap to increase the window width
            increase_width_keymap = '<leader><leader>+',
            -- keymap to decrease the window width
            decrease_width_keymap = '<leader><leader>-',
            -- keymap to increase the window height
            increase_height_keymap = '<leader>+',
            -- keymap to decrease the window height
            decrease_height_keymap = '<leader>-',
            terminals = {
                -- keymaps to open nth terminal
                {keymap = '<leader>1'},
                {keymap = '<leader>2'},
                {keymap = '<leader>3'},
                {keymap = '<leader>4'},
                {keymap = '<leader>5'},
            },
          })
      end,
    }

    -- nvim-lsp configuration (it relies on cmp-nvim-lsp, so it should be loaded after cmp-nvim-lsp).
    use { "neovim/nvim-lspconfig", after = "cmp-nvim-lsp", config = [[require('config.lsp')]] }

    -- nvim-jdtls --
    use 'mfussenegger/nvim-jdtls'

    if vim.g.is_mac then
      use {
        "nvim-treesitter/nvim-treesitter",
        event = "BufEnter",
        run = ":TSUpdate",
        config = [[require('config.treesitter')]],
      }
    end

    -- Python indent (follows the PEP8 style)
    use { "Vimjas/vim-python-pep8-indent", ft = { "python" } }

    -- Python-related text object
    use { "jeetsukumaran/vim-pythonsense", ft = { "python" } }

    use { "machakann/vim-swap", event = "VimEnter" }

    -- File search, tag search and more
    if vim.g.is_win then
        use { "Yggdroot/LeaderF", cmd = "Leaderf" }
    else
      use { "Yggdroot/LeaderF", cmd = "Leaderf", run = ":LeaderfInstallCExtension" }
    end

    use {
      "nvim-telescope/telescope.nvim",
      requires = { { "nvim-lua/plenary.nvim" } },
    }

    use { "renerocksai/calendar-vim" } 
    

    -- hop 
    use {
      "phaazon/hop.nvim",
      event = "VimEnter",
      config = function()
        vim.defer_fn(function()
          require("config.nvim_hop")
        end, 2000)
      end,
    }

    -- Show match number and index for searching
    use {
      "kevinhwang91/nvim-hlslens",
      branch = "main",
      keys = { { "n", "*" }, { "n", "#" }, { "n", "n" }, { "n", "N" } },
      config = [[require('config.hlslens')]],
    }

    use {
        'renerocksai/telekasten.nvim',
        requires = {
          'nvim-telescope/telescope.nvim',
          'nvim-lua/plenary.nvim'
        },
        config = [[require('config.telekasten')]]

    }

    -- A list of colorscheme plugin you may want to try. Find what suits you.
    use { "navarasu/onedark.nvim", opt = true }
    use { "sainnhe/edge", opt = true }
    use { "sainnhe/sonokai", opt = true }
    use { "sainnhe/gruvbox-material", opt = true }
    use { "shaunsingh/nord.nvim", opt = true }
    use { "sainnhe/everforest", opt = true }
    use { "EdenEast/nightfox.nvim", opt = true }
    use { "rebelot/kanagawa.nvim", opt = true }
    use { "catppuccin/nvim", as = "catppuccin", opt = true }
    use { "tanvirtin/monokai.nvim", opt = true }
    use { "marko-cerovac/material.nvim", opt = true }
    use { "NLKNguyen/papercolor-theme", opt = true }
    use { "nvim-tree/nvim-web-devicons", event = "VimEnter" }

    use {
      "nvim-lualine/lualine.nvim",
      event = "VimEnter",
      cond = firenvim_not_active,
      config = [[require('config.statusline')]],
    }

    use { "akinsho/bufferline.nvim", event = "VimEnter",
      cond = firenvim_not_active,
      config = [[require('config.bufferline')]] }

    -- fancy start screen
    use { "nvimdev/dashboard-nvim", event = "VimEnter",
      cond = firenvim_not_active,
      config = [[require('config.dashboard-nvim')]]
    }

    use {
      "lukas-reineke/indent-blankline.nvim",
      event = "VimEnter",
      config = [[require('config.indent-blankline')]],
    }

    -- Highlight URLs inside vim
    use { "itchyny/vim-highlighturl", event = "VimEnter" }

    -- notification plugin
    use {
      "rcarriga/nvim-notify",
      event = "BufEnter",
      config = function()
        vim.defer_fn(function()
          require("config.nvim-notify")
        end, 2000)
      end,
    }

    -- For Windows and Mac, we can open an URL in the browser. For Linux, it may
    -- not be possible since we maybe in a server which disables GUI.
    if vim.g.is_win or vim.g.is_mac then
      -- open URL in browser
      use { "tyru/open-browser.vim", event = "VimEnter" }
    end

    -- Handy unix command inside Vim (Rename, Move etc.)
    use { "tpope/vim-eunuch", cmd = { "Rename", "Delete" } }

    -- Repeat vim motions
    use { "tpope/vim-repeat", event = "VimEnter" }

    -- Another markdown plugin
    use { "preservim/vim-markdown", ft = { "markdown" } }

    -- Faster footnote generation
    use { "vim-pandoc/vim-markdownfootnotes", ft = { "markdown" } }

    -- Markdown previewing (only for Mac and Windows)
    if vim.g.is_win or vim.g.is_mac then
      use {
        "iamcco/markdown-preview.nvim",
        run = "cd app && npm install",
        ft = { "markdown" },
      }
    end

    use { "folke/zen-mode.nvim", cmd = "ZenMode", config = [[require('config.zen-mode')]] }

    if vim.g.is_mac then
      use { "rhysd/vim-grammarous", ft = { "markdown" } }
    end

    use { "chrisbra/unicode.vim", event = "VimEnter" }

    -- Additional powerful text object for vim, this plugin should be studied
    -- carefully to use its full power
    use { "wellle/targets.vim", event = "VimEnter" }

    -- Plugin to manipulate character pairs quickly
    use { "machakann/vim-sandwich", event = "VimEnter" }

    -- Add indent object for vim (useful for languages like Python)
    use { "michaeljsmith/vim-indent-object", event = "VimEnter" }

    -- Only use these plugin on Windows and Mac and when LaTeX is installed
    if utils.executable("latex") then
      use { "lervag/vimtex", ft = { "tex" } }
    end

    -- Since tmux is only available on Linux and Mac, we only enable these plugins
    -- for Linux and Mac
    if utils.executable("tmux") then
      -- .tmux.conf syntax highlighting and setting check
      use { "tmux-plugins/vim-tmux", ft = { "tmux" } }
    end

    -- Modern matchit implementation
    use { "andymass/vim-matchup", event = "VimEnter" }

    use { "tpope/vim-scriptease", cmd = { "Scriptnames", "Message", "Verbose" } }

    -- Asynchronous command execution
    use { "skywind3000/asyncrun.vim", opt = true, cmd = { "AsyncRun" } }

    use { "cespare/vim-toml", ft = { "toml" }, branch = "main" }

    -- The missing auto-completion for cmdline!
    use { "gelguy/wilder.nvim", opt = true, setup = [[vim.cmd('packadd wilder.nvim')]] }

    -- showing keybindings
    use {
      "folke/which-key.nvim",
      event = "VimEnter",
      config = function()
        vim.defer_fn(function()
          require("config.which-key")
        end, 2000)
      end,
    }

    -- file explorer
    use {
      "nvim-tree/nvim-tree.lua",
      requires = { "nvim-tree/nvim-web-devicons" },
      config = [[require('config.nvim-tree')]],
    }

  end,
  config = {
    max_jobs = 16,
    compile_path = packer_util.join_paths(fn.stdpath("data"), "site", "lua", "packer_compiled.lua"),
  },
}

-- For fresh install, we need to install plugins. Otherwise, we just need to require `packer_compiled.lua`.
if fresh_install then
  -- We run packer.sync() here, because only after packer.startup, can we know which plugins to install.
  -- So plugin installation should be done after the startup process.
  packer.sync()
else
  local status, _ = pcall(require, "packer_compiled")
  if not status then
    local msg = "File packer_compiled.lua not found: run PackerSync to fix!"
    vim.notify(msg, vim.log.levels.ERROR, { title = "nvim-config" })
  end
end

-- Auto-generate packer_compiled.lua file
api.nvim_create_autocmd({ "BufWritePost" }, {
  pattern = "*/nvim/lua/plugins.lua",
  group = api.nvim_create_augroup("packer_auto_compile", { clear = true }),
  callback = function(ctx)
    local cmd = "source " .. ctx.file
    vim.cmd(cmd)
    vim.cmd("PackerCompile")
    vim.notify("PackerCompile done!", vim.log.levels.INFO, { title = "Nvim-config" })
  end,
})
