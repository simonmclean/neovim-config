local map = require 'utils'.keymap_set

local layout_config = {
  flex = {
    flip_columns = 2000, -- When there are more than n columns, switch to horizontal
    flip_lines = 40, -- When there are more than n lines, switch to vertical
  },
}

local function grep_in_current_buffer()
  require('telescope.builtin').live_grep {
    prompt_title = 'Grep in Current Buffer',
    path_display = 'hidden',
    search_dirs = { vim.fn.expand '%:h' },
    glob_pattern = vim.fn.expand '%:t',
  }
end

return {
  'nvim-telescope/telescope.nvim',
  event = 'VeryLazy',
  dependencies = { 'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim' },
  config = function()
    local builtin = require 'telescope.builtin'

    map('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
    map('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
    map('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
    map('n', '<leader>st', builtin.builtin, { desc = '[S]earch [T]elescope' })
    -- map('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
    map('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch [G]rep' })
    map('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
    map('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
    -- map('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
    -- map('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
    map('n', '<leader>sb', grep_in_current_buffer, { desc = '[S]earch [B]uffer' })
    map('n', '<leader>sc', builtin.commands, { desc = '[S]earch [C]ommands' })

    require('telescope').setup {
      defaults = {
        layout_strategy = 'flex',
        path_display = { truncate = 2 },
        layout_config = layout_config,
      },
    }
  end,
  layout_config = layout_config,
}
