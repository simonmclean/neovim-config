local u = require 'utils'

local M = {}

---@class KeyMap
---@field key string
---@field fn function
---@field desc string
---@field short_desc string

---@class KeyMapConfig
---@field controls KeyMap[]
---@field navigation KeyMap[]

---@class Config
---@field elements ('scopes' | 'stacks' | 'watches' | 'repl' | 'breakpoints' | 'console')[]
---@field keys KeyMapConfig
---@field keyscope 'local' | 'global'
---@field focus_delay_ms integer
---@field after_control_key fun(keymap: KeyMap) | nil

---@type ('scopes' | 'stacks' | 'watches' | 'repl' | 'breakpoints' | 'console')[]
local default_elements = {
  'scopes',
  'stacks',
  'watches',
  'repl',
  'breakpoints',
  'console',
}

---@type KeyMapConfig
local default_keymaps = {
  navigation = {
    {
      key = '<C-l>',
      fn = function()
        M.next()
      end,
      short_desc = '',
      desc = 'DAP UI next',
    },
    {
      key = '<C-h>',
      fn = function()
        M.prev()
      end,
      short_desc = '',
      desc = 'DAP UI prev',
    },
  },
  controls = {
    {
      key = ']',
      fn = function()
        require('dap').continue()
      end,
      desc = 'DAP continue',
      short_desc = 'Continue',
    },
    {
      key = '>',
      fn = function()
        require('dap').step_into()
      end,
      desc = 'DAP step into',
      short_desc = 'Step into',
    },
    {
      key = '}',
      fn = function()
        require('dap').step_over()
      end,
      desc = 'DAP step over',
      short_desc = 'Step over',
    },
    {
      key = '^',
      fn = function()
        require('dap').step_out()
      end,
      desc = 'DAP step out',
      short_desc = 'Step out',
    },
    {
      key = 'T',
      fn = function()
        require('dap').terminate()
      end,
      desc = 'DAP terminate',
      short_desc = 'Terminate',
    },
    {
      key = 'R',
      fn = function()
        require('dap').run_last()
      end,
      desc = 'DAP rerun',
      short_desc = 'Rerun',
    },
  },
}

--@type Config
local default_config = {
  keys = default_keymaps,
  elements = default_elements,
  keyscope = 'local',
  focus_delay_ms = 200,
}

M.config = default_config

---@class DapUiWin
---@field elements string[]
---@field win number
---@field active_index number
local DapUiWin = {}

---@type { [number]: DapUiWin }
local tabpage_instances = {}

M.open = function()
  local tabpage = vim.api.nvim_get_current_tabpage()

  -- If this tabpage already has an instance, focus it, then return
  if tabpage_instances[tabpage] then
    if vim.api.nvim_win_is_valid(tabpage_instances[tabpage].win) then
      vim.api.nvim_set_current_win(tabpage_instances[tabpage].win)
    else
      vim.print('Win not found: ' .. tostring(tabpage_instances[tabpage].win))
    end
    return
  end

  local instance = {}
  setmetatable(instance, { __index = DapUiWin })
  instance.active_index = 1

  -- Register the instance against this tabpage
  tabpage_instances[tabpage] = instance

  -- Open new win
  vim.cmd 'new'
  vim.cmd 'wincmd J'
  instance.win = vim.api.nvim_get_current_win()

  -- Populate win with dapui element
  instance:update_win()

  -- Setup autocmd to unregister the tabpage instance when the win is closed
  vim.api.nvim_create_autocmd('WinClosed', {
    pattern = tostring(instance.win),
    callback = function()
      tabpage_instances[vim.api.nvim_get_current_tabpage()] = nil
      return true
    end,
    once = true,
  })
end

M.focus = function()
  local tabpage = vim.api.nvim_get_current_tabpage()
  local instance = tabpage_instances[tabpage]
  if instance then
    vim.api.nvim_set_current_win(instance.win)
  end
end

M.next = function()
  local tabpage = vim.api.nvim_get_current_tabpage()
  local instance = tabpage_instances[tabpage]

  if instance then
    if instance.active_index == #M.config.elements then
      instance.active_index = 1
    else
      instance.active_index = instance.active_index + 1
    end
    instance:update_win()
  end
end

M.prev = function()
  local tabpage = vim.api.nvim_get_current_tabpage()
  local instance = tabpage_instances[tabpage]

  if instance then
    if instance.active_index == 1 then
      instance.active_index = #M.config.elements
    else
      instance.active_index = instance.active_index - 1
    end
    instance:update_win()
  end
end

function M.close_all()
  for _, instance in pairs(tabpage_instances) do
    if vim.api.nvim_win_is_valid(instance.win) then
      vim.api.nvim_win_close(instance.win, true)
    end
  end
end

---@private
function DapUiWin:set_winbar()
  --TODO: click handler
  local tab_titles = {}
  local active_element = M.config.elements[self.active_index]
  for _, element in ipairs(M.config.elements) do
    local hi = element == active_element and 'Title' or 'Comment'
    table.insert(tab_titles, u.with_highlight_group(hi, element))
  end
  local rhs = '| ' .. u.list_join(tab_titles, ' | ') .. ' | '
  ---@type KeyMap[]
  local keymaps_with_hi = vim.tbl_map(function(keymap)
    return '' .. u.with_highlight_group('title', keymap.key) .. ' ' .. keymap.short_desc .. ' '
  end, M.config.keys.controls)
  local lhs = u.list_join(keymaps_with_hi, ' ')
  local winbar = u.pad_string(lhs .. '%=' .. rhs)
  vim.api.nvim_set_option_value('winbar', winbar, { win = self.win })
end

function DapUiWin:update_win()
  local element = M.config.elements[self.active_index]
  local element_buf = require('dapui').elements[element].buffer()
  vim.api.nvim_win_set_buf(self.win, element_buf)
  self:set_winbar()
  for _, keymap in ipairs(M.config.keys.controls) do
    local fn = function()
      keymap.fn()
      if M.config.after_control_key then
        M.config.after_control_key(keymap)
      end
    end
    vim.keymap.set(
      'n',
      keymap.key,
      fn,
      { buffer = M.config.keyscope == 'local' and element_buf or nil, desc = keymap.desc }
    )
  end
  for _, keymap in ipairs(M.config.keys.navigation) do
    vim.keymap.set(
      'n',
      keymap.key,
      keymap.fn,
      { buffer = M.config.keyscope == 'local' and element_buf or nil, desc = keymap.desc }
    )
  end
end

local function notify_missing_dep(name)
  vim.notify('dap-ui-win is missing dependancy: ' .. name, vim.log.levels.WARN)
end

---@param user_config? Config | {}
M.setup = function(user_config)
  local dap_installed, dap = pcall(require, 'dap')
  local dap_ui_installed, _ = pcall(require, 'dapui')

  if not dap_installed then
    return notify_missing_dep 'dap'
  end

  if not dap_ui_installed then
    return notify_missing_dep 'dapui'
  end

  if user_config then
    M.config = vim.tbl_deep_extend('force', default_config, user_config)
  end

  vim.api.nvim_create_user_command('DapUiWin', M.open, {})

  vim.print("SETUP!!!")
  local event_key = 'dap_ui_win'
  dap.listeners.after.event_stopped[event_key] = function()
    vim.defer_fn(M.open, M.config.focus_delay_ms)
  end
  dap.listeners.before.event_terminated[event_key] = M.close_all
  dap.listeners.before.event_exited[event_key] = M.close_all
end

return M
