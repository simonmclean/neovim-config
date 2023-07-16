local plugins = {
  {
    'lewis6991/gitsigns.nvim',
    config = require 'plugin-configs.gitsigns'
  },
  'tpope/vim-fugitive',
  { 'sindrets/diffview.nvim', event = "VeryLazy", dependencies = 'nvim-lua/plenary.nvim' },
  'tpope/vim-rhubarb',
  {
    'bkad/camelcasemotion',
    config = require 'plugin-configs.camelcasemotion'
  },
  'tpope/vim-abolish',
  'tpope/vim-commentary',
  'tpope/vim-repeat',
  'tpope/vim-surround',
  {
    'windwp/nvim-autopairs',
    config = require 'plugin-configs.nvim-autopairs'
  },
  {
    'folke/flash.nvim',
    config = require 'plugin-configs.flash'
  },
  {
    'nvim-lualine/lualine.nvim',
    config = require 'plugin-configs.lualine'
  },
  {
    'kyazdani42/nvim-web-devicons',
    config = require 'plugin-configs.nvim-web-devicons'
  },
  {
    'hrsh7th/nvim-cmp',
    event = 'VeryLazy',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/vim-vsnip',
      'hrsh7th/cmp-vsnip',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline'
    },
    config = require 'plugin-configs.nvim-cmp'
  },
  {
    'nvim-neo-tree/neo-tree.nvim',
    event = 'VeryLazy',
    branch = 'v2.x',
    dependencies = {
      "nvim-lua/plenary.nvim",
      "kyazdani42/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = require 'plugin-configs.neo-tree'
  },
  {
    'folke/which-key.nvim',
    config = require 'plugin-configs.which-key'
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    config = require 'plugin-configs.indent-blankline'
  },
  {
    'nvim-telescope/telescope.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim' },
    config = require 'plugin-configs.telescope'
  },
  {
    'weilbith/nvim-code-action-menu',
    cmd = 'CodeActionMenu',
    config = require 'plugin-configs.nvim-code-action-menu'
  },
  {
    'simonmclean/pretty-vanilla-tabline.nvim',
    config = require 'plugin-configs.pretty-vanilla-tabline'
  },
  {
    'shortcuts/no-neck-pain.nvim',
    config = require 'plugin-configs.no-neck-pain'
  },
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = {
      'MunifTanjim/nui.nvim',
      {
        'rcarriga/nvim-notify',
        config = require 'plugin-configs.nvim-notify'
      }
    },
    config = require 'plugin-configs.noice'
  },
  {
    'williamboman/mason.nvim',
    build = ':MasonUpdate'
  },
  "williamboman/mason-lspconfig.nvim",
  {
    'jose-elias-alvarez/null-ls.nvim',
    config = require 'plugin-configs.null-ls'
  },
  'neovim/nvim-lspconfig',
  { 'scalameta/nvim-metals',  dependencies = { "nvim-lua/plenary.nvim" } },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = require 'plugin-configs.nvim-treesitter'
  },
  'heavenshell/vim-jsdoc',
  'tpope/vim-eunuch',
  'tpope/vim-sleuth',
  {
    'olimorris/persisted.nvim',
    config = require 'plugin-configs.persisted'
  },
  {
    'mhartington/oceanic-next',
    lazy = true
  },
  {
    "npxbr/gruvbox.nvim",
    dependencies = { "rktjmp/lush.nvim" },
    lazy = true
  },
  {
    'kyazdani42/blue-moon',
    lazy = true
  },
  {
    'bluz71/vim-nightfly-guicolors',
    lazy = true
  },
  {
    'sainnhe/sonokai',
    lazy = true
  },
  {
    'shaunsingh/moonlight.nvim',
    lazy = true
  },
  {
    'tjdevries/colorbuddy.vim',
    lazy = true
  },
  {
    'bkegley/gloombuddy',
    lazy = true
  },
  {
    'folke/tokyonight.nvim',
    config = require 'plugin-configs.tokyonight',
    lazy = true
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true
  }
}

local options = {
  ui = {
    border = 'single',
    title = ' Plugins '
  }
}

require "lazy".setup(plugins, options)
