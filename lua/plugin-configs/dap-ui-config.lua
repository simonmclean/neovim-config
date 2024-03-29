return function()
  local dap, dapui = require 'dap', require 'dapui'
  dap.listeners.before.attach.dapui_config = function()
    dapui.open()
  end
  dap.listeners.before.launch.dapui_config = function()
    dapui.open()
  end
  dap.listeners.before.event_terminated.dapui_config = function()
    dapui.close()
  end
  dap.listeners.before.event_exited.dapui_config = function()
    dapui.close()
  end
  dapui.setup {
    layouts = {
      {
        elements = {
          {
            id = 'scopes',
            size = 1,
          },
        },
        position = 'bottom',
        size = 10,
      },
    },
  }
end
