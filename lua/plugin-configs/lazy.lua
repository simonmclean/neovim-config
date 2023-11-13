return function(plugins)
  local options = {
    ui = {
      border = 'single',
      title = ' Plugins ',
    },
    dev = {
      path = '~/code',
    },
  }

  vim.keymap.set('n', '<leader>l', ':Lazy<CR>', { silent = true })

  require('lazy').setup(plugins, options)
end
