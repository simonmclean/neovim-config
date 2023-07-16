require('bootstrap')

-- TODO: Move all this to Lua
vim.cmd('source ~/.config/nvim/vimscript/functions.vim')

require('plugins')
require('lsp/lsp-config')
require('theme')
