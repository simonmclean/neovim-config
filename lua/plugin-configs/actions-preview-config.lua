return {
  'aznhe21/actions-preview.nvim',
  event = 'VeryLazy',
  dependencies = { 'nvim-telescope/telescope.nvim' },
  config = function()
    local layout_config = require('plugin-configs.telescope').layout_config

    require('actions-preview').setup {
      telescope = {
        layout_config = layout_config,
      },
    }
  end,
}
