-- floating terminal plugin for neovim

---@module 'lazy'
---@type LazyPluginSpec
return {
  'numToStr/FTerm.nvim',
  event = 'VeryLazy',
  opts = {
    blend = vim.g.winblend,
  },
  keys = {
    { '<c-t>', '<cmd>lua require("FTerm").toggle()<CR>', desc = 'Toggle floating terminal', mode = { 'n', 't' } },
  },
}
