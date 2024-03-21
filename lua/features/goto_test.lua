local IGNORE_DIRS = {
  ['.git'] = true,
}

local function glob_to_lua_pattern(glob)
  return glob:gsub('%.', '%%.'):gsub('%*', '.*'):gsub('%?', '.') .. '$'
end

local function should_ignore(name, ignore_patterns)
  for _, pattern in ipairs(ignore_patterns) do
    if name:match(pattern) then
      return true
    end
  end
  return false
end

local function read_gitignore(dir)
  local ignore_patterns = {}
  local gitignore_path = dir .. '/.gitignore'
  local gitignore_file = io.open(gitignore_path, 'r')
  if gitignore_file then
    for line in gitignore_file:lines() do
      if not (line:match("^#") or line:match("^%s*$"))  then
        table.insert(ignore_patterns, glob_to_lua_pattern(line))
      end
    end
    gitignore_file:close()
  end
  return ignore_patterns
end

-- TODO: Read gitignore
local function is_ignored_dir(dirname)
  return IGNORE_DIRS[dirname] or false
end

--- Deep search in current working directory for files (case insensitive)
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
    vim.print(err)
    on_search_complete()
  end

  local function search_dir(dir)
    active_search_count = active_search_count + 1
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
              local entry_path = dir .. '/' .. entry.name
              if entry.type == 'directory' and not is_ignored_dir(entry.name) then
                search_dir(entry_path)
              elseif entry.type == 'file' and filenames[entry.name] then
                table.insert(matches, entry_path)
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

--- Display list of possible test files in telescope
---@param matches string[]
local function show_results_in_telescope(matches)
  local pickers = require 'telescope.pickers'
  local finders = require 'telescope.finders'
  local sorters = require 'telescope.sorters'
  local opts = {
    finder = finders.new_table(matches),
    sorter = sorters.get_generic_fuzzy_sorter {},
  }
  pickers
    .new(opts, {
      prompt_title = 'Test files',
      previewer = require('telescope.config').values.file_previewer {},
    })
    :find()
end

-- These will be searched with case insensitivity
local test_postfixes = {
  'spec',
  'test',
  '_spec',
  '_test',
  '.spec',
  '.test',
}

local function find_test()
  local filename_without_extension = vim.fn.expand '%:t:r'
  local file_extension = vim.fn.expand '%:e'
  local filenames = {}
  for _, postfix in ipairs(test_postfixes) do
    local test_filename = filename_without_extension .. postfix .. '.' .. file_extension
    filenames[test_filename] = true
  end
  find_files_async(
    filenames,
    vim.schedule_wrap(function(matches)
      if #matches == 0 then
        return vim.notify('No test suite found', vim.log.levels.WARN, {})
      end
      local matches_relative = {}
      for _, match in ipairs(matches) do
        table.insert(matches_relative, absolute_to_relative_path(match))
      end
      show_results_in_telescope(matches_relative)
    end)
  )
end

return find_test
