local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
local packer_bootstrap
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim',
    install_path })
  vim.cmd [[packadd packer.nvim]]
end

local packer_config = {
  display = {
    open_fn = function()
      return require('packer.util').float({ border = 'single' })
    end
  }
}

return require('packer').startup({ function(use)
  use 'wbthomason/packer.nvim'

  --------------------------------------------------------------------------
  -- Git
  --------------------------------------------------------------------------
  use {
    'lewis6991/gitsigns.nvim',
    tag = "release",
  }
  use 'tpope/vim-fugitive'
  use { 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' }
  use 'tpope/vim-rhubarb'

  --------------------------------------------------------------------------
  -- Better editing
  --------------------------------------------------------------------------
  use 'bkad/camelcasemotion'
  use 'mattn/emmet-vim'
  use 'tpope/vim-abolish'
  use 'tpope/vim-commentary'
  use 'tpope/vim-repeat'
  use 'tpope/vim-surround'
  use 'windwp/nvim-autopairs'
  use 'ggandor/leap.nvim'

  --------------------------------------------------------------------------
  -- FANCY UI
  --------------------------------------------------------------------------
  use 'nvim-lualine/lualine.nvim'
  use 'kyazdani42/nvim-web-devicons'
  use {
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/vim-vsnip',
      'hrsh7th/cmp-vsnip',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline'
    }
  }
  use {
    's1n7ax/nvim-window-picker',
    tag = 'v1.*',
  }
  use {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v2.x',
    requires = {
      "nvim-lua/plenary.nvim",
      "kyazdani42/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    }
  }
  use 'ryanoasis/vim-devicons'
  -- Disabling this as until I figure out how to completely disable it in insert mode
  -- Or at least stop it from being triggered by <space>
  -- use {
  --   "folke/which-key.nvim",
  --   config = function()
  --     require("which-key").setup {
  --       -- your configuration comes here
  --       -- or leave it empty to use the default settings
  --       -- refer to the configuration section below
  --     }
  --   end
  -- }
  use 'lukas-reineke/indent-blankline.nvim'
  -- use '~/code/tryptic'
  use {
    'nvim-telescope/telescope.nvim',
    requires = { { 'nvim-lua/popup.nvim' }, { 'nvim-lua/plenary.nvim' } }
  }
  use {
    'weilbith/nvim-code-action-menu',
    cmd = 'CodeActionMenu',
  }

  --------------------------------------------------------------------------
  -- LSP
  --------------------------------------------------------------------------
  use "williamboman/mason.nvim"
  use "williamboman/mason-lspconfig.nvim"
  use 'jose-elias-alvarez/null-ls.nvim'
  use 'neovim/nvim-lspconfig'
  use({ 'scalameta/nvim-metals', requires = { "nvim-lua/plenary.nvim" } })

  --------------------------------------------------------------------------
  -- Debugging
  --------------------------------------------------------------------------
  use 'mfussenegger/nvim-dap'
  use {
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("trouble").setup {}
    end
  }

  --------------------------------------------------------------------------
  -- Treesitter
  --------------------------------------------------------------------------
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use 'nvim-treesitter/nvim-treesitter-textobjects'

  --------------------------------------------------------------------------
  -- Utils
  --------------------------------------------------------------------------
  use 'heavenshell/vim-jsdoc'
  use 'tpope/vim-eunuch'
  use 'tpope/vim-sensible'
  use 'tpope/vim-sleuth'
  use 'olimorris/persisted.nvim'

  --------------------------------------------------------------------------
  -- Themes
  --------------------------------------------------------------------------
  use 'mhartington/oceanic-next'
  use { "npxbr/gruvbox.nvim", requires = { "rktjmp/lush.nvim" } } -- doesn't yet support airline
  use 'kyazdani42/blue-moon'
  use 'bluz71/vim-nightfly-guicolors'
  use 'sainnhe/sonokai'
  use 'shaunsingh/moonlight.nvim'
  use 'tjdevries/colorbuddy.vim'
  use 'bkegley/gloombuddy'
  use 'folke/tokyonight.nvim'
  use {
    "catppuccin/nvim",
    as = "catppuccin"
  }

  if packer_bootstrap then
    require('packer').sync()
  end
end, config = packer_config })
