local u = require 'utils'
local statusline_mode = require 'features.statusline.statusline_mode'
local dev_icons = require 'nvim-web-devicons'

require('features.statusline.statusline_commits').new()

local is_git_repo = require('git').is_cwd_a_git_repo()

--------------------------------------------------------------------------
-- Highlight utils
--------------------------------------------------------------------------

-- Cache to store highlight groups so we don't recreate them unnecessarily
local hl_cache = {}

--- Get either the foreground (fg) or background (bg) color of a highlight group.
--- @param hl_name string
--- @param part ('fg' | 'bg')
--- @return string|nil - Hex color if found
local function get_hl_color(hl_name, part)
  local hl = vim.api.nvim_get_hl(0, { name = hl_name, link = false })
  -- Convert to hex strings
  if part == 'fg' then
    return hl.fg and string.format('#%06x', hl.fg)
  elseif part == 'bg' then
    return hl.bg and string.format('#%06x', hl.bg)
  end
end

--- Get or create a highlight group by combining the foreground of the icon highlight with the background of the winbar.
--- If the group has already been created, return it from the cache.
--- @param icon_hl string
--- @param bg_hl string
--- @return string
local function get_or_create_hl(icon_hl, bg_hl)
  local cache_key = icon_hl .. '_' .. bg_hl

  if hl_cache[cache_key] then
    return hl_cache[cache_key]
  end

  -- If not cached, retrieve the foreground color of the icon and background color of the winbar
  local icon_fg = get_hl_color(icon_hl, 'fg')
  local winbar_bg = get_hl_color(bg_hl, 'bg')
  local hl_group = cache_key

  vim.api.nvim_set_hl(0, hl_group, { fg = icon_fg, bg = winbar_bg })

  hl_cache[cache_key] = hl_group

  return hl_group
end

--- Return the properly highlighted string for the winbar with the icon.
--- Ensures the icon has the correct foreground (e.g., from DevIcon) and the correct background (from WinBar).
--- @param icon_hl string
--- @param icon_str string
--- @return string
local function highlight_with_icon(icon_hl, icon_str)
  local hl_group = get_or_create_hl(icon_hl, 'WinBar')
  return '%#' .. hl_group .. '#' .. icon_str .. '%#WinBar#'
end

local function highlight(hi_group_name, str)
  return '%#' .. hi_group_name .. '#' .. str .. '%#%Winbar#'
end

--------------------------------------------------------------------------
-- Icons
--------------------------------------------------------------------------

local icons = {
  git = '󰊢',
  dir = '',
  up_arrow = '',
  down_arrow = '',
  error = '',
  warn = '',
  hint = '',
  info = '',
  copilot_enabled = '',
  copilot_disabled = '',
}

--------------------------------------------------------------------------
-- Utils
--------------------------------------------------------------------------

---If the condition is not met, return a no-op component
---@param pred any predicate function or value
---@param component function component function (should return a string or nil)
---@return function
local function conditional_component(pred, component)
  local condition_met = u.eval(function()
    if type(pred) == 'function' then
      return pred()
    end
    return pred
  end)
  if condition_met then
    return component
  end
  return function() end
end

--------------------------------------------------------------------------
-- Components
--------------------------------------------------------------------------

local components = {}

components.push_right = '%='

components.filetype = '%y'

components.modification_status = function()
  if vim.bo.modified then
    return '[+]'
  end
end

components.readonly_status = function()
  if vim.bo.readonly then
    return '[RO]'
  end
end

components.cursor_position = function()
  local lines_count = vim.api.nvim_buf_line_count(0)
  local pos = vim.api.nvim_win_get_cursor(0)
  return pos[1] .. '/' .. lines_count
end

components.win_title = function(full_title)
  local filetype_title_overrides = {
    fugitive = 'Git',
    qf = 'Quickfix',
  }
  local buftype_title_overrides = {
    terminal = 'Terminal',
  }
  local filetype = vim.bo.filetype
  local buftype = vim.bo.buftype
  local title = u.eval(function()
    if filetype and filetype_title_overrides[filetype] then
      return filetype_title_overrides[filetype]
    end
    if buftype and buftype_title_overrides[buftype] then
      return buftype_title_overrides[buftype]
    end
    local maybe_title = full_title and vim.fn.expand '%:.' or vim.fn.expand '%:p'
    if u.is_defined(maybe_title) then
      return maybe_title
    end
    return filetype
  end)
  local icon, icon_hi
  if filetype then
    icon, icon_hi = dev_icons.get_icon_by_filetype(filetype)
  end
  return u.eval(function()
    if icon then
      return highlight_with_icon(icon_hi, icon) .. ' ' .. title
    end
    return title
  end)
end

components.diagnostics = function(buffer_local)
  local diagnostics = vim.diagnostic.get(u.eval(function()
    if buffer_local then
      return 0
    end
  end))

  if not u.is_defined(diagnostics) then
    return
  end

  local counts = { errors = 0, warnings = 0, hints = 0, info = 0 }

  for _, diag in ipairs(diagnostics) do
    if diag.severity == vim.diagnostic.severity.ERROR then
      counts.errors = counts.errors + 1
    elseif diag.severity == vim.diagnostic.severity.WARN then
      counts.warnings = counts.warnings + 1
    elseif diag.severity == vim.diagnostic.severity.HINT then
      counts.hints = counts.hints + 1
    elseif diag.severity == vim.diagnostic.severity.INFO then
      counts.info = counts.info + 1
    end
  end

  local str = ''
  if counts.errors > 0 then
    str = str .. string.format(' %s %d', icons.error, counts.errors)
  end
  if counts.warnings > 0 then
    str = str .. string.format(' %s %d', icons.warn, counts.warnings)
  end
  if counts.hints > 0 then
    str = str .. string.format(' %s %d', icons.hint, counts.hints)
  end
  if counts.info > 0 then
    str = str .. string.format(' %s %d', icons.info, counts.info)
  end
  return u.trim_string(str)
end

components.cwd = function()
  local path = vim.fn.getcwd()
  local dir = vim.fs.basename(path)
  return icons.dir .. ' ' .. dir
end

components.mode = function()
  local mode = statusline_mode.get_current_mode()
  local hi_group_name = statusline_mode.get_mode_highlight(mode)
  local display_name = statusline_mode.mode_display_name(mode)
  return highlight(hi_group_name, u.pad_string(display_name))
end

components.branch = conditional_component(is_git_repo, function()
  local name = vim.g.git_current_branch_name
  if name then
    return icons.git .. ' ' .. vim.g.git_current_branch_name
  end
end)

components.git_ahead_behind = conditional_component(is_git_repo, function()
  local state = vim.g.git_ahead_behind_count
  if state then
    if state.remote_exists then
      return u.trim_string(u.list_join({
        icons.up_arrow,
        tostring(state.ahead),
        icons.down_arrow,
        tostring(state.behind),
      }, ' '))
    else
      return '(no remote)'
    end
  else
    return icons.up_arrow .. ' - ' .. icons.down_arrow .. ' -'
  end
end)

components.datetime = function()
  return vim.fn.strftime '%a %d %b %H:%M '
end

components.metals_status = function()
  local status = vim.g.metals_status
  if u.is_defined(u.trim_string(status)) then
    local scala_icon, scala_icon_highlight = dev_icons.get_icon_by_filetype 'scala'
    local highlighted_icon = u.with_highlight_group(scala_icon_highlight, scala_icon) -- TODO: Background should match StatusLine
    local highlight_text = u.with_highlight_group('StatusLine', status)
    return highlighted_icon .. ' ' .. highlight_text
  end
end

components.copilot = function()
  return CopilotEnabled and icons.copilot_enabled or ''
end

--------------------------------------------------------------------------
-- Statusline
--------------------------------------------------------------------------

function StatusLine()
  return u.list_join({
    components.mode(),
    components.cwd(),
    components.branch(),
    components.git_ahead_behind(),
    components.diagnostics(false),
    components.push_right,
    components.copilot(),
    components.datetime(),
  }, '  ')
end

vim.o.statusline = '%!v:lua.StatusLine()'

--------------------------------------------------------------------------
-- Winbar
--------------------------------------------------------------------------

function Winbar()
  return u.list_join({
    components.push_right,
    components.win_title(true),
    components.cursor_position(),
    components.diagnostics(true),
    components.readonly_status(),
    components.modification_status(),
    components.push_right,
  }, '  ')
end

vim.o.winbar = '%{%v:lua.Winbar()%}'
