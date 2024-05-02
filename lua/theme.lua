local u = require 'utils'

local M = {}

-- Only the SELECTED_THEME will actually installed
local theme_plugins = {
  'mhartington/oceanic-next',
  {
    'npxbr/gruvbox.nvim',
    dependencies = { 'rktjmp/lush.nvim' },
  },
  'kyazdani42/blue-moon',
  'bluz71/vim-nightfly-guicolors',
  'sainnhe/sonokai',
  'shaunsingh/moonlight.nvim',
  'tjdevries/colorbuddy.vim',
  'bkegley/gloombuddy',
  'folke/tokyonight.nvim',
  {
    'catppuccin/nvim',
    name = 'catppuccin',
  },
}

-- Change this when we want to change theme
M.SELECTED_THEME = {
  plugin = 'folke/tokyonight.nvim',
  colorscheme = 'tokyonight',
}

-- Return a table which is a valid Lazy plugin config
M.get_lazy_config = function(plugin_name, colorscheme_name)
  for _, plugin in ipairs(theme_plugins) do
    local tbl = u.eval(function()
      if type(plugin) == 'table' then
        return plugin
      end
      return { plugin }
    end)
    if tbl[1] == plugin_name then
      tbl.lazy = false
      tbl.priority = 1000
      tbl.config = function()
        require('plugin-configs/' .. colorscheme_name .. '-config')()
        vim.cmd('colorscheme ' .. colorscheme_name)
      end
      return tbl
    end
  end
end

return M
