return {
  'simonmclean/triptych.nvim',
  -- dir = '~/code/triptych',
  -- dev = true,
  dependencies = {
    'nvim-lua/plenary.nvim', -- required
    'nvim-tree/nvim-web-devicons', -- optional
  },
  opts = {
    options = {
      backdrop = 100,
      transparency = vim.g.winblend,
    },
    extension_mappings = {
      ['<leader>sg'] = {
        mode = 'n',
        fn = function(target)
          require('snacks').picker.grep {
            dirs = { target.path },
          }
        end,
      },
    },
  },
  keys = {
    { '<leader>-', ':Triptych<CR>', silent = true },
  },
}
