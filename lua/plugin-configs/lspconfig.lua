-- Out-of-the-box configs for language servers

return {
  'neovim/nvim-lspconfig',
  config = function()
    require('lspconfig.ui.windows').default_options.border = 'single'
  end,
}
