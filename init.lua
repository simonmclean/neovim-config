local u = require 'utils'
local icons = require 'icons'

vim.g.mapleader = ' '
vim.g.winblend = 10
vim.g.winborder = 'rounded'
vim.g.active_colorscheme = u.eval(function()
  local themery_installed, themery = pcall(require, 'themery')
  if themery_installed then
    return themery.getCurrentThemes().name
  else
    return 'default'
  end
end)

vim.diagnostic.config {
  virtual_text = { enabled = true },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = icons.error,
      [vim.diagnostic.severity.WARN] = icons.warn,
      [vim.diagnostic.severity.INFO] = icons.info,
      [vim.diagnostic.severity.HINT] = icons.hint,
    },
  },
}

require 'git.status'.setup()
require 'plugins'
require 'statusline.statusline'
