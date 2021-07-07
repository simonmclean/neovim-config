-- Global config
require('plugins')
require('settings')
require('functions')
require('mappings')

-- Vimscript stuff (TODO: Port this over to lua)
vim.cmd('source ~/.config/nvim/vimscript/index.vim')

-- Plugin configs
require('plugin-configs/telescope')
require('plugin-configs/airline')
require('plugin-configs/camelcasemotion')
require('plugin-configs/emmet')
require('plugin-configs/indentline')
require('plugin-configs/whichkey')
require('plugin-configs/lightline')
require('plugin-configs/compe')
require('plugin-configs/metals')
require('plugin-configs/treesitter')
require('plugin-configs/autopairs')
require('lsp/lspconfig-config')
