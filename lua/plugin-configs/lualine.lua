local utils = require 'utils'

local function metals_status()
  local status = vim.g.metals_status
  if (status == '' or status == nil) then
    return ''
  else
    return status
  end
end

local highlight_map = {
  ERROR = 'DiagnosticError',
  WARN = 'DiagnosticWarn',
  INFO = 'DiagnosticInfo',
  HINT = 'DiagnosticHint',
}

-- diagnostic_type can be one of ERROR, WARN, INFO, HINT
local function lsp_diagnostics_count_component(diagnostic_type)
  local function component()
    local count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity[diagnostic_type] })
    if (count > 0) then
      return count
    end
    return ''
  end

  local colors = utils.get_highlight_value(highlight_map[diagnostic_type])

  return {
    component,
    color = { fg = colors.fg, bg = colors.bg }
  }
end

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'catppuccin',
    component_separators = { left = nil, right = nil },
    section_separators = { left = nil, right = nil },
    disabled_filetypes = {},
    always_divide_middle = true,
    globalstatus = true,
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = {
      {
        'branch',
        icons_enabled = false,
        color = 'StatusLine'
      }
    },
    lualine_c = {
      '%=',
      {
        'filetype',
        icon_only = true
      },
      {

        'filename',
        path = 0,
      },
      lsp_diagnostics_count_component("INFO"),
      lsp_diagnostics_count_component("HINT"),
      lsp_diagnostics_count_component("WARN"),
      lsp_diagnostics_count_component("ERROR"),
      metals_status
    },
    lualine_x = {},
    lualine_y = {},
    lualine_z = { 'progress', 'location' }
  },
  tabline = {},
  extensions = {}
}
