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

-- Checks if plugin exists in the filesystem before loading the config
-- Either takes the name of the plugin as a string, or a table which includes a list of dependancies
-- e.g. 'foo' or { 'foo' , deps = { 'bar', 'baz' } }
local function load_plugin_config(plugin)
  local pluginName = utils.eval(function()
    if (type(plugin) == 'string') then
      return plugin
    end
    return plugin[1]
  end)

  local isPluginInstalled = utils.is_plugin_installed(pluginName)

  local areDepsInstalled = utils.eval(function()
    if (type(plugin) == 'string') then
      return true
    end
    return utils.list_every(plugin.deps, utils.is_plugin_installed)
  end)

  -- TODO: These messages can get lost. Figure out blocking print or filesystem logging maybe?
  if (not isPluginInstalled) then
    print("Warning: Config for " .. pluginName .. " will not be loaded because the plugin is not installed")
  elseif (not areDepsInstalled) then
    print("Warning: Config for " .. pluginName .. " will not be loaded one or more dependancies are not installed")
  else
    local submodule_name = string.gsub(pluginName, '.nvim', '')
    require('plugin-configs.' .. submodule_name)
  end
end

utils.list_foreach({
  'camelcasemotion',
  'gitsigns.nvim',
  'indent-blankline.nvim',
  'leap.nvim',
  { 'lualine.nvim', deps = { 'nvim-web-devicons' } },
  { 'neo-tree.nvim', deps = { 'telescope.nvim' } },
  'no-neck-pain.nvim',
  'null-ls.nvim',
  'nvim-code-action-menu',
  'nvim-autopairs',
  'nvim-cmp',
  'nvim-treesitter',
  { 'nvim-treesitter-textobjects', deps = { 'nvim-treesitter' } },
  'nvim-web-devicons',
  'persisted.nvim',
  { 'pretty-vanilla-tabline.nvim', deps = { 'nvim-web-devicons' } },
  'telescope.nvim',
  'which-key.nvim',
}, load_plugin_config)

--------------------------------------------------------------------------
-- LSP config
--------------------------------------------------------------------------
require('lsp/lsp-config')

--------------------------------------------------------------------------
-- Misc
--------------------------------------------------------------------------
vim.o.laststatus = 3 -- vim-sensible overwrites this to 2
