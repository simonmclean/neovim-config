local u = require 'utils'

---@class Action
---@field label string
---@field on_select function|string

---@class ActionMenuConfig
---@field prompt string
---@field actions Action[]
---@field key_binding string
---@field key_description string

---@param config ActionMenuConfig
local function create(config)
  ---@type string[]
  local select_options = vim.tbl_map(function(action)
    return action.label
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
        return action.label == choice
      end)

      -- Schedule so that the select menu can close first
      vim.schedule(function()
        if type(action.on_select) == 'string' then
          vim.cmd(action.on_select)
        else
          action.on_select()
        end
      end)
    end)
  end

  vim.keymap.set('n', config.key_binding, open, { desc = config.key_description, nowait = true })
end

return {
  create = create,
}
