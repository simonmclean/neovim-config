return function()
  local lines_count = vim.api.nvim_buf_line_count(0)
  local pos = vim.api.nvim_win_get_cursor(0)
  return pos[1] .. '/' .. lines_count
end
