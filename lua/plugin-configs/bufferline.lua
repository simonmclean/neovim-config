-- Convert tabline into a buffer line + tabline

return {
  'akinsho/bufferline.nvim',
  version = '*',
  event = 'VeryLazy',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'tiagovla/scope.nvim'
  },
  opts = {},
  keys = {
    { '<C-l>', ':BufferLineCycleNext<CR>', silent = true },
    { '<C-h>', ':BufferLineCyclePrev<CR>', silent = true },
    { '<C-q>', ':bdelete<CR>', silent = true },
  },
}
