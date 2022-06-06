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

require('plugin-configs/telescope')
require('plugin-configs/camelcasemotion')
require('plugin-configs/code-action-menu')
require('plugin-configs/emmet')
require('plugin-configs/indentline')
require('plugin-configs/whichkey')
require('plugin-configs/lualine')
require('plugin-configs/treesitter')
require('plugin-configs/autopairs')
require('plugin-configs/neo-tree')
require('plugin-configs/folke-persistence')

--------------------------------------------------------------------------
-- LSP config
--------------------------------------------------------------------------
require('lsp/lsp-config')
