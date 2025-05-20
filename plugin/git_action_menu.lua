local icons = require 'icons'
local action_menu = require 'action_menu'
local git_utils = require 'git.utils'

action_menu.create {
  prompt = icons.git .. ' Git',
  key = {
    key = '<leader>g',
    desc = 'Open Git menu',
  },
  actions = {
    {
      'diff',
      -- This function acts as a DiffviewToggle command
      function()
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
      'fetch & prune',
      'Git fetch --prune',
    },
    {
      'push',
      git_utils.push,
    },
    {
      'pull',
      'Git pull',
    },
    {
      'create new branch',
      function()
        vim.api.nvim_feedkeys(':Git checkout -b ', 'n', false)
      end,
    },
    {
      'switch branch',
      function()
        vim.api.nvim_feedkeys(':Git checkout ', 'n', false)
      end,
    },
    {
      'checkout latest main',
      'Main',
    },
    {
      'commit',
      function()
        vim.api.nvim_feedkeys(':Git commit -m "', 'n', false)
      end,
    },
    {
      'github',
      function()
        require('snacks').gitbrowse()
      end,
    },
  },
}
