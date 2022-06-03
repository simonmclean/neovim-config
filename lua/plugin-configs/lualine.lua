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
  ERROR = { 'DiagnosticError', 'StatusLine' },
  WARN = { 'DiagnosticWarn', 'StatusLine' },
  INFO = { 'DiagnosticInfo', 'StatusLine' },
  HINT = { 'DiagnosticHint', 'StatusLine' },
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

  local colors = highlight_map[diagnostic_type]
  local bg_color = utils.get_highlight_value(colors[1])
  local fg_color = utils.get_highlight_value(colors[2])

  return {
    component,
    color = { fg = fg_color, bg = bg_color }
  }
end

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = '|',
    section_separators = { left = nil, right = nil },
    disabled_filetypes = {},
    always_divide_middle = true,
    globalstatus = true,
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = {
      { 'branch', icons_enabled = false }
    },
    lualine_c = {
      {
        'filename',
        path = 1, -- relative path
      },
      lsp_diagnostics_count_component("INFO"),
      lsp_diagnostics_count_component("HINT"),
      lsp_diagnostics_count_component("WARN"),
      lsp_diagnostics_count_component("ERROR"),
      metals_status
    },
    lualine_x = {},
    lualine_y = { 'filetype' },
    lualine_z = { 'location' }
  },
  tabline = {},
  extensions = {}
}
