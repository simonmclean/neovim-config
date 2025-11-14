-- Integrated test runner

return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-treesitter/nvim-treesitter',
    'marilari88/neotest-vitest',
    'nvim-neotest/neotest-jest',
    {
      'fredrikaverpil/neotest-golang',
      version = '*',
      build = function()
        -- vim.system({ 'go', 'install', 'gotest.tools/gotestsum@latest' }):wait() -- Optional, but recommended
      end,
    },
  },
  event = 'VeryLazy',
  config = function()
    local neotest = require 'neotest'

    ---@diagnostic disable-next-line: missing-fields
    neotest.setup {
      adapters = {
        require 'neotest-vitest',
        require 'neotest-golang',
        require 'neotest-jest' {
          jestCommand = 'yarn dlx jest',
          jestArguments = function(defaultArguments, _)
            return defaultArguments
          end,
          -- jestConfigFile = 'custom.jest.config.ts',
          -- env = { CI = true },
          cwd = function()
            return vim.fn.getcwd()
          end,
          jest_test_discovery = true, -- enables parametric test discovery
          isTestFile = require('neotest-jest.jest-util').defaultIsTestFile,
        },
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
