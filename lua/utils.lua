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

function M.dec_to_hex(n, chars)
  chars = chars or 6
  local hex = string.format("%0" .. chars .. "x", n)
  while #hex < chars do
    hex = "0" .. hex
  end
  return hex
end

function M.get_highlight_values(highlight_name)
  local highlight_map = vim.api.nvim_get_hl_by_name(highlight_name, true)
  for key, value in pairs(highlight_map) do
    if (key == 'foreground' or key == 'background') then
      highlight_map[key] = M.dec_to_hex(value)
    end
  end
  return highlight_map
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
