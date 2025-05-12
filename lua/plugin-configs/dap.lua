local function setup_javascript_dap()
  local dap = require 'dap'
  local mason_reg = require 'mason-registry'

  if not mason_reg.is_installed 'js-debug-adapter' then
    vim.notify('js-debug-adapter is not installed', vim.log.levels.WARN)
    return
  end

  dap.adapters['pwa-node'] = {
    type = 'server',
    host = 'localhost',
    port = '${port}',
    executable = {
      command = 'js-debug-adapter',
      args = { '${port}' },
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
    {
      'igorlfs/nvim-dap-view',
      opts = {
        winbar = {
          show = true,
          sections = {
            'scopes',
            'watches',
            'exceptions',
            'breakpoints',
            'threads',
            'repl',
            'console',
          },
          default_section = 'scopes',
        },
        windows = {
          height = 20,
        },
      },
    },
  },
  event = 'VeryLazy',
  config = function()
    local dap = require 'dap'
    local dap_view = require 'dap-view'

    vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'Error', linehl = 'DiagnosticVirtualTextError' })

    vim.fn.sign_define('DapStopped', { text = '⏸︎', texthl = 'WarningMsg', linehl = 'DiagnosticVirtualTextWarn' })

    local ui_delay_ms = 1000

    dap.listeners.before.attach['dap-view-config'] = function()
      vim.defer_fn(function()
        dap_view.open()
      end, ui_delay_ms)
    end
    dap.listeners.before.launch['dap-view-config'] = function()
      vim.notify 'Starting debug session'
      vim.defer_fn(function()
        dap_view.open()
      end, ui_delay_ms)
    end
    dap.listeners.before.event_terminated['dap-view-config'] = function()
      dap_view.close()
      vim.notify 'Debug session terminated'
    end
    dap.listeners.before.event_exited['dap-view-config'] = function()
      dap_view.close()
    end

    setup_javascript_dap()
  end,
}
