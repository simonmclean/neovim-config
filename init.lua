require('plugins')
require('settings')
require('mappings')
vim.cmd('source ~/.config/nvim/vimscript/index.vim')

-- Plugin configs
require('telescope-config')
require('airline-config')
require('camelcasemotion-config')
require('emmet-config')
require('indentline-config')
require('whichkey-config')

-- Theme configs
-- require('oceanic-next-config')
require('gruvbox-config')
