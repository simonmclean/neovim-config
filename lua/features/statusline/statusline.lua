local u = require 'utils'
local statusline_mode = require 'features.statusline.statusline_mode'
local dev_icons = require 'nvim-web-devicons'

require 'features.statusline.statusline_branch' -- Need to require this to kick off the functionality
require('features.statusline.statusline_commits').new()

local function highlight(hi_group_name, str)
  return '%#' .. hi_group_name .. '#' .. str .. '%#%StatusLine#'
end

--------------------------------------------------------------------------
-- Icons
--------------------------------------------------------------------------

local icons = {
  git = '󰊢',
  dir = '',
  up_arrow = '',
  down_arrow = '',
}

--------------------------------------------------------------------------
-- Components
--------------------------------------------------------------------------

local components = {}

components.push_right = '%='

components.filetype = '%y'

components.modification_status = '%m'

components.readonly_status = '%r'

components.cursor_position = function()
  local lines_count = vim.api.nvim_buf_line_count(0)
  local pos = vim.api.nvim_win_get_cursor(0)
  return pos[1] .. '/' .. lines_count
end

components.win_title = function()
  local filename = vim.fn.expand '%:t'
  local filetype = vim.bo.filetype
  local icon, icon_hi
  if filetype then
    icon, icon_hi = dev_icons.get_icon_by_filetype(filetype)
  end
  local title = u.eval(function()
    if u.is_defined(filename) then
      return filename
    end
    return filetype
  end)
  return u.eval(function()
    if icon then
      return highlight(icon_hi, icon) .. ' ' .. title
    end
    return title
  end)
end

local diagnostic_signs = { error = '', warn = '', hint = '', info = '' }

components.diagnostics = function(buffer_local)
  local diagnostics = vim.diagnostic.get(u.eval(function ()
    if buffer_local then
      return 0
    end
  end))
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
    str = str .. string.format(' %s %d', diagnostic_signs.error, counts.errors)
  end
  if counts.warnings > 0 then
    str = str .. string.format(' %s %d', diagnostic_signs.warn, counts.warnings)
  end
  if counts.hints > 0 then
    str = str .. string.format(' %s %d', diagnostic_signs.hint, counts.hints)
  end
  if counts.info > 0 then
    str = str .. string.format(' %s %d', diagnostic_signs.info, counts.info)
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

components.branch = function()
  local name = vim.g.statusline_branch_name
  if name then
    return icons.git .. ' ' .. vim.g.statusline_branch_name
  end
end

components.git_ahead_behind = function()
  local state = vim.g.statusline_commits
  if state then
    return u.trim_string(u.list_join({
      icons.up_arrow,
      state.ahead,
      icons.down_arrow,
      state.behind
    }, ' '))
  else
    return icons.up_arrow .. ' - ' .. icons.down_arrow .. ' -'
  end
end

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
    components.win_title(),
    components.cursor_position(),
    components.diagnostics(true),
    components.readonly_status,
    components.modification_status,
    components.push_right,
  }, '  ')
end

vim.o.winbar = '%{%v:lua.Winbar()%}'