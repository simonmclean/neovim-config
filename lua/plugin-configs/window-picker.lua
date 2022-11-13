local window_picker = require 'window-picker'

window_picker.setup {
  other_win_hl_color = '#12131b',
  use_winbar = 'always',
  selection_chars = '123456789',
  include_current_win = true
}

vim.keymap.set('n', '<tab>', function()
  local picked_window_id = window_picker.pick_window() or vim.api.nvim_get_current_win()
  vim.api.nvim_set_current_win(picked_window_id)
end, {})
