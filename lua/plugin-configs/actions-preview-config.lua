return function()
  local layout_config = require('plugin-configs.telescope').layout_config

  require('actions-preview').setup {
    telescope = {
      layout_config = layout_config,
    },
  }
end
