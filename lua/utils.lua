local M = {}

---@class Keymap
---@field [1] string keys
---@field [2] string|function vim command or lua function
---@field [3] string description
---@field modes? string|string[] defaults to "n"
---@field opts? table

---set a list of keymaps with sensible default options
---@param keys Keymap[]
function M.keys(keys)
  for _, keymap in ipairs(keys) do
    local default_opts = {
      silent = true,
      nowait = true,
      desc = keymap[3],
    }
    local opts_merged = vim.tbl_extend('force', default_opts, keymap.opts or {})
    vim.keymap.set(keymap.modes or 'n', keymap[1], keymap[2], opts_merged)
  end
end

---set a list of buffer-local keymaps with sensible default options
---@param buffer number
---@param keys Keymap[]
function M.buf_keys(buffer, keys)
  for _, keymap in ipairs(keys) do
    keymap.opts = vim.tbl_extend('force', keymap.opts or {}, { buffer = buffer })
  end
  M.keys(keys)
end

---Set a list of a vim.opts
---@param opts table<string, any>
function M.options(opts)
  for key, value in pairs(opts) do
    vim.opt[key] = value
  end
end

---Safe access of buffer varaible. Handles nil case
---@param name string
---@param buf number?
---@return unknown
function M.buf_get_var(name, buf)
  local ok, value = pcall(vim.api.nvim_buf_get_var, buf or 0, name)
  if not ok then
    return nil
  end
  return value
end

--- Check if a value is defined (not nil or empty).
--- @param value nil|string|table: The value to check.
--- @return boolean: True if the value is defined, false otherwise.
function M.is_defined(value)
  if type(value) == 'table' then
    return next(value) ~= nil
  end
  if value == nil or value == '' then
    return false
  end
  return true
end

--- Split a string by a given delimiter.
--- @param str string: The string to split.
--- @param delimiter string: The delimiter to split by.
--- @return string[]: A table of substrings.
function M.split_string(str, delimiter)
  local result = {}
  for match in (str .. delimiter):gmatch('(.-)' .. delimiter) do
    table.insert(result, match)
  end
  return result
end

--- Trim whitespace from both ends of a string.
--- @param s string: The string to trim.
--- @return string: The trimmed string.
function M.trim_string(s)
  return (s:gsub('^%s*(.-)%s*$', '%1'))
end

--- Pad a string with spaces on both sides.
--- @param s string: The string to pad.
--- @return string: The padded string.
function M.pad_string(s)
  return ' ' .. s .. ' '
end

--- Get the last element of a list.
--- @param list any[]: The list to get the last element from.
--- @return any: The last element of the list.
function M.last(list)
  return list[#list]
end

--- Remove line breaks from a string.
--- @param str string: The string to process.
--- @return string: The string without line breaks.
function M.remove_linebreaks(str)
  return (str:gsub('[\n\r]', ''))
end

---Remove trailing line break from a string
---@param str string
---@return string
function M.remove_trailing_linebreak(str)
  return (str:gsub('[\n\r]*$', ''))
end

--- Convert a decimal number to a hexadecimal string.
--- @param n number: The decimal number to convert.
--- @param chars number|nil: The number of characters in the resulting string (default is 6).
--- @return string: The hexadecimal string.
function M.dec_to_hex(n, chars)
  chars = chars or 6
  local hex = string.format('%0' .. chars .. 'x', n)
  while #hex < chars do
    hex = '0' .. hex
  end
  return hex
end

--- Evaluate a function and return its result.
--- @param fn function: The function to evaluate.
--- @return any: The result of the function.
function M.eval(fn)
  return fn()
end

--- Wrap a string with a highlight group.
--- @param group_name string: The name of the highlight group.
--- @param str string: The string to wrap.
--- @return string: The wrapped string.
function M.with_highlight_group(group_name, str)
  return '%#' .. group_name .. '#' .. str .. '%*'
end

--- Check if a target directory exists in a given table.
--- @param dir string: The directory to check.
--- @param dirs_table string[]: The table of directories to check against.
--- @return boolean: True if the directory exists in the table, false otherwise.
function M.dir_list_includes(dir, dirs_table)
  local dir_expanded = vim.fn.expand(dir)
  return dirs_table
    and next(vim.tbl_filter(function(pattern)
        return dir_expanded:match(vim.fn.expand(pattern))
      end, dirs_table))
      ~= nil
end

--- Apply a function to each element in a list and return a new list with the results.
--- @param tbl any[]: The list to map over.
--- @param fn function: The function to apply to each element.
--- @return any[]: A new list with the results.
function M.list_map(tbl, fn)
  local newTbl = {}
  for _, value in pairs(tbl) do
    table.insert(newTbl, fn(value))
  end
  return newTbl
end

--- Apply a function to each element in a list.
--- @param tbl any[]: The list to iterate over.
--- @param fn function: The function to apply to each element.
function M.list_foreach(tbl, fn)
  for index, value in pairs(tbl) do
    fn(value, index)
  end
end

--- Concatenate an element to a list.
--- @param tbl any[]: The list to concatenate to.
--- @param el any: The element to concatenate.
--- @return any[]: A new list with the element concatenated.
function M.list_concat(tbl, el)
  tbl = tbl or {}
  -- Note: Despite the deprecation warning, table.unpack does not work
  local new_tbl = { unpack(tbl) }
  table.insert(new_tbl, el)
  return new_tbl
end

--- Check if a condition holds true for every element in a list.
--- @param tbl any[]: The list to check.
--- @param predicateFn function: The function to apply to each element.
--- @return boolean: True if the condition holds for every element, false otherwise.
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

--- Join a list of strings with a separator.
--- @param tbl string[]: The list of strings to join.
--- @param sep string: The separator to use.
--- @return string: The joined string.
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

--- Find an element in a list that satisfies a condition.
--- @param tbl any[]: The list to search.
--- @param fn function: The function to apply to each element.
--- @return any
function M.list_find(tbl, fn)
  for _, element in ipairs(tbl) do
    if fn(element) then
      return element
    end
  end
  return false
end

--- Check if a list contains a value.
--- @param tbl any[]: The list to check.
--- @param value any: The value to check for.
--- @return boolean: True if the list contains the value, false otherwise.
function M.list_contains(tbl, value)
  return M.list_find(tbl, function(el)
    return el == value
  end) ~= false
end

---@param message string
function M.warn(message)
  vim.schedule(function()
    vim.notify(message, vim.log.levels.WARN)
  end)
end

---Wrapper around fidget. Falls back to vim.notify()
---@param msg string
---@param level? ('warn' | 'info') Error level excluded deliberately. Use error() instead
---@param group? string
---@param group_title? string
function M.fidget_notify(msg, level, group, group_title)
  local has_fidget, fidget = pcall(require, 'fidget.notification')
  local l = level == 'warn' and vim.log.levels.WARN or vim.log.levels.INFO
  if has_fidget then
    fidget.notify(msg, l, { group = group, annote = group_title })
  else
    vim.notify(msg)
  end
end

---Run a lua function asynchronously. For external system commands, use M.system
---@param fn function
---@param callback? fun(data: any): nil
function M.async(fn, callback)
  local co = coroutine.create(function()
    local result = fn()
    if callback then
      callback(result)
    end
  end)

  local handle = vim.loop.new_idle()
  vim.loop.idle_start(handle, function()
    if coroutine.status(co) == 'dead' then
      vim.loop.idle_stop(handle)
    else
      coroutine.resume(co)
    end
  end)
end

---Run external system command asynchronously
---
---A note on error handling:
---Data being sent to the stderr stream does not necessarily constitute a failure state.
---For example, the normal output of `git fetch` goes to stderr, as it's considered diagnostic information.
---That's why this function only takes a single callback, with a single parameter, which is the response from either
---stdout or stderr. What output constitutes an actual failure state depends on the command, and cannot be
---generalised in this function. Therefore it's up to the caller to parse the response and decide how to handle it.
---@param cmd string
---@param callback? fun(result: string)
function M.system(cmd, callback)
  local stdout = vim.loop.new_pipe(false)
  local stderr = vim.loop.new_pipe(false)
  local output = ''
  local handle

  handle = vim.loop.spawn('/bin/sh', {
    args = { '-c', cmd },
    stdio = { nil, stdout, stderr },
  }, function()
    stdout:close()
    stderr:close()
    if handle then
      handle:close()
    end
    if callback then
      vim.schedule(function()
        -- Trailing newline is annoying for single line responses
        callback(M.remove_trailing_linebreak(output))
      end)
    end
  end)

  ---@param err? string error
  ---@param data? string
  local function capture_output(err, data)
    if err then
      error(err)
    end
    if data then
      output = output .. data
    end
  end

  stderr:read_start(capture_output)
  stdout:read_start(capture_output)
end

---Wrapper for vim.fn.confirm
---@param question string
---@return boolean true if user picks yes
function M.confirm(question)
  return vim.fn.confirm(question, '&Yes\n&No', 2) == 1
end

--- Escape a string for use in a Lua pattern.
---@param str string
---@return string
---@return integer count
function M.escape_pattern(str)
  return str:gsub('%.', '%%.')
end

--- Heuristically check if a file is a test file based on its path.
--- @param path string
--- @return boolean
function M.is_test_file(path)
  local test_words = {
    '.test',
    '.spec',
    '_test',
    '_spec',
  }

  for _, word in ipairs(test_words) do
    if path:match(M.escape_pattern(word)) then
      return true
    end
  end

  return false
end

--- Debounces a function on the trailing edge
--- Credit: https://gist.github.com/runiq/31aa5c4bf00f8e0843cd267880117201
--- @param fn function
--- @param timeout_ms number
--- @return function, table - Debounced function and timer. Remember to call `timer:close()` to avoid memory leak
function M.debounce_trailing(fn, timeout_ms)
  local timer = vim.loop.new_timer()
  local wrapped_fn

  function wrapped_fn(...)
    local argv = { ... }
    local argc = select('#', ...)

    timer:start(timeout_ms, 0, function()
      pcall(vim.schedule_wrap(fn), unpack(argv, 1, argc))
    end)
  end

  return wrapped_fn, timer
end

return M
