local u = require 'utils'

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

    u.keys {
      { '<leader>sh', builtin.help_tags, '[S]earch [H]elp' },
      { '<leader>sk', builtin.keymaps, '[S]earch [K]eymaps' },
      { '<leader>sf', builtin.find_files, '[S]earch [F]iles' },
      { '<leader>st', builtin.builtin, '[S]earch [T]elescope' },
      { '<leader>sg', builtin.live_grep, '[S]earch [G]rep' },
      { '<leader>sd', builtin.diagnostics, '[S]earch [D]iagnostics' },
      { '<leader>sr', builtin.resume, '[S]earch [R]esume' },
      { '<leader>sb', grep_in_current_buffer, '[S]earch [B]uffer' },
      { '<leader>sc', builtin.commands, '[S]earch [C]ommands' },
    }

    require('telescope').setup {
      defaults = {
        layout_strategy = 'flex',
        path_display = { truncate = 2 },
        layout_config = layout_config,
        winblend = vim.g.winblend,
        file_ignore_patterns = {
          'yarn.lock',
          'docs/ui/swagger',
        }
      },
    }
  end,
  layout_config = layout_config,
}
