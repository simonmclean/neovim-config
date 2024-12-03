-- A sidebar with a tree-like outline of symbols from your code, powered by LSP.

return {
  'hedyhli/outline.nvim',
  cmd = { 'Outline', 'OutlineOpen' },
  keys = {
    { '<leader>o', '<cmd>Outline<CR>', desc = 'Toggle outline' },
  },
  opts = {},
}
