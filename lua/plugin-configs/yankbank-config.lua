return {
  'ptdewey/yankbank-nvim',
  config = function()
    require('yankbank').setup {
      num_behavior = 'jump',
    }
    vim.keymap.set('n', 'p', '<cmd>YankBank<CR>', { noremap = true })
  end,
}
