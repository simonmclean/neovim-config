local function glob_to_lua_pattern(glob)
  return glob:gsub('%.', '%%.'):gsub('%*', '.*'):gsub('%?', '.') .. '$'
end

---Determines whether a file or directory should be ignored based on the given ignore patterns
---@param name string
---@param ignore_patterns string[]
---@return boolean
local function should_ignore(name, ignore_patterns)
  for _, pattern in ipairs(ignore_patterns) do
    if name:match(pattern) then
      return true
    end
  end
  return false
end

--- Reads the .gitignore file of a given directory (if it exists) and returns the ignore patterns
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
    vim.print(vim.inspect { ignore = ignore_patterns })

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
              if not should_ignore(entry.name, ignore_patterns) then
                local entry_path = dir .. '/' .. entry.name
                if entry.type == 'directory' then
                  search_dir(entry_path, ignore_patterns)
                elseif entry.type == 'file' and filenames[entry.name] then
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

--- Key is the path of a test file, relative to the project root.
--- Value is buffer number of the corresponding application file.
---@type { string: string }
local test_to_app_files = {}

--- Display list of possible test files in telescope
---@param matches string[]
local function show_results_in_telescope(matches)
  local current_buf = vim.api.nvim_win_get_buf(0)

  local pickers = require 'telescope.pickers'
  local finders = require 'telescope.finders'
  local sorters = require 'telescope.sorters'
  local actions_state = require 'telescope.actions.state'
  local actions = require 'telescope.actions'

  local cache_selection = function(prompt_bufnr)
    local selected_test_file = actions_state.get_selected_entry()
    test_to_app_files[selected_test_file] = current_buf
    actions.close(prompt_bufnr)
  end

  local opts = {
    finder = finders.new_table(matches),
    sorter = sorters.get_generic_fuzzy_sorter {},
    attach_mappings = function(_, map)
      map('n', '<cr>', cache_selection)
      map('i', '<cr>', cache_selection)
      return true
    end,
  }

  pickers
    .new(opts, {
      prompt_title = 'Test files',
      previewer = require('telescope.config').values.file_previewer {},
    })
    :find()
end

-- These will be searched with case insensitivity
local TEST_POSTFIXES = {
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
  for _, postfix in ipairs(TEST_POSTFIXES) do
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

---Performs the inverse of find_test(), expect it only works if you've done find_test() first
local function find_application_file()
  local current_file_path = vim.fn.expand '%'
  local source_file_buf = test_to_app_files[current_file_path]
  if source_file_buf and vim.api.nvim_buf_is_valid(source_file_buf) then
    vim.api.nvim_win_set_buf(source_file_buf)
  end
end

return find_test
