local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  }
end

vim.opt.rtp:prepend(lazypath)

-- Plugins without configs are here.
-- Plugins with custom configs are imported from lua/plugin-configs/
local plugins = {
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
  -- Adds :GBrowse to open repo in the browser
  {
    'tpope/vim-rhubarb',
    event = 'VeryLazy',
  },
  -- Advanced git diff UI
  {
    'sindrets/diffview.nvim',
    event = 'VeryLazy',
    dependencies = 'nvim-lua/plenary.nvim',
  },
  -- Smart substitution that preserves casing
  {
    'tpope/vim-abolish',
    event = 'VeryLazy',
  },
  -- Floating preview window for the quickfix list
  -- Filter the quickfix list
  {
    'kevinhwang91/nvim-bqf',
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
  -- Virtual text for DAP
  {
    'theHamsta/nvim-dap-virtual-text',
    opts = {},
    event = 'VeryLazy',
  },
  -- Configures the Lua LS to get type information for nvim APIs, and plugins
  {
    'folke/neodev.nvim',
    opts = {},
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
}

local lazy_opts = {
  ui = {
    border = 'single',
    title = ' Plugins ',
  },
  dev = {
    path = '~/code',
  },
  install = {
    missing = true,
    colorscheme = { 'tokyonight' },
  },
  change_detection = {
    notify = false,
  },
}

vim.keymap.set('n', '<leader>l', ':Lazy<CR>', { silent = true })

require('lazy').setup({ plugins, { import = 'plugin-configs' } }, lazy_opts)
