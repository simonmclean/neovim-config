-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=main', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    return
  end
end
vim.opt.rtp:prepend(lazypath)

---Convenience function for lazy loading plugins with no config
---@param plugin string
---@param deps? string|string[]
---@return LazyPluginSpec
local function very_lazy(plugin, deps)
  return { plugin, dependencies = deps, event = 'VeryLazy' }
end

-- Plugins without configs are here.
-- Plugins with custom configs are imported from lua/plugin-configs/
local plugins = {
  -- Git integration
  very_lazy 'tpope/vim-fugitive',
  -- Makes more things dot repeatable
  very_lazy 'tpope/vim-repeat',
  -- Smart substitution that preserves casing
  very_lazy 'tpope/vim-abolish',
  -- JSDoc
  very_lazy 'heavenshell/vim-jsdoc',
  -- Vim sugar for common UNIX commands (Rename, Delete etc)
  very_lazy 'tpope/vim-eunuch',
}

---@type LazyConfig
local lazy_opts = {
  ui = {
    border = vim.g.winborder,
    title = ' Plugins ',
    backdrop = 100
  },
  dev = {
    path = '~/code',
  },
  install = {
    missing = true,
    colorscheme = { vim.g.active_colorscheme },
  },
  change_detection = {
    notify = false,
  },
}

vim.keymap.set('n', '<leader>l', ':Lazy<CR>', { desc = 'Lazy', silent = true })

require('lazy').setup({ plugins, { import = 'plugin-configs' }, { import = 'themes' } }, lazy_opts)
