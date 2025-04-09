local icons = require 'icons'
local action_menu = require 'action_menu'
local u = require 'utils'

-- TODO:
-- Persist settings
-- Show current setting

local function notify(name, value)
  u.fidget_notify(string.format('Set %s: %s', name, tostring(value)), 'info')
end

local function toggle_opt(name)
  return function()
    local new_val = not vim.o[name]
    vim.o[name] = new_val
    notify(name, new_val)
  end
end

local function toggle_win_opt(name)
  return function()
    local new_val = not vim.wo[name]
    vim.o[name] = new_val
    notify(name, new_val)
  end
end

action_menu.create {
  prompt = icons.toggle .. ' Toggle',
  actions = {
    {
      label = 'diagnostic virtual lines',
      on_select = function()
        local config = vim.diagnostic.config()
        if config then
          local new_value = not config.virtual_lines
          vim.diagnostic.config {
            virtual_text = { enabled = not new_value },
            virtual_lines = new_value,
          }
          notify('virtual_lines', new_value)
        end
      end,
    },
    {
      label = 'spell check',
      on_select = toggle_opt 'spell',
    },
    {
      label = 'word wrap',
      on_select = toggle_win_opt 'wrap',
    },
    {
      label = 'context',
      on_select = 'TSContextToggle',
    },
    {
      label = 'markview',
      on_select = 'Markview',
    },
  },
  key_binding = '<leader>o',
  key_description = 'Open toggle menu',
}
