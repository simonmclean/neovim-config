return {
  'williamboman/mason-lspconfig.nvim',
  event = 'VeryLazy',
  dependencies = {
    'folke/neodev.nvim',
    'williamboman/mason.nvim',
  },
  config = function()
    local mason_lsp_config = require 'mason-lspconfig'

    local servers = mason_lsp_config.get_installed_servers()

    mason_lsp_config.setup {
      ensure_installed = servers,
      automatic_installation = true,
    }
  end,
}
