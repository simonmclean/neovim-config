local theme = require 'theme'

return function(plugins)
  local options = {
    ui = {
      border = 'single',
      title = ' Plugins ',
    },
    dev = {
      path = '~/code',
    },
    install = {
      missing = true,
      colorscheme = { theme.SELECTED_THEME.colorscheme },
    },
  }

  vim.keymap.set('n', '<leader>l', ':Lazy<CR>', { silent = true })

  require('lazy').setup(plugins, options)
end
