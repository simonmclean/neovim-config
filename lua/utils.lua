local M = {}

function M.split_string(str, delimiter)
  local result = {};
  for match in (str .. delimiter):gmatch("(.-)" .. delimiter) do
    table.insert(result, match);
  end
  return result;
end

function M.last(list)
  return list[#list]
end

function M.remove_linebreaks(str)
  return str:gsub("[\n\r]", "")
end

--- Gets the guifg value for a given highlight
function M.get_highlight_value(highlight_name)
  local h = vim.api.nvim_exec('hi ' .. highlight_name, true)
  local h_list = M.split_string(h, ' ')
  local guifg = h_list[5]
  local guibg = h_list[6]
  return {
    fg = M.last(M.split_string(guifg, '=')),
    bg = M.last(M.split_string(guibg, '=')),
  }
end

--- Wrapper around vim.api.nvim_exec where the 2nd arg defaults to false
function M.vim_exec(cmds, capture_return)
  local result = vim.api.nvim_exec(cmds, true)
  if (capture_return) then
    return result
  else
    return nil
  end
end

---Check if a target directory exists in a given table
function M.dir_list_includes(dir, dirs_table)
  local dir_expanded = vim.fn.expand(dir)
  return dirs_table and next(vim.tbl_filter(function(pattern)
    return dir_expanded:match(vim.fn.expand(pattern))
  end, dirs_table))
end

return M
