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
  -- Work with surround chars, ({" etc
  {
    'echasnovski/mini.surround',
    version = '*',
    event = 'VeryLazy',
    opts = {
      n_lines = 50,
      mappings = {
        add = 'gs', -- Add surrounding in Normal and Visual modes
        delete = 'ds', -- Delete surrounding
        replace = 'cs', -- Replace surrounding
        find = '', -- Find surrounding (to the right)
        find_left = '', -- Find surrounding (to the left)
        highlight = '', -- Highlight surrounding
        update_n_lines = '', -- Update `n_lines`
      },
    },
  },
}
