-- Global config
require('bootstrap')
require('plugins')

-- Vimscript stuff (TODO: Port this over to lua)
vim.cmd('source ~/.config/nvim/vimscript/functions.vim')

-- Plugin configs
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
require('lsp/lsp-config')
