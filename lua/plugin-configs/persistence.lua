return {
  'folke/persistence.nvim',
  event = 'VeryLazy',
  config = function()
    local persistence = require 'persistence'
    persistence.setup()
    vim.schedule(persistence.load)
  end,
}
