local plugins = {
  -- Signcolumn icons for git
  -- Manage hunks (stage, unstage, undo, preview etc)
  {
    'lewis6991/gitsigns.nvim',
    config = require 'plugin-configs/gitsigns',
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
    event = 'VeryLazy',
  },
  -- Floating preview window for the quickfix list
  -- Filter the quickfix list
  {
    'kevinhwang91/nvim-bqf',
    event = 'VeryLazy'
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
  },
  -- Fancy icons
  {
    'nvim-tree/nvim-web-devicons',
    config = require 'plugin-configs/nvim-web-devicons',
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
  -- Directory browser
  {
    'simonmclean/tryptic',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    dev = true,
    config = function()
      require('tryptic').setup()
    end,
  },
  -- Floating UI that shows keybindings
  {
    'folke/which-key.nvim',
    config = require 'plugin-configs/which-key',
    event = 'VeryLazy',
  },
  -- Indentation lines
  -- TODO: This has stopped working
  {
    'lukas-reineke/indent-blankline.nvim',
    config = require 'plugin-configs/indent-blankline',
  },
  -- Versitile UI for searching things
  {
    'nvim-telescope/telescope.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim' },
    config = require 'plugin-configs/telescope',
  },
  -- Dropdown-style menu for LSP actions
  {
    'weilbith/nvim-code-action-menu',
    cmd = 'CodeActionMenu',
    config = require 'plugin-configs/nvim-code-action-menu',
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
        config = require 'plugin-configs/nvim-notify',
      },
    },
    config = require 'plugin-configs/noice',
  },
  -- UI and framework for managing language servers, formatters, linters etc
  {
    'williamboman/mason.nvim',
    build = ':MasonUpdate',
  },
  -- Bridge between Mason and lsp-config
  'williamboman/mason-lspconfig.nvim',
  -- Formatting and linting (eslint, prettier etc) that works separately from LSP
  {
    'jose-elias-alvarez/null-ls.nvim',
    config = require 'plugin-configs/null-ls',
  },
  -- Out-of-the-box configs for language servers
  'neovim/nvim-lspconfig',
  -- UI for navigating LSP workspace diagnostics
  {
    'folke/trouble.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = require 'plugin-configs/trouble-config',
  },
  -- Metals
  { 'scalameta/nvim-metals', dependencies = { 'nvim-lua/plenary.nvim', 'mfussenegger/nvim-dap' } },
  -- Treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = require 'plugin-configs/nvim-treesitter',
  },
  -- Debug Adapter Protocol (DAP)
  {
    'mfussenegger/nvim-dap',
    config = require 'plugin-configs/dap-config',
  },
  -- Fancy UI for DAP
  {
    'rcarriga/nvim-dap-ui',
    dependencies = 'mfussenegger/nvim-dap',
    config = require 'plugin-configs.dap-ui-config',
  },
  -- Virtual text for DAP
  {
    'theHamsta/nvim-dap-virtual-text',
    config = function()
      require('nvim-dap-virtual-text').setup()
    end,
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
  -- Heuristically detect the shiftwidth and expandtab for a file
  -- TODO: Is this still helping?
  {
    'tpope/vim-sleuth',
    event = 'VeryLazy',
  },
  -- Automatic session save and restore
  {
    'olimorris/persisted.nvim',
    config = require 'plugin-configs/persisted',
  },
  -- Themes
  {
    'mhartington/oceanic-next',
    lazy = true,
  },
  {
    'npxbr/gruvbox.nvim',
    dependencies = { 'rktjmp/lush.nvim' },
    lazy = true,
  },
  {
    'kyazdani42/blue-moon',
    lazy = true,
  },
  {
    'bluz71/vim-nightfly-guicolors',
    lazy = true,
  },
  {
    'sainnhe/sonokai',
    lazy = true,
  },
  {
    'shaunsingh/moonlight.nvim',
    lazy = true,
  },
  {
    'tjdevries/colorbuddy.vim',
    lazy = true,
  },
  {
    'bkegley/gloombuddy',
    lazy = true,
  },
  {
    'folke/tokyonight.nvim',
    config = require 'plugin-configs/tokyonight',
    lazy = true,
  },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = true,
  },
}

require 'plugin-configs/lazy'(plugins)
