return {
  'williamboman/mason-lspconfig.nvim',
  event = 'VeryLazy',
  dependencies = {
    'folke/neodev.nvim',
    'williamboman/mason.nvim',
  },
  ---@module 'mason-lspconfig'
  ---@type MasonLspconfigSettings
  opts = {
    ensure_installed = { 'lua_ls', 'ts_ls' },
    automatic_installation = true
  }
}
