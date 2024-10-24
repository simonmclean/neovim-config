return {
  'simonmclean/triptych.nvim',
  event = 'VeryLazy',
  dir = '~/code/triptych',
  dev = false,
  dependencies = {
    'nvim-lua/plenary.nvim', -- required
    'nvim-tree/nvim-web-devicons', -- optional
  },
  opts = {
    extension_mappings = {
      ['<leader>sg'] = {
        mode = 'n',
        fn = function(target)
          require('telescope.builtin').live_grep {
            search_dirs = { target.path },
          }
        end,
      },
    },
  },
  keys = {
    { '<leader>-', ':Triptych<CR>' },
  },
}
