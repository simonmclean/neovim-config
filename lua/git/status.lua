local u = require 'utils'
local uv = vim.loop

local DEBOUNCE_MS = 1000
local REF_LOG_POLL_MS = 1000
local FETCH_INTERVAL_SECONDS = 60
local DEBUG_LOG_MAX_LENGTH = 40

---@class GitStatusTrackedChanges
---@field deleted string[]
---@field modified string[]
---@field added string[]

---@class GitStatusChanges
---@field staged GitStatusTrackedChanges
---@field unstaged GitStatusTrackedChanges
---@field untracked string[]

---@class GitStatus
---@field changes GitStatusChanges
---@field local_commits_not_in_remote integer
---@field remote_commits_not_in_local integer

---@class GitRepo
---@field root string
---@field status GitStatus
---@field branch_local string
---@field branch_remote? string

---@class Git
---@field state 'NO_REPO' | 'INITIALISING' | 'READY'
---@field repo GitRepo

local cache = {
  last_fetch_time = 0,
  mtimes = {
    index = { sec = 0, nsec = 0 },
    head = { sec = 0, nsec = 0 },
  },
  debug_log = {},
}

local debug_mode = false

---Append to debug log
---@param msg string
local function log(msg)
  local msg_formatted = string.format('[%s] %s', os.date '%X', msg)
  table.insert(cache.debug_log, msg_formatted)
  if #cache.debug_log > DEBUG_LOG_MAX_LENGTH then
    table.remove(cache.debug_log, 1)
  end
  if debug_mode then
    vim.notify('git status ' .. msg_formatted)
  end
end

---@param output string output of `git status --porcelain`
---@return GitStatusChanges
local function parse_git_status(output)
  ---@type GitStatusChanges
  local changes = {
    staged = { deleted = {}, modified = {}, added = {} },
    unstaged = { deleted = {}, modified = {}, added = {} },
    untracked = {},
  }

  for line in output:gmatch '[^\r\n]+' do
    --- staged files
    local index_status = line:sub(1, 1)
    --- unstaged files
    local working_tree_status = line:sub(2, 2)
    --- untracked files
    local path_str = line:sub(4)

    if index_status and working_tree_status then
      if index_status == '?' and working_tree_status == '?' then
        table.insert(changes.untracked, path_str)
      else
        -- get the final path, ignoring the orig_path if any
        local path = path_str:match '.*%->%s*(.*)$' or path_str

        local function bucket(side, code)
          if code == 'A' then
            table.insert(changes[side].added, path)
          elseif code == 'M' or code == 'R' or code == 'C' then
            table.insert(changes[side].modified, path)
          elseif code == 'D' then
            table.insert(changes[side].deleted, path)
          end
        end

        bucket('staged', index_status)
        bucket('unstaged', working_tree_status)
      end
    end
  end

  return changes
end

---Count how many commits ahead and behind local is compared to remote (does not fetch)
---@param callback fun(result: { ahead: integer, behind: integer })
local function count_ahead_behind(callback)
  u.system('git rev-list --left-right --count HEAD...@{upstream}', function(response)
    if not string.find(response, 'fatal: no upstream') then
      local ok, ahead, behind = pcall(string.match, response, '(%d+)%s*(%d+)')
      if not ok then
        ahead, behind = 0, 0
        error('Unable to parse response in function count_ahead_behind: ' .. tostring(response))
      end
      log(response)
      callback {
        ahead = tonumber(ahead) or 0,
        behind = tonumber(behind) or 0,
      }
    else
      log 'No upstream found'
      callback { ahead = 0, behind = 0 }
    end
  end)
end

---@param callback fun(result: { local_branch: string, remote_branch?: string })
local function get_current_branch_name(callback)
  u.system('git rev-parse --abbrev-ref HEAD', function(local_branch)
    u.system('git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null', function(maybe_remote_branch)
      local remote_branch
      if maybe_remote_branch and maybe_remote_branch ~= '' then
        remote_branch = maybe_remote_branch
      end
      callback {
        local_branch = local_branch,
        remote_branch = remote_branch,
      }
    end)
  end)
end

---Check if current working directory is a git repo. Result is cached
---@return string| false - repo root path or false if a not a repo
local function get_repo_root()
  -- This is deliberately not async
  local is_git_installed = type(vim.trim(vim.fn.system 'command -v git')) == 'string'

  if not is_git_installed then
    return false
  end

  local in_repo = vim.trim(vim.fn.system 'git rev-parse --is-inside-work-tree') == 'true'

  if not in_repo then
    return false
  end

  return vim.trim(vim.fn.system 'git rev-parse --show-toplevel')
end

local redrawstatus_debounced = u.debounce_trailing(function()
  log 'redrawstatus'
  vim.schedule(function()
    vim.cmd.redrawstatus()
  end)
end, DEBOUNCE_MS)

local augroup = vim.api.nvim_create_augroup('GitAugroup', { clear = true })

---Refresh the all the fields in vim.g.git (does not fetch)
---@param callback? fun()
---@param repo_root? string
local function refresh_state(callback, repo_root)
  log 'refresh_state()'
  u.system('git status --porcelain', function(status)
    get_current_branch_name(function(branches)
      if not branches.local_branch then
        error 'Failed to get local branch name'
      end

      local changes = parse_git_status(status)

      count_ahead_behind(function(commits)
        ---@type GitRepo
        local repo = {
          root = repo_root or vim.g.git.repo.root,
          branch_local = branches.local_branch,
          branch_remote = branches.remote_branch,
          status = {
            changes = changes,
            local_commits_not_in_remote = commits.ahead,
            remote_commits_not_in_local = commits.behind,
          },
        }

        ---@type Git
        vim.g.git = {
          state = 'READY',
          repo = repo,
        }

        redrawstatus_debounced()

        if callback then
          callback()
        end
      end)
    end)
  end)
end

local refresh_state_debounced = u.debounce_trailing(refresh_state, DEBOUNCE_MS)

---@param callback? fun()
local function fetch(callback)
  log 'fetch()'
  u.system('git fetch', function()
    cache.last_fetch_time = os.time()
    redrawstatus_debounced()
    if callback then
      callback()
    end
  end)
end

local function fetch_and_refresh()
  log 'fetch_and_refresh()'
  fetch(refresh_state_debounced)
end

local fetch_and_refresh_debounced = u.debounce_trailing(fetch_and_refresh, DEBOUNCE_MS)

--- Watch for changes in the reflog
--- @param repo_root string
local function watch_commits(repo_root)
  log 'watch_commits()'
  local reflog = repo_root .. '/.git/logs/HEAD'

  local poll = uv.new_fs_poll()
  poll:start(reflog, REF_LOG_POLL_MS, function(err, prev, curr)
    log 'watch_commits -> callback()'
    if err then
      error('error in reflow watcher: ' .. err, vim.log.levels.ERROR)
    elseif curr.mtime.sec ~= prev.mtime.sec or curr.mtime.nsec ~= prev.mtime.nsec then
      log 'detected reflog change'
      fetch_and_refresh_debounced()
    end
  end)
end

--- Check if git status has changed by checking the mtime of the index and HEAD files.
--- @param repo_root string
--- @return boolean true if either file’s mtime has advanced
local function has_changed(repo_root)
  log 'has_changed()'
  local index_path = repo_root .. '/.git/index'
  local head_path = repo_root .. '/.git/HEAD'
  local idx_stat = uv.fs_stat(index_path)
  local hd_stat = uv.fs_stat(head_path)
  if not idx_stat or not hd_stat then
    return false
  end

  local changed = false

  if idx_stat.mtime.sec ~= cache.mtimes.index.sec or idx_stat.mtime.nsec ~= cache.mtimes.index.nsec then
    cache.mtimes.index = idx_stat.mtime
    changed = true
  end

  if hd_stat.mtime.sec ~= cache.mtimes.head.sec or hd_stat.mtime.nsec ~= cache.mtimes.head.nsec then
    cache.mtimes.head = hd_stat.mtime
    changed = true
  end

  log(tostring(changed))
  return changed
end

local has_changed_debounced = u.debounce_trailing(has_changed, DEBOUNCE_MS)

---Sets up an autocmd which listens for certain events and updates the state
---@param repo_root string
local function setup_refresh_autocmd(repo_root)
  log 'setup_refresh_autocmd()'
  local events = { 'BufEnter', 'BufWritePost', 'FocusGained' }

  vim.api.nvim_create_autocmd(events, {
    group = augroup,
    callback = function()
      log 'refresh_autocmd -> callback()'
      if has_changed_debounced(repo_root) then
        refresh_state_debounced()
      end
    end,
  })
end

---Runs git fetch on every n seconds
local function setup_fetch_interval()
  log 'setup_fetch_interval()'
  local interval_ms = FETCH_INTERVAL_SECONDS * 1000
  uv.new_timer():start(
    interval_ms,
    interval_ms,
    vim.schedule_wrap(function()
      log 'fetch_interval -> callback()'
      if os.difftime(os.time(), cache.last_fetch_time) >= FETCH_INTERVAL_SECONDS then
        fetch_and_refresh_debounced()
      else
        log 'not fetching, last fetch was too recent'
      end
    end)
  )
end

---Create command to view debug logs
local function create_log_command()
  vim.api.nvim_create_user_command('GitDebugLog', function()
    vim.print(u.list_join(cache.debug_log, '\n'))
  end, {})
end

local function init()
  vim.g.git = {
    state = 'INITIALISING',
  }

  create_log_command()

  local repo_root = get_repo_root()

  if not repo_root then
    log 'Not a git repo'
    vim.g.git = {
      state = 'NO_REPO',
    }
    return
  end

  fetch(function()
    refresh_state(function()
      local repo = vim.g.git.repo
      setup_refresh_autocmd(repo.root)
      setup_fetch_interval()
      watch_commits(repo.root)
    end, repo_root)
  end)
end

return {
  setup = function()
    if not vim.g.git then
      init()
    end
  end,
}
