local map = require('utils').keymap_set

vim.g.active_colorscheme = 'nord'

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

---Convenience function for lazy loading plugins with no config
---@param plugin string
---@param deps? string|string[]
---@return LazyPluginSpec
local function very_lazy(plugin, deps)
  return { plugin, dependencies = deps, event = "VeryLazy" }
end

-- Plugins without configs are here.
-- Plugins with custom configs are imported from lua/plugin-configs/
local plugins = {
  -- Makes more things dot repeatable
  very_lazy 'tpope/vim-repeat',
  -- Edit surrounding characters (braces, quotes etc)
  very_lazy 'tpope/vim-surround',
  -- Adds :GBrowse to open repo in the browser
  very_lazy 'tpope/vim-rhubarb',
  -- Advanced git diff UI
  very_lazy('sindrets/diffview.nvim', 'nvim-lua/plenary.nvim'),
  -- Smart substitution that preserves casing
  very_lazy 'tpope/vim-abolish',
  -- Out-of-the-box configs for language servers
  'neovim/nvim-lspconfig',
  -- Metals
  very_lazy('scalameta/nvim-metals', { 'nvim-lua/plenary.nvim', 'mfussenegger/nvim-dap' }),
  -- JSDoc
  very_lazy 'heavenshell/vim-jsdoc',
  -- Vim sugar for common UNIX commands (Rename, Delete etc)
  very_lazy 'tpope/vim-eunuch',
}

---@type LazyConfig
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
    colorscheme = { vim.g.active_colorscheme or 'default' },
  },
  change_detection = {
    notify = false,
  },
}

map('n', '<leader>l', ':Lazy<CR>')

require('lazy').setup({ plugins, { import = 'plugin-configs' }, { import = 'theme-configs' } }, lazy_opts)
