local u = require 'utils'
local theme_name = 'nord'

return u.theme_config(theme_name, {
  'shaunsingh/nord.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd.colorscheme(theme_name)
  end,
})
