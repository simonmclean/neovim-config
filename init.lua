local u = require 'utils'

-- Load env.lua if it exists
local env_config = vim.fn.stdpath 'config' .. '/env.lua'
if vim.fn.filereadable(env_config) == 1 then
  dofile(env_config)
end

-- Must be mapped before loading Lazy
vim.g.mapleader = ' '

local cwd = vim.fn.getcwd()

local copilot_enabled_dirs = u.list_map(vim.g.copilot_enabled_dirs or {}, vim.fs.normalize)

---@type boolean
CopilotEnabled = u.list_contains(copilot_enabled_dirs, cwd)

-- It's important that this is actually a boolean, and not just falsy
assert(type(CopilotEnabled) == 'boolean', 'Expected CopilotEnabled to be a boolean, found: ' .. type(CopilotEnabled))

IsCwdAGitRepo = u.eval(function()
  local is_git_installed = type(vim.trim(vim.fn.system 'command -v git')) == 'string'
  if not is_git_installed then
    return false
  end
  return vim.trim(vim.fn.system 'git rev-parse --is-inside-work-tree') == 'true'
end)

require 'plugins'
