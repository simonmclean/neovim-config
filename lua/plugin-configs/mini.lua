local git = require 'git'

-- Ecosystem of small plugins

return {
  -- textobjects for arguments
  {
    'echasnovski/mini.ai',
    version = '*',
    event = 'VeryLazy',
    opts = {
      n_lines = 500,
    },
  },
  -- add gS mapping to toggle between single and multiline arg lists
  {
    'echasnovski/mini.splitjoin',
    version = '*',
    event = 'VeryLazy',
    opts = {},
  },
  -- Pairs
  {
    'echasnovski/mini.pairs',
    version = '*',
    event = 'VeryLazy',
    opts = {},
  },
  -- Git helpers
  {
    'echasnovski/mini-git',
    version = '*',
    main = 'mini.git',
    event = 'VeryLazy',
    config = function()
      vim.api.nvim_create_autocmd('User', {
        pattern = 'MiniGitUpdated',
        callback = function()
          git.update_ahead_behind()
          git.update_current_branch()
        end,
      })
      require('mini.git').setup()
    end,
  },
  -- Work with surround chars, ({" etc
  {
    'echasnovski/mini.surround',
    version = '*',
    event = 'VeryLazy',
    opts = {
      mappings = {
        add = 'gs', -- Add surrounding in Normal and Visual modes
        delete = 'ds', -- Delete surrounding
        replace = 'cs', -- Replace surrounding
      },
    },
  },
}
