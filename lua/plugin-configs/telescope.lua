local map = vim.api.nvim_set_keymap

map('n', '<c-p>', ':Telescope find_files<cr>', {})
map('n', '<c-f>', ':Telescope live_grep<cr>', {})
map('n', '<leader>s', ':Telescope lsp_document_symbols<cr>', {})

require'telescope'.setup {
  defaults = {
    path_display = { truncate = 2 }
  }
}
