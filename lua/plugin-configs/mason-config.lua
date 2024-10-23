return {
  'williamboman/mason.nvim',
  build = ':MasonUpdate',
  event = 'VeryLazy',
  dependencies = {
    'folke/neodev.nvim',
  },
  opts = {
    ui = {
      border = 'single',
    },
  },
}
