return {
  'williamboman/mason.nvim',
  build = ':MasonUpdate',
  event = 'VeryLazy',
  dependancies = {
    'folke/neodev.nvim',
  },
  opts = {
    ui = {
      border = 'single',
    },
  },
}
