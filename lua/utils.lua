local M = {}

---@param value nil | string | table
---@return boolean
function M.is_defined(value)
  if type(value) == 'table' then
    return next(value) ~= nil
  end
  if value == nil or value == '' then
    return false
  end
  return true
end

function M.split_string(str, delimiter)
  local result = {}
  for match in (str .. delimiter):gmatch('(.-)' .. delimiter) do
    table.insert(result, match)
  end
  return result
end

function M.trim_string(s)
  return (s:gsub('^%s*(.-)%s*$', '%1'))
end

function M.pad_string(s)
  return ' ' .. s .. ' '
end

function M.last(list)
  return list[#list]
end

function M.remove_linebreaks(str)
  return str:gsub('[\n\r]', '')
end

function M.dec_to_hex(n, chars)
  chars = chars or 6
  local hex = string.format('%0' .. chars .. 'x', n)
  while #hex < chars do
    hex = '0' .. hex
  end
  return hex
end

function M.eval(fn)
  return fn()
end

function M.with_highlight_group(group_name, str)
  return '%#' .. group_name .. '#' .. str
end

--- Wrapper around vim.api.nvim_exec where the 2nd arg defaults to false
function M.vim_exec(cmds, capture_return)
  local result = vim.api.nvim_exec(cmds, true)
  if capture_return then
    return result
  else
    return nil
  end
end

---Check if a target directory exists in a given table
function M.dir_list_includes(dir, dirs_table)
  local dir_expanded = vim.fn.expand(dir)
  return dirs_table
    and next(vim.tbl_filter(function(pattern)
      return dir_expanded:match(vim.fn.expand(pattern))
    end, dirs_table))
end

function M.list_map(tbl, fn)
  local newTbl = {}
  for _, value in pairs(tbl) do
    table.insert(newTbl, fn(value))
  end
  return newTbl
end

function M.list_foreach(tbl, fn)
  for index, value in pairs(tbl) do
    fn(value, index)
  end
end

function M.list_concat(tbl, el)
  tbl = tbl or {}
  -- Note: Despite the deprecation warning, table.unpack does not work
  local new_tbl = { unpack(tbl) }
  table.insert(new_tbl, el)
  return new_tbl
end

-- Check if condition holds true for every element in a list
function M.list_every(tbl, predicateFn)
  local result = true
  M.list_foreach(tbl, function(value)
    local thisResult = predicateFn(value)
    if result == false or thisResult == false then
      result = false
    end
  end)
  return result
end

function M.list_join(tbl, sep)
  sep = sep or ''
  local result = ''
  M.list_foreach(tbl, function(el, index)
    result = result .. el
    if index ~= #tbl then
      result = result .. sep
    end
  end)
  return result
end

function M.list_find(tbl, fn)
  for _, element in ipairs(tbl) do
    if fn(element) then
      return true
    end
  end
end

function M.list_contains(tbl, value)
  return M.list_find(tbl, function(el)
    return el == value
  end)
end

return M
