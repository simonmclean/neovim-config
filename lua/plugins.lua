local plugins = {
  {
    'lewis6991/gitsigns.nvim',
    config = require 'plugin-configs/gitsigns'
  },
  {
    'tpope/vim-fugitive',
  },
  {
    'sindrets/diffview.nvim',
    event = "VeryLazy",
    dependencies = 'nvim-lua/plenary.nvim'
  },
  {
    'tpope/vim-rhubarb',
    event = 'VeryLazy'
  },
  {
    'bkad/camelcasemotion',
    config = require 'plugin-configs/camelcasemotion',
    event = 'VeryLazy'
  },
  {
    'tpope/vim-abolish',
    event = 'VeryLazy'
  },
  {
    'tpope/vim-commentary',
    event = 'VeryLazy'
  },
  {
    'tpope/vim-repeat',
    event = 'VeryLazy'
  },
  {
    'tpope/vim-surround',
    event = 'VeryLazy'
  },
  {
    'windwp/nvim-autopairs',
    config = require 'plugin-configs/nvim-autopairs',
    event = 'VeryLazy'
  },
  {
    'folke/flash.nvim',
    config = require 'plugin-configs/flash',
    event = 'VeryLazy'
  },
  {
    'nvim-lualine/lualine.nvim',
    config = require 'plugin-configs/lualine'
  },
  {
    'nvim-tree/nvim-web-devicons',
    config = require 'plugin-configs/nvim-web-devicons'
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
    config = require 'plugin-configs/nvim-cmp'
  },
  {
    'simonmclean/tryptic',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons'
    },
    dev = true,
    config = function()
      require 'tryptic'.setup()
    end
  },
  {
    'folke/which-key.nvim',
    config = require 'plugin-configs/which-key',
    event = 'VeryLazy'
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    config = require 'plugin-configs/indent-blankline'
  },
  {
    'nvim-telescope/telescope.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim' },
    config = require 'plugin-configs/telescope'
  },
  {
    'weilbith/nvim-code-action-menu',
    cmd = 'CodeActionMenu',
    config = require 'plugin-configs/nvim-code-action-menu'
  },
  {
    'simonmclean/pretty-vanilla-tabline.nvim',
    config = require 'plugin-configs/pretty-vanilla-tabline'
  },
  {
    'shortcuts/no-neck-pain.nvim',
    config = require 'plugin-configs/no-neck-pain',
    event = 'VeryLazy'
  },
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = {
      'MunifTanjim/nui.nvim',
      {
        'rcarriga/nvim-notify',
        config = require 'plugin-configs/nvim-notify'
      }
    },
    config = require 'plugin-configs/noice'
  },
  {
    'williamboman/mason.nvim',
    build = ':MasonUpdate'
  },
  "williamboman/mason-lspconfig.nvim",
  {
    'jose-elias-alvarez/null-ls.nvim',
    config = require 'plugin-configs/null-ls'
  },
  'neovim/nvim-lspconfig',
  {
    'folke/trouble.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = require 'plugin-configs/trouble-config'
  },
  { 'scalameta/nvim-metals', dependencies = { "nvim-lua/plenary.nvim", "mfussenegger/nvim-dap" } },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = require 'plugin-configs/nvim-treesitter'
  },
  {
    'mfussenegger/nvim-dap',
    config = require 'plugin-configs/dap-config'
  },
  {
    'rcarriga/nvim-dap-ui',
    dependencies = 'mfussenegger/nvim-dap',
    config = require 'plugin-configs.dap-ui-config'
  },
  {
    'theHamsta/nvim-dap-virtual-text',
    config = function ()
      require 'nvim-dap-virtual-text'.setup()
    end
  },
  {
    'heavenshell/vim-jsdoc',
    event = 'VeryLazy'
  },
  {
    'tpope/vim-eunuch',
    event = 'VeryLazy'
  },
  {
    'tpope/vim-sleuth',
    event = 'VeryLazy'
  },
  {
    'olimorris/persisted.nvim',
    config = require 'plugin-configs/persisted'
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
    config = require 'plugin-configs/tokyonight',
    lazy = true
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true
  }
}

require 'plugin-configs/lazy'(plugins)
