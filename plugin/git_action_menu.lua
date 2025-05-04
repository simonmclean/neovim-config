local icons = require 'icons'
local action_menu = require 'action_menu'
local git = require 'git'

action_menu.create {
  prompt = icons.git .. ' Git',
  actions = {
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
      on_select = git.push,
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
      label = 'commit',
      on_select = function()
        vim.api.nvim_feedkeys(':Git commit -m "', 'n', false)
      end,
    },
    {
      label = 'github',
      on_select = function()
        require('snacks').gitbrowse()
      end,
    },
  },
  key_binding = '<leader>g',
  key_description = 'Open Git menu',
}
