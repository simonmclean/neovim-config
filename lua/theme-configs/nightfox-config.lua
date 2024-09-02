local u = require 'utils'
local theme_name = 'nightfox'

return u.theme_config(theme_name, {
  'EdenEast/nightfox.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd.colorscheme(theme_name)
  end,
})
