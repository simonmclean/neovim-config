local map = require 'utils'.keymap_set

return {
  'simonmclean/triptych.nvim',
  event = 'VeryLazy',
  -- dir = '~/code/triptych',
  dev = false,
  dependencies = {
    'nvim-lua/plenary.nvim', -- required
    'nvim-tree/nvim-web-devicons', -- optional
  },
  config = function()
    require('triptych').setup {
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
    }

    map('n', '<leader>-', ':Triptych<CR>')
  end,
}
