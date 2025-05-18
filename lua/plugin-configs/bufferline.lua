return {
  'akinsho/bufferline.nvim',
  version = '*',
  event = 'VeryLazy',
  dependencies = 'nvim-tree/nvim-web-devicons',
  opts = {},
  keys = {
    { '<C-l>', ':BufferLineCycleNext<CR>' },
    { '<C-h>', ':BufferLineCyclePrev<CR>' },
  },
}
