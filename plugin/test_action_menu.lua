local icons = require 'icons'
local action_menu = require 'action_menu'

action_menu.create {
  prompt = icons.test .. ' Tests',
  actions = {
    {
      label = 'summary',
      on_select = 'Neotest summary',
    },
    {
      label = 'output panel',
      on_select = 'Neotest output-panel',
    },
    {
      label = 'run nearest',
      on_select = function()
        require('neotest').run.run()
      end,
    },
    {
      label = 'run file',
      on_select = 'Neotest run file',
    },
    {
      label = 'stop',
      on_select = 'Neotest stop',
    },
    {
      label = 'attach',
      on_select = 'Neotest attach',
    },
  },
  key_binding = '<leader>t',
  key_description = 'Open test menu',
}
