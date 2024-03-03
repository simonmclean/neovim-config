require 'bootstrap'

-- TODO: Move all this to Lua
vim.cmd 'source ~/.config/nvim/vimscript/functions.vim'

require 'plugins'
require 'lsp/lsp'
require 'features.statusline_commits'.new()
