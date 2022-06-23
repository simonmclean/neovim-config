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

  local hightlight_name = highlight_map[diagnostic_type]
  local highlight_colors = utils.get_highlight_values(hightlight_name)
  local bg, fg

  -- Try using the diagnostic color's foreground and background colors.
  -- If there is no background color for this theme, then use the foreground as the background,
  -- and use the StatusLine background as the foreground. So basically an inverted colorscheme
  if highlight_colors.background then
    bg = highlight_colors.background
    fg = highlight_colors.foreground
  else
    bg = highlight_colors.foreground
    fg = utils.get_highlight_values('StatusLine').background
  end

  return {
    component,
    color = { fg = fg, bg = bg }
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
        icon = '  ',
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
        path = 1,
      },
      lsp_diagnostics_count_component("INFO"),
      lsp_diagnostics_count_component("HINT"),
      lsp_diagnostics_count_component("WARN"),
      lsp_diagnostics_count_component("ERROR"),
      metals_status
    },
    lualine_x = {},
    lualine_y = {},
    lualine_z = {
      {
        'location',
        fmt = function(str)
          local rows_and_cols = utils.split_string(str, ':')
          local total_lines_count = vim.api.nvim_buf_line_count(0)
          return rows_and_cols[1] .. '/' .. total_lines_count .. ' : ' .. rows_and_cols[2]
        end
      }
    }
  },
  tabline = {},
  extensions = {}
}
