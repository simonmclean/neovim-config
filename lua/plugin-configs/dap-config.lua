return {
  'mfussenegger/nvim-dap',
  event = 'VeryLazy',
  config = function()
    local dap = require 'dap'
    local map = vim.keymap.set

    vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'Error', linehl = 'DiagnosticVirtualTextError' })
    vim.fn.sign_define('DapStopped', { text = '⏸︎', texthl = 'WarningMsg', linehl = 'DiagnosticVirtualTextWarn' })

    map('n', '<leader>dc', dap.continue, { desc = '[d]ap [c]ontinue' })
    map('n', '<leader>dt', dap.terminate, { desc = '[d]ap [t]erminate' })
    map('n', '<leader>dsi', dap.step_into, { desc = '[d]ap [s]tep [i]nto' })
    map('n', '<leader>dso', dap.step_over, { desc = '[d]ap [s]tep [o]ver' })
    map('n', '<leader>dsO', dap.step_out, { desc = '[d]ap [s]tep [O]ut' })
    map('n', '<leader>dr', dap.repl.toggle, { desc = '[d]ap toggle [r]epl' })
    map('n', '<leader>dbt', dap.toggle_breakpoint, { desc = '[d]ap toggle [b]reakpoint' })
    map('n', '<leader>dbl', function()
      dap.list_breakpoints(true)
    end, { desc = '[d]ap [b]reakpoints [l]ist (quickfix)' })
    map('n', '<leader>dbc', dap.clear_breakpoints, { desc = '[d]ap [b]reakpoints [c]clear' })
    map('n', '<leader>dff', dap.focus_frame, { desc = '[d]ap [f]ocus [f]rame' })
  end,
}
