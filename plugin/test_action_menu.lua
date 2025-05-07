local icons = require 'icons'
local action_menu = require 'action_menu'

action_menu.create {
  prompt = icons.test .. ' Tests',
  key = {
    key = '<leader>t',
    desc = 'Open test menu',
  },
  actions = {
    {
      'run nearest',
      function()
        require('neotest').run.run()
      end,
    },
    {
      'run file',
      'Neotest run file',
    },
    {
      'summary',
      'Neotest summary',
    },
    {
      'output panel',
      'Neotest output-panel',
    },
    {
      'stop',
      'Neotest stop',
    },
    {
      'attach',
      'Neotest attach',
    },
  },
}
