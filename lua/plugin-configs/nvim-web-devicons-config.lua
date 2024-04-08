return function()
  require('nvim-web-devicons').setup {
    override = {
      TelescopePrompt = {
        icon = ' ',
      },
      fugitive = {
        icon = '',
        -- TODO: Colors aren't working
        color = '#f14e32',
      },
    },
  }
end
