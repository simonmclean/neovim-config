return {
  'akinsho/bufferline.nvim',
  version = '*',
  event = 'VeryLazy',
  dependencies = 'nvim-tree/nvim-web-devicons',
  opts = {},
  keys = {
    { '<C-l>', ':BufferLineCycleNext<CR>', silent = true },
    { '<C-h>', ':BufferLineCyclePrev<CR>', silent = true },
  },
}
