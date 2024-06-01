-- Ecosystem of small plugins

return {
  'echasnovski/mini.nvim',
  event = 'VeryLazy',
  config = function()
    require('mini.ai').setup { n_lines = 500 }
  end,
}
