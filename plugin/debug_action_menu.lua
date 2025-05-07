local icons = require 'icons'
local action_menu = require 'action_menu'

local function dap()
  return require 'dap'
end

action_menu.create {
  prompt = icons.info .. ' Debug',
  key = {
    key = '<leader>d',
    desc = 'Open Debug menu',
  },
  actions = {
    {
      'Continue',
      function()
        dap().continue()
      end,
    },
    {
      'Step into',
      function()
        dap().step_into()
      end,
    },
    {
      'Step over',
      function()
        dap().step_over()
      end,
    },
    {
      'Step out',
      function()
        dap().step_out()
      end,
    },
    {
      'Step back',
      function()
        dap().step_back()
      end,
    },
    {
      'Terminate',
      function()
        dap().terminate()
      end,
    },
    {
      'debug nearest',
      function()
        ---@diagnostic disable-next-line: missing-fields
        require('neotest').run.run { strategy = 'dap' }
      end,
    },
    {
      'Toggle breakpoint',
      function()
        dap().toggle_breakpoint()
      end,
    },
    {
      'Clear all breakpoints',
      function()
        dap().clear_breakpoints()
      end,
    },
  },
}
