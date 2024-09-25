local u = require 'utils'
local theme_name = 'nord'

return u.theme_config(theme_name, {
  -- Using my fork until this PR gets merged
  -- https://github.com/shaunsingh/nord.nvim/pull/160
  'simonmclean/nord.nvim',
  branch = 'winbar',
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd.colorscheme(theme_name)
  end,
})
