local fn = vim.fn
local packer_bootstrap

local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
end

vim.cmd 'autocmd BufWritePost plugins.lua PackerCompile' -- Auto compile when there are changes in plugins.lua

local packer_config = {
  display = {
    open_fn = function()
      return require('packer.util').float({ border = 'single' })
    end
  }
}

return require('packer').startup({ function(use)
  --------------------------------------------------------------------------
  -- Git
  --------------------------------------------------------------------------
  use 'airblade/vim-gitgutter'
  use 'tpope/vim-fugitive'
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

  --------------------------------------------------------------------------
  -- UI
  --------------------------------------------------------------------------
  use {
    'nvim-lualine/lualine.nvim',
    require = { 'kyazdani42/nvim-web-devicons', opt = true }
  }
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
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v2.x',
    requires = {
      "nvim-lua/plenary.nvim",
      "kyazdani42/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
      {
        's1n7ax/nvim-window-picker',
        tag = 'v1.*',
        config = function()
          require 'window-picker'.setup({ other_win_hl_color = '#12131b' })
        end,
      }
    }
  }
  use 'ryanoasis/vim-devicons'
  use {
    'liuchengxu/vim-which-key',
    cmd = 'WhichKey'
  }
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
  use 'williamboman/nvim-lsp-installer'
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

  --------------------------------------------------------------------------
  -- Utils
  --------------------------------------------------------------------------
  use 'heavenshell/vim-jsdoc'
  use 'tpope/vim-eunuch'
  use 'tpope/vim-sensible'
  use 'tpope/vim-sleuth'
  use {
    "folke/persistence.nvim",
    event = "BufReadPre",
    module = "persistence",
    config = function()
      require("persistence").setup()
    end,
  }

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
