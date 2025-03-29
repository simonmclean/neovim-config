local u = require 'utils'
local layout_config = require('plugin-configs.telescope').layout_config

return {
  'aznhe21/actions-preview.nvim',
  event = 'VeryLazy',
  dependencies = { 'nvim-telescope/telescope.nvim' },
  opts = {
    telescope = {
      layout_config = layout_config,
    },
  },
  config = function()
    u.keys {
      { '<leader>ca', require('actions-preview').code_actions, '[C]ode [A]ction' },
    }
  end,
}
