local u = require 'utils'

local plugins = {
  -- Directory browser
  {
    'simonmclean/triptych.nvim',
    event = 'VeryLazy',
    dir = '~/code/triptych',
    dev = false,
    dependencies = {
      'nvim-lua/plenary.nvim', -- required
      'nvim-tree/nvim-web-devicons', -- optional
    },
    config = require 'plugin-configs.triptych-config',
  },
  -- Ecosystem of small plugins
  {
    'echasnovski/mini.nvim',
    event = 'VeryLazy',
    config = require 'plugin-configs.mini-config',
  },
  -- Signcolumn icons for git
  -- Manage hunks (stage, unstage, undo, preview etc)
  {
    'lewis6991/gitsigns.nvim',
    config = require 'plugin-configs/gitsigns',
    event = 'VeryLazy',
  },
  -- Git wrapper and lightweight UI
  {
    'tpope/vim-fugitive',
    config = require 'plugin-configs.fugitive-config',
  },
  -- Advanced git diff UI
  {
    'sindrets/diffview.nvim',
    event = 'VeryLazy',
    dependencies = 'nvim-lua/plenary.nvim',
  },
  -- Adds :GBrowse to open repo in the browser
  {
    'tpope/vim-rhubarb',
    event = 'VeryLazy',
  },
  -- Motions for camelcase jumps
  {
    'bkad/camelcasemotion',
    config = require 'plugin-configs/camelcasemotion',
    event = 'VeryLazy',
  },
  -- Smart substitution that preserves casing
  {
    'tpope/vim-abolish',
    event = 'VeryLazy',
  },
  -- Comment and un-comment things
  {
    'tpope/vim-commentary',
    event = 'VeryLazy',
  },
  -- Makes more things dot repeatable
  {
    'tpope/vim-repeat',
    event = 'VeryLazy',
  },
  -- Edit surrounding characters (braces, quotes etc)
  {
    'tpope/vim-surround',
    event = 'VeryLazy',
  },
  -- Automatically create closing characters for things like (, {, " etc
  {
    'windwp/nvim-autopairs',
    config = require 'plugin-configs/nvim-autopairs',
    event = 'InsertEnter',
  },
  -- Floating preview window for the quickfix list
  -- Filter the quickfix list
  {
    'kevinhwang91/nvim-bqf',
    event = 'VeryLazy',
  },
  -- TODO: Am I using this?
  {
    'folke/flash.nvim',
    config = require 'plugin-configs/flash',
    event = 'VeryLazy',
  },
  -- Statusline framework with builtin components
  {
    'nvim-lualine/lualine.nvim',
    config = require 'plugin-configs/lualine',
    enabled = false
  },
  -- Fancy icons
  {
    'nvim-tree/nvim-web-devicons',
    config = require 'plugin-configs/nvim-web-devicons-config',
  },
  -- Dropdown completion UI and engine
  {
    'hrsh7th/nvim-cmp',
    event = 'VeryLazy',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/vim-vsnip',
      'hrsh7th/cmp-vsnip',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
    },
    config = require 'plugin-configs/nvim-cmp',
  },
  -- Floating UI that shows keybindings
  {
    'folke/which-key.nvim',
    config = require 'plugin-configs/which-key',
    event = 'VeryLazy',
  },
  -- Indentation lines
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    config = require 'plugin-configs/indent-blankline',
    event = 'VeryLazy',
  },
  -- Versitile UI for searching things
  {
    'nvim-telescope/telescope.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim' },
    config = require('plugin-configs.telescope').config,
  },
  -- Use telescope for code action menu with preview
  {
    'aznhe21/actions-preview.nvim',
    event = 'VeryLazy',
    config = require 'plugin-configs.actions-preview-config',
    dependencies = { 'nvim-telescope/telescope.nvim' },
  },
  -- Improve aesthetics for the tabline
  {
    'simonmclean/pretty-vanilla-tabline.nvim',
    config = require 'plugin-configs/pretty-vanilla-tabline',
  },
  -- Center a window
  {
    'shortcuts/no-neck-pain.nvim',
    config = require 'plugin-configs/no-neck-pain',
    event = 'VeryLazy',
  },
  -- TODO: Description
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = {
      'MunifTanjim/nui.nvim',
      {
        'rcarriga/nvim-notify',
        config = require 'plugin-configs/nvim-notify-config',
      },
    },
    config = require 'plugin-configs/noice',
  },
  -- UI and framework for managing language servers, formatters, linters etc
  {
    'williamboman/mason.nvim',
    build = ':MasonUpdate',
    event = 'VeryLazy',
  },
  -- Bridge between Mason and lsp-config
  {
    'williamboman/mason-lspconfig.nvim',
    event = 'VeryLazy',
  },
  -- Formatting and linting (eslint, prettier etc) that works separately from LSP
  {
    'jose-elias-alvarez/null-ls.nvim',
    config = require 'plugin-configs/null-ls',
    event = 'VeryLazy',
  },
  -- Out-of-the-box configs for language servers
  'neovim/nvim-lspconfig',
  -- Metals
  {
    'scalameta/nvim-metals',
    dependencies = { 'nvim-lua/plenary.nvim', 'mfussenegger/nvim-dap' },
    event = 'VeryLazy',
  },
  -- Treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = require 'plugin-configs/nvim-treesitter',
    dependencies = { 'windwp/nvim-ts-autotag' },
  },
  -- Debug Adapter Protocol (DAP)
  {
    'mfussenegger/nvim-dap',
    config = require 'plugin-configs/dap-config',
    event = 'VeryLazy',
  },
  -- Fancy UI for DAP
  {
    'rcarriga/nvim-dap-ui',
    dependencies = {
      'mfussenegger/nvim-dap',
      'nvim-neotest/nvim-nio',
    },
    config = require 'plugin-configs.dap-ui-config',
    event = 'VeryLazy',
  },
  -- Virtual text for DAP
  {
    'theHamsta/nvim-dap-virtual-text',
    config = function()
      require('nvim-dap-virtual-text').setup()
    end,
    event = 'VeryLazy',
  },
  -- JSDoc
  {
    'heavenshell/vim-jsdoc',
    event = 'VeryLazy',
  },
  -- Vim sugar for common UNIX commands (Rename, Delete etc)
  {
    'tpope/vim-eunuch',
    event = 'VeryLazy',
  },
  -- Automatic session save and restore
  {
    'olimorris/persisted.nvim',
    config = require 'plugin-configs/persisted',
  },
}

local themes = {
  'mhartington/oceanic-next',
  {
    'npxbr/gruvbox.nvim',
    dependencies = { 'rktjmp/lush.nvim' },
  },
  'kyazdani42/blue-moon',
  'bluz71/vim-nightfly-guicolors',
  'sainnhe/sonokai',
  'shaunsingh/moonlight.nvim',
  'tjdevries/colorbuddy.vim',
  'bkegley/gloombuddy',
  {
    'folke/tokyonight.nvim',
    config = require 'plugin-configs/tokyonight',
  },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
  },
}

local CURRENT_THEME_PLUGIN = 'folke/tokyonight.nvim'

-- Add the desired theme to plugins table
for _, theme in ipairs(themes) do
  local tbl = u.eval(function()
    if type(theme) == 'table' then
      return theme
    end
    return { theme }
  end)
  tbl.priority = 1000
  if tbl[1] == CURRENT_THEME_PLUGIN then
    table.insert(plugins, 1, tbl)
  end
end

require 'plugin-configs/lazy'(plugins)
