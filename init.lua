-- Global config
require('plugins')
require('settings')
require('mappings')

-- Vimscript stuff (TODO: Port this over to lua)
vim.cmd('source ~/.config/nvim/vimscript/index.vim')

-- Plugin configs
require('telescope-config')
require('airline-config')
require('camelcasemotion-config')
require('emmet-config')
require('indentline-config')
require('whichkey-config')
-- require('lsp/lspconfig-config')
