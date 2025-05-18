return {
  'akinsho/bufferline.nvim',
  version = '*',
  event = 'VeryLazy',
  dependencies = 'nvim-tree/nvim-web-devicons',
  opts = {
    options = {
      enforce_regular_tabs = true
    }
  },
  keys = {
    { '<C-l>', ':BufferLineCycleNext<CR>' },
    { '<C-h>', ':BufferLineCyclePrev<CR>' },
  },
}
