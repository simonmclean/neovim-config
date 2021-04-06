local map = vim.api.nvim_set_keymap

map('n', '<c-p>', ':Telescope find_files<cr>', {})
map('n', '<c-f>', ':Telescope live_grep<cr>', {})
map('n', '<c-s>', ':Telescope lsp_document_symbols<cr>', {})
