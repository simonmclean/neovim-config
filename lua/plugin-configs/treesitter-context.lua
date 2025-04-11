local u = require 'utils'

local function auto_toggle()
  local bufname = vim.api.nvim_buf_get_name(0)
  local context = require 'treesitter-context'

  if u.is_test_file(bufname) then
    context.enable()
  else
    context.disable()
  end
end

return {
  'nvim-treesitter/nvim-treesitter-context',
  event = 'VeryLazy',
  config = function()
    require('treesitter-context').setup {
      enable = false,
      max_lines = 6,
      separator = '—',
    }

    vim.api.nvim_create_autocmd('BufEnter', {
      callback = auto_toggle,
    })
  end,
}
