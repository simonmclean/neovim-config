-- floating terminal plugin for neovim

return {
  'numToStr/FTerm.nvim',
  event = 'VeryLazy',
  opts = {
    blend = vim.g.winblend
  },
  keys = {
    { '<leader>t', '<cmd>lua require("FTerm").toggle()<CR>', desc = 'Toggle floating terminal' },
  },
}
