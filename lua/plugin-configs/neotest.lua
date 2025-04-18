-- Integrated test runner

return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-treesitter/nvim-treesitter',
    'marilari88/neotest-vitest',
  },
  event = 'VeryLazy',
  config = function()
    local neotest = require 'neotest'

    ---@diagnostic disable-next-line: missing-fields
    neotest.setup {
      adapters = {
        require 'neotest-vitest',
      },
    }

    -- Close neotest before exiting, otherwise it makes a mess when the session is restored
    vim.api.nvim_create_autocmd('VimLeavePre', {
      callback = function()
        local wins = vim.api.nvim_list_wins()
        for _, win in ipairs(wins) do
          local buf = vim.api.nvim_win_get_buf(win)
          local ft = vim.api.nvim_get_option_value('filetype', { buf = buf })
          if ft and string.find(ft, 'neotest') then
            vim.api.nvim_win_close(win, true)
          end
        end
      end,
    })
  end,
}
