return {
  'ptdewey/yankbank-nvim',
  event = 'VeryLazy',
  config = function()
    require('yankbank').setup {
      num_behavior = 'jump',
      -- Poll the unnamedplus register (aka system clipboard)
      focus_gain_poll = true
    }
    vim.keymap.set('n', 'p', '<cmd>YankBank<CR>', { noremap = true })
  end,
}
