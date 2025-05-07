local u = require 'utils'

---@class Action
---@field [1] string label
---@field [2] function|string cmd or function to run on select

---@class ActionMenuKey
---@field key string
---@field desc string

---@class ActionMenuConfig
---@field prompt string
---@field actions Action[]
---@field key ActionMenuKey

---@param config ActionMenuConfig
local function create(config)
  ---@type string[]
  local select_options = vim.tbl_map(function(action)
    return action[1]
  end, config.actions)

  local open = function()
    vim.ui.select(select_options, {
      prompt = config.prompt,
    }, function(choice)
      if not choice then
        return
      end

      ---@type Action
      local action = u.list_find(config.actions, function(action)
        return action[1] == choice
      end)

      local on_select = action[2]

      -- Schedule so that the select menu can close first
      vim.schedule(function()
        if type(on_select) == 'string' then
          vim.cmd(on_select)
        else
          on_select()
        end
      end)
    end)
  end

  vim.keymap.set('n', config.key.key, open, { desc = config.key.desc, nowait = true })
end

return {
  create = create,
}
