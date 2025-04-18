-- Session management

return {
  'folke/persistence.nvim',
  event = 'VeryLazy',
  config = function()
    local persistence = require 'persistence'
    persistence.setup()
    -- don't restore session if we're starting nvim with a file arguement
    if vim.fn.argc() == 0 then
      vim.schedule(persistence.load)
    end
  end,
}
