local u = require 'utils'
local icons = require 'icons'

-- Load env.lua if it exists
local env_config = vim.fn.stdpath 'config' .. '/env.lua'
if vim.fn.filereadable(env_config) == 1 then
  dofile(env_config)
end

-- Globals required for starting lazy.nvim
vim.g.mapleader = ' '
vim.g.winblend = 10
vim.g.active_colorscheme = u.eval(function()
  local themery_installed, themery = pcall(require, 'themery')
  if themery_installed then
    return themery.getCurrentThemes().name
  else
    return 'default'
  end
end)

vim.lsp.enable {
  'ts_ls',
  'lua_ls',
}

vim.diagnostic.config {
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = icons.error,
      [vim.diagnostic.severity.WARN] = icons.warn,
      [vim.diagnostic.severity.INFO] = icons.info,
      [vim.diagnostic.severity.HINT] = icons.hint,
    },
  },
}

require 'plugins'
require 'statusline.statusline'
