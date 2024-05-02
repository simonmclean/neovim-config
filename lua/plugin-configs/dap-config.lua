return function()
  local dap = require 'dap'
  local map = vim.keymap.set
  map('n', '<leader>db', dap.toggle_breakpoint, { desc = "[d]ap toggle [b]reakpoint"} )
  map('n', '<leader>dc', dap.continue, { desc = "[d]ap [c]ontinue"})
  map('n', '<leader>dt', dap.terminate, { desc = "[d]ap [t]erminate"})
  map('n', '<leader>dsi', dap.step_into, { desc = "[d]ap [s]tep [i]nto"})
  map('n', '<leader>dso', dap.step_over, { desc = "[d]ap [s]tep [o]ver"})
  map('n', '<leader>dsO', dap.step_out, { desc = "[d]ap [s]tep [O]ut"})
end
