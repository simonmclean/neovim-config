local icons = require 'icons'
local action_menu = require 'action_menu'
local float = require 'float'

action_menu.create {
  prompt = icons.git .. ' Git',
  actions = {
    {
      label = 'status',
      on_select = function()
        float.create(function(data)
          -- This function moves the fugitive buffer into the floating window, and closes the default one
          local float_win = data.float_win
          vim.cmd 'G'
          local fugitive_buf = vim.api.nvim_win_get_buf(0)
          local fugitive_win = vim.api.nvim_get_current_win()
          vim.api.nvim_win_set_buf(float_win, fugitive_buf)
          vim.api.nvim_win_close(fugitive_win, true)
          vim.api.nvim_set_current_win(float_win)
          data.create_autoclose()
        end, ' ' .. icons.git .. ' Git ')
      end,
    },
    {
      label = 'diff',
      -- This function acts as a DiffviewToggle command
      on_select = function()
        local views = require('diffview.lib').views
        if #views > 0 then
          for _, view in ipairs(views) do
            view:close()
          end
        else
          vim.cmd 'DiffviewOpen'
        end
      end,
    },
    {
      label = 'fetch & prune',
      on_select = 'Git fetch --prune',
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
      label = 'create new branch',
      on_select = function()
        vim.api.nvim_feedkeys(':Git checkout -b ', 'n', false)
      end,
    },
    {
      label = 'switch branch',
      on_select = function()
        vim.api.nvim_feedkeys(':Git checkout ', 'n', false)
      end,
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
