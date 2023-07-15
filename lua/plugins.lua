local plugins = {
   'lewis6991/gitsigns.nvim',
   'tpope/vim-fugitive',
   { 'sindrets/diffview.nvim', dependencies = 'nvim-lua/plenary.nvim' },
   'tpope/vim-rhubarb',
  'bkad/camelcasemotion',
  'tpope/vim-abolish',
  'tpope/vim-commentary',
  'tpope/vim-repeat',
  'tpope/vim-surround',
  'windwp/nvim-autopairs',
  'folke/flash.nvim',
  'nvim-lualine/lualine.nvim',
  'kyazdani42/nvim-web-devicons',
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/vim-vsnip',
      'hrsh7th/cmp-vsnip',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline'
    }
  },
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v2.x',
    dependencies = {
      "nvim-lua/plenary.nvim",
      "kyazdani42/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    }
  },
  'ryanoasis/vim-devicons',
  "folke/which-key.nvim",
  'lukas-reineke/indent-blankline.nvim',
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { { 'nvim-lua/popup.nvim' }, { 'nvim-lua/plenary.nvim' } }
  },
  {
    'weilbith/nvim-code-action-menu',
    cmd = 'CodeActionMenu',
  },
  'simonmclean/pretty-vanilla-tabline.nvim',
  'shortcuts/no-neck-pain.nvim',
  {
     'folke/noice.nvim',
     dependencies = {
       'MunifTanjim/nui.nvim',
       'rcarriga/nvim-notify'
     }
  },
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  'jose-elias-alvarez/null-ls.nvim',
  'neovim/nvim-lspconfig',
  { 'scalameta/nvim-metals', dependencies = { "nvim-lua/plenary.nvim" } },
  { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
  'heavenshell/vim-jsdoc',
  'tpope/vim-eunuch',
  'tpope/vim-sleuth',
  'olimorris/persisted.nvim',
  'mhartington/oceanic-next',
  { "npxbr/gruvbox.nvim", dependencies = { "rktjmp/lush.nvim" } },
  'kyazdani42/blue-moon',
  'bluz71/vim-nightfly-guicolors',
  'sainnhe/sonokai',
  'shaunsingh/moonlight.nvim',
  'tjdevries/colorbuddy.vim',
  'bkegley/gloombuddy',
  'folke/tokyonight.nvim',
  {
    "catppuccin/nvim",
    name = "catppuccin"
  }
}

local options = {
  ui = {
    border = 'single',
    title = ' Plugins '
  }
}

require "lazy".setup(plugins, options)
