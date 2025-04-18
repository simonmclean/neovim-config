-- Skip over unimportant characters when doing word-based motions

return {
  'chrisgrieser/nvim-spider',
  opts = {
    consistentOperatorPending = true
  },
  event = 'VeryLazy',
  keys = {
    { 'w', "<cmd>lua require('spider').motion('w')<CR>", mode = { 'n', 'o', 'x' } },
    { 'e', "<cmd>lua require('spider').motion('e')<CR>", mode = { 'n', 'o', 'x' } },
    { 'b', "<cmd>lua require('spider').motion('b')<CR>", mode = { 'n', 'o', 'x' } },
  },
}
