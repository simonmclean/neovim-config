local icons = require 'icons'
local action_menu = require 'action_menu'

action_menu.create {
  prompt = icons.test .. ' Tests',
  actions = {
    {
      label = 'run nearest',
      on_select = function()
        require('neotest').run.run()
      end,
    },
    {
      label = 'debug nearest',
      on_select = function()
        ---@diagnostic disable-next-line: missing-fields
        require('neotest').run.run { strategy = 'dap' }
      end,
    },
    {
      label = 'run file',
      on_select = 'Neotest run file',
    },
    {
      label = 'summary',
      on_select = 'Neotest summary',
    },
    {
      label = 'output panel',
      on_select = 'Neotest output-panel',
    },
    {
      label = 'stop',
      on_select = 'Neotest stop',
    },
    {
      label = 'attach',
      on_select = 'Neotest attach',
    },
    {
      label = 'toggle breakpoint',
      on_select = 'DapToggleBreakpoint',
    },
    {
      label = 'clear all breakpoints',
      on_select = function ()
        require 'dap'.clear_breakpoints()
      end,
    },
    {
      label = 'list breakpoints',
      on_select = function ()
        require 'dap'.list_breakpoints()
      end,
    },
  },
  key_binding = '<leader>t',
  key_description = 'Open test menu',
}
