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
  key = {
    key = '<leader>o',
    desc = 'Open toggle menu',
  },
  actions = {
    {
      'diagnostic virtual lines',
      function()
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
      'spell check',
      toggle_opt 'spell',
    },
    {
      'word wrap',
      toggle_win_opt 'wrap',
    },
    {
      'context (buffer)',
      function()
        local ctx = require 'treesitter-context'
        local is_enabled = ctx.enabled()
        if is_enabled then
          vim.api.nvim_buf_set_var(0, 'suspend_ts_context_autocmd', true)
          ctx.disable()
        else
          vim.api.nvim_buf_set_var(0, 'suspend_ts_context_autocmd', false)
          ctx.enable()
        end
        notify('virtual_lines', ctx.enabled())
      end,
    },
    {
      'markview',
      'Markview',
    },
  },
}
