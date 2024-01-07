return function()
  require('triptych').setup()
  vim.keymap.set('n', '<leader>-', ':Triptych<CR>', { silent = true })
end
