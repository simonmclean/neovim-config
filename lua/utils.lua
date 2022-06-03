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

--- Gets the guifg value for a given highlight
function M.get_highlight_value(highlight_name)
  local h = vim.api.nvim_exec('hi ' .. highlight_name, true)
  local h_list = M.split_string(h, ' ')
  local guifg = M.last(h_list)
  local key_value_pair = M.split_string(guifg, '=')
  return M.last(key_value_pair)
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

return M
