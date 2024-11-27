return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-treesitter/nvim-treesitter',
    'marilari88/neotest-vitest',
  },
  config = function()
    local neotest = require 'neotest'

    ---@diagnostic disable-next-line: missing-fields
    neotest.setup {
      adapters = {
        require 'neotest-vitest',
      },
    }
  end,
}
