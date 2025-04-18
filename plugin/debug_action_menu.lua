local icons = require 'icons'
local action_menu = require 'action_menu'

local function dap()
  return require 'dap'
end

action_menu.create {
  prompt = icons.info .. ' Debug',
  key_binding = '<leader>d',
  key_description = 'Open Debug menu',
  actions = {
    {
      label = 'Continue',
      on_select = function()
        dap().continue()
      end,
    },
    {
      label = 'Step into',
      on_select = function()
        dap().step_into()
      end,
    },
    {
      label = 'Step over',
      on_select = function()
        dap().step_over()
      end,
    },
    {
      label = 'Step out',
      on_select = function()
        dap().step_out()
      end,
    },
    {
      label = 'Step back',
      on_select = function()
        dap().step_back()
      end,
    },
    {
      label = 'Terminate',
      on_select = function()
        dap().terminate()
      end,
    },
    {
      label = 'Toggle breakpoint',
      on_select = function()
        dap().toggle_breakpoint()
      end,
    },
    {
      label = 'Clear all breakpoints',
      on_select = function()
        dap().clear_breakpoints()
      end,
    },
  },
}
