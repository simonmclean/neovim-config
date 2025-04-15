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
}
