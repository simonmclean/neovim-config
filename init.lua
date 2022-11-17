--------------------------------------------------------------------------
-- Bootstrap
--------------------------------------------------------------------------
require('bootstrap')

--------------------------------------------------------------------------
-- Vimscript TODO: Move all this to Lua
--------------------------------------------------------------------------
vim.cmd('source ~/.config/nvim/vimscript/functions.vim')

--------------------------------------------------------------------------
-- Plugin configs
--------------------------------------------------------------------------

require('plugins')

local utils = require 'utils'

local function load_plugin_config(name)
  if (utils.is_plugin_installed(name)) then
    local submodule_name = string.gsub(name, '.nvim', '')
    require('plugin-configs.' .. submodule_name)
  end
end

utils.list_foreach({
  'camelcasemotion',
  'nvim-cmp',
  'code-action-menu',
  'emmet-vim',
  'indent-blankline.nvim',
  'leap.nvim',
  'lualine.nvim',
  'neo-tree.nvim',
  'null-ls.nvim',
  'nvim-autopairs',
  'nvim-treesitter',
  'nvim-treesitter-text-objects',
  'nvim-web-devicons',
  'nvim-window-picker',
  'persisted.nvim',
  'telescope.nvim',
}, load_plugin_config)

--------------------------------------------------------------------------
-- LSP config
--------------------------------------------------------------------------
require('lsp/lsp-config')
