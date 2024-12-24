local u = require 'utils'

return {
  'mfussenegger/nvim-dap',
  event = 'VeryLazy',
  config = function()
    local dap = require 'dap'

    vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'Error', linehl = 'DiagnosticVirtualTextError' })
    vim.fn.sign_define('DapStopped', { text = '⏸︎', texthl = 'WarningMsg', linehl = 'DiagnosticVirtualTextWarn' })

    u.keys {
      -- Start, stop, continue
      { '<leader>dc', dap.continue, '[d]ap [c]ontinue' },
      { '<leader>dt', dap.terminate, '[d]ap [t]erminate' },

      -- Stepping
      { '<leader>dsi', dap.step_into, '[d]ap [s]tep [i]nto' },
      { '<leader>dso', dap.step_over, '[d]ap [s]tep [o]ver' },
      { '<leader>dsO', dap.step_out, '[d]ap [s]tep [O]ut' },

      -- Breakpoints
      { '<leader>dbb', dap.toggle_breakpoint, '[d]ap toggle [b]reakpoint' },
      {
        '<leader>dbl',
        function()
          dap.list_breakpoints(true)
        end,
        '[d]ap [b]reakpoints [l]ist (quickfix)',
      },
      { '<leader>dbc', dap.clear_breakpoints, '[d]ap [b]reakpoints [c]clear' },

      -- Repl
      -- In the repl run `.scopes`, `.frames`, `.threads`
      -- See :h dap.repl.open()
      { '<leader>dr', dap.repl.toggle, '[d]ap toggle [r]epl' },

      -- Misc
      { '<leader>dff', dap.focus_frame, '[d]ap [f]ocus [f]rame' },
    }
  end,
}
