local icons = require 'icons'
local action_menu = require 'action_menu'

action_menu.create {
  prompt = icons.git .. ' Git',
  actions = {
    {
      label = 'status',
      on_select = 'tab G',
    },
    {
      label = 'fetch prune',
      on_select = 'Git fetch --prune'
    },
    {
      label = 'push',
      on_select = 'Git push',
    },
    {
      label = 'pull',
      on_select = 'Git pull',
    },
    {
      label = 'checkout latest main',
      on_select = 'Main',
    },
    {
      label = 'sync',
      on_select = 'GitSync',
    },
    {
      label = 'commit',
      on_select = function()
        vim.api.nvim_feedkeys(':Git commit -m "', 'n', false)
      end,
    },
    {
      label = 'github',
      on_select = 'GBrowse',
    },
  },
  key_binding = '<leader>g',
  key_description = 'Open Git menu',
}
