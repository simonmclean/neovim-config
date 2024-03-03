return function()
  local map = vim.keymap.set
  local builtin = require 'telescope.builtin'

  map('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
  map('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
  map('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
  map('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope (same as executing :Telescope)' })
  -- map('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
  map('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
  map('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
  map('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
  -- map('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
  -- map('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
  map('n', '<leader>sb', builtin.current_buffer_fuzzy_find, { desc = '[Search] current [B]uffer' })

  require('telescope').setup {
    defaults = {
      path_display = { truncate = 2 },
    },
  }
end
