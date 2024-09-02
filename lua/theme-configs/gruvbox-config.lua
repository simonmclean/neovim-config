local u = require 'utils'
local theme_name = 'gruvbox'

return u.theme_config(theme_name, {
  'ellisonleao/gruvbox.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd.colorscheme(theme_name)
  end,
})
