local u = require 'utils'

-- Load env.lua if it exists
local env_config = vim.fn.stdpath 'config' .. '/env.lua'
if vim.fn.filereadable(env_config) == 1 then
  dofile(env_config)
end

-- Globals required for starting lazy.nvim
vim.g.mapleader = ' '
vim.g.active_colorscheme = 'nord'
vim.g.winblend = 10

local cwd = vim.fn.getcwd()

local copilot_enabled_dirs = u.list_map(vim.g.copilot_enabled_dirs or {}, vim.fs.normalize)

---@type boolean
vim.g.copilot_enabled = u.list_contains(copilot_enabled_dirs, cwd)

-- It's important that this is actually a boolean, and not just falsy
assert(
  type(vim.g.copilot_enabled) == 'boolean',
  'Expected CopilotEnabled to be a boolean, found type: '
    .. type(vim.g.copilot_enabled)
    .. ', value: '
    .. tostring(vim.g.copilot_enabled)
)

require 'plugins'
require 'lsp/lsp'
require 'statusline.statusline'
