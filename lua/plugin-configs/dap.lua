local u = require 'utils'

local function setup_javascript_dap()
  local dap = require 'dap'
  local mason_reg = require 'mason-registry'

  if not mason_reg.is_installed 'js-debug-adapter' then
    u.warn 'js-debug-adapter is not installed'
    return
  end

  local js_debug_path = mason_reg.get_package('js-debug-adapter'):get_install_path()

  local bin_path = js_debug_path .. '/js-debug/src/dapDebugServer.js'

  dap.adapters['pwa-node'] = {
    type = 'server',
    host = 'localhost',
    port = '${port}',
    executable = {
      command = 'node',
      args = { bin_path, '${port}' },
    },
  }

  local js_config = {
    {
      type = 'pwa-node',
      request = 'launch',
      name = 'Launch file',
      program = '${file}',
      cwd = '${workspaceFolder}',
    },
  }

  dap.configurations.javascript = js_config
  dap.configurations.typescript = js_config
end

return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'williamboman/mason.nvim',
  },
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

    setup_javascript_dap()
  end,
}
