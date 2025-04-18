-- Fancy navigation

return {
  'folke/flash.nvim',
  event = 'VeryLazy',
  ---@type Flash.Config|{}
  opts = {
    label = {
      min_pattern_length = 2,
    },
  },
  keys = {
    {
      's',
      mode = { 'n', 'x', 'o' },
      function()
        require('flash').jump()
      end,
      desc = 'Flash',
    },
  },
}
