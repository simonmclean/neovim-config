local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  execute('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
  execute 'packadd packer.nvim'
end

vim.cmd 'autocmd BufWritePost plugins.lua PackerCompile' -- Auto compile when there are changes in plugins.lua

return require('packer').startup(function(use)
	-- Git
	use 'airblade/vim-gitgutter'
	use 'tpope/vim-fugitive'
	use 'tpope/vim-rhubarb'
	-- Better editing
	use 'bkad/camelcasemotion'
	use 'mattn/emmet-vim'
	use 'tpope/vim-commentary'
	use 'tpope/vim-repeat'
	use 'tpope/vim-surround'
	-- UI
	use 'itchyny/lightline.vim'
	-- use 'vim-airline/vim-airline'
	-- use 'vim-airline/vim-airline-themes'
	use {
		'liuchengxu/vim-which-key',
		cmd = 'WhichKey'
	}
	use {
		'lukas-reineke/indent-blankline.nvim',
		branch = 'lua'
	}
	use '~/code/tryptic'
	use {
		'nvim-telescope/telescope.nvim',
		requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
	}
	-- LSP
	use 'neovim/nvim-lspconfig'
	use 'kabouzeid/nvim-lspinstall'
	use 'hrsh7th/nvim-compe'
	use {
		'RishabhRD/nvim-lsputils',
		requires = {{'RishabhRD/popfix'}}
	}
	-- use { 'neoclide/coc.nvim', branch = 'release' }
	-- Tree Sitter
	use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
	-- Language support
	-- use 'sheerun/vim-polyglot'
	use 'mustache/vim-mustache-handlebars'
	use {
		'styled-components/vim-styled-components',
		branch = 'main'
	}
	use 'scalameta/nvim-metals'
	use 'vim-scripts/svg.vim'
	-- Utils
	use 'heavenshell/vim-jsdoc'
	use 'tpope/vim-eunuch'
	use 'tpope/vim-sensible'
	use 'tpope/vim-sleuth'
	-- Themes
	use 'mhartington/oceanic-next'
	use {"npxbr/gruvbox.nvim", requires = {"rktjmp/lush.nvim"}} -- doesn't yet support airline
	use 'kyazdani42/blue-moon'
	use 'bluz71/vim-nightfly-guicolors'
	use 'sainnhe/sonokai'
end)
