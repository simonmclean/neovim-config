local u = require 'utils'
local icons = require 'icons'
local system_deps = require 'system_deps'

system_deps.ensure_installed {
  'node',
  'npm',
  'rg', -- ripgrep
  'wget',
  {
    'tree-sitter-cli',
    check_type = 'npm',
    install = system_deps.installers.npm('tree-sitter-cli'),
  },
}

vim.g.mapleader = ' '

-- user settings
vim.g._settings_winblend = 10
vim.g._settings_winborder = 'rounded'
vim.g._settings_transparent_background = true
vim.g._settings_active_colorscheme = u.eval(function()
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

require('git.status').setup()
require 'plugins'
require 'statusline.statusline'
