-- Creates a command which jumps between corresponding test and source files

local u = require 'utils'

---Convert gitignore globs into lua patterns (which are like very simplified regex)
local function glob_to_lua_pattern(glob)
  return glob:gsub('%.', '%%.'):gsub('%*', '.*'):gsub('%?', '.') .. '$'
end

---Determines whether a file or directory should be ignored based on the given patterns
---@param name string
---@param ignore_patterns string[]
---@return boolean
local function should_ignore(name, is_dir, ignore_patterns)
  -- .git isn't usually included in the gitignore, so we're hard-coding here
  if is_dir and name == '.git' then
    return true
  end

  for _, pattern in ipairs(ignore_patterns) do
    if name:match(pattern) then
      return true
    end
    -- Directories can be with or without trailing slash, so we check this as well
    if is_dir and (name .. '/'):match(pattern) then
      return true
    end
  end

  return false
end

---Reads the .gitignore file of a given directory (if it exists) and returns the ignore patterns
---@param dir string path
---@return string[]
local function read_gitignore(dir)
  local ignore_patterns = {}
  local gitignore_path = dir .. '/.gitignore'
  local gitignore_file = io.open(gitignore_path, 'r')
  if gitignore_file then
    for line in gitignore_file:lines() do
      if not (line:match '^#' or line:match '^%s*$') then
        table.insert(ignore_patterns, glob_to_lua_pattern(line))
      end
    end
    gitignore_file:close()
  end
  return ignore_patterns
end

---Deep search in current working directory for files (case insensitive)
---@param filenames { string: boolean }
---@param callback fun(matches: string[]): nil function that takes a list of paths
local function find_files_async(filenames, callback)
  local matches = {}
  local active_search_count = 0

  local function on_search_complete()
    active_search_count = active_search_count - 1
    if active_search_count == 0 then
      callback(matches)
    end
  end

  local function on_error(err)
    error(err)
    on_search_complete()
  end

  local function search_dir(dir, parent_ignore_patterns)
    active_search_count = active_search_count + 1
    parent_ignore_patterns = parent_ignore_patterns or {}
    local directory_ignore_patterns = read_gitignore(dir)
    local ignore_patterns = {}
    for _, pattern in ipairs(parent_ignore_patterns) do
      table.insert(ignore_patterns, pattern)
    end
    for _, pattern in ipairs(directory_ignore_patterns) do
      table.insert(ignore_patterns, pattern)
    end

    ---@diagnostic disable-next-line: discard-returns
    vim.loop.fs_opendir(dir, function(err, handle)
      if err then
        on_error(err)
      end

      local function read_next()
        vim.loop.fs_readdir(handle, function(err2, entries)
          if err2 then
            on_error(err2)
          end

          if entries then
            for _, entry in ipairs(entries) do
              if not should_ignore(entry.name, entry.type == 'directory', ignore_patterns) then
                local entry_path = dir .. '/' .. entry.name
                if entry.type == 'directory' then
                  search_dir(entry_path, ignore_patterns)
                elseif entry.type == 'file' and filenames[string.lower(entry.name)] then
                  table.insert(matches, entry_path)
                end
              end
            end

            read_next()
          else
            vim.loop.fs_closedir(handle)
            on_search_complete()
          end
        end)
      end

      read_next()
    end)
  end

  search_dir(vim.fn.getcwd())
end

---Convert absolute path to relative
---@param absolute_path string
---@return string
local function absolute_to_relative_path(absolute_path)
  local cwd = vim.fn.getcwd()
  return absolute_path:sub(#cwd + 2)
end

-- These will be searched with case insensitivity
local TEST_POSTFIXES = {
  '_spec',
  '_test',
  '.spec',
  '.test',
  -- These two need to come last because of the matching logic
  'spec',
  'test',
}

---@param matches string[]
local function handle_search_results(matches)
  if #matches == 0 then
    u.fidget_notify 'No test/source match found'
  elseif #matches == 1 then
    vim.cmd.edit(matches[1])
  else
    local matches_relative = {}
    for _, match in ipairs(matches) do
      table.insert(matches_relative, absolute_to_relative_path(match))
    end
    vim.ui.select(matches, { prompt = 'Select file' }, function(choice)
      if not choice then
        return
      end
      vim.cmd.edit(choice)
    end)
  end
end

---Find the test file that corresponds to the current buffer, assuming the current buffer is a source file
local function find_test()
  local current_filename_without_extension = vim.fn.expand '%:t:r'
  local current_file_extension = vim.fn.expand '%:e'
  local filenames_to_search_for = {}
  for _, postfix in ipairs(TEST_POSTFIXES) do
    local test_filename = current_filename_without_extension .. postfix .. '.' .. current_file_extension
    filenames_to_search_for[string.lower(test_filename)] = true
  end
  find_files_async(filenames_to_search_for, vim.schedule_wrap(handle_search_results))
end

---Find the source file that corresponds to current buffer, assuming the current buffer is a test file
---@param filename string
local function find_source(filename)
  local filename_lower = string.lower(filename)
  find_files_async({ [filename_lower] = true }, vim.schedule_wrap(handle_search_results))
end

---Figures out whether we're in a test or source file, then finds the other one in the pair
local function find_sister_file()
  local current_filename_without_extension = vim.fn.expand '%:t:r'
  for _, postfix in ipairs(TEST_POSTFIXES) do
    local postfix_escaped = u.escape_pattern(postfix)
    local match = string.lower(current_filename_without_extension):match(postfix_escaped .. '$')
    if match then
      local current_file_extension = vim.fn.expand '%:e'
      local current_filename_without_test_postfix =
        current_filename_without_extension:sub(1, #current_filename_without_extension - #match)
      local source_file_name = current_filename_without_test_postfix .. '.' .. current_file_extension
      return find_source(source_file_name)
    end
  end
  find_test()
end

vim.api.nvim_create_user_command('GotoTest', find_sister_file, { desc = 'Toggle search test and source file' })
