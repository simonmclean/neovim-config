local u = require 'utils'
local theme_name = 'rokyonight'

return u.theme_config(theme_name, {
  'folke/tokyonight.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    require('tokyonight').setup {
      style = 'moon', -- The theme comes in three styles, `storm`, `moon`, a darker variant `night`
    }
    vim.cmd.colorscheme(theme_name)
  end,
})
