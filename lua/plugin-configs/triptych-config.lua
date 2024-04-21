return function()
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
  vim.keymap.set('n', '<leader>-', ':Triptych<CR>', { silent = true })
end
