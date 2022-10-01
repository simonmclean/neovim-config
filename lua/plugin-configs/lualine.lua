local utils = require 'utils'

local function metals_status()
  local status = vim.g.metals_status
  if (type(status) == 'string') then
    return status
  else
    return ''
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

local function project_directory_component()
  local function component()
    local path = vim.fn.getcwd()
    local parts = utils.split_string(path, '/')
    return utils.last(parts)
  end

  return {
    component,
    icon = '  ',
    color = 'StatusLine',
    on_click = function()
      require('telescope.builtin').find_files()
    end
  }
end

local winbar_color = 'Normal'

-- TODO: Figure out how to use this icon component in
-- conjunction with the 'cleared' highlight color
local filetype_icon = {
  'filetype',
  icon_only = true,
  color = winbar_color
}

local filename = {
  'filename',
  path = 0,
  color = winbar_color
}

local spacer = { '%=', color = winbar_color }

local winbar = {
  lualine_a = {
    spacer,
    filetype_icon,
    filename,
    lsp_diagnostics_count_component("INFO"),
    lsp_diagnostics_count_component("HINT"),
    lsp_diagnostics_count_component("WARN"),
    lsp_diagnostics_count_component("ERROR"),
    spacer,
  }
}

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'catppuccin',
    component_separators = { left = nil, right = nil },
    section_separators = { left = nil, right = nil },
    disabled_filetypes = {
      winbar = { 'fugitive' }
    },
    always_divide_middle = true,
    globalstatus = true,
  },
  winbar = winbar,
  inactive_winbar = winbar,
  sections = {
    lualine_a = { 'mode' },
    lualine_b = {
      project_directory_component(),
      {
        'branch',
        icon = ' ',
        color = 'StatusLine',
        on_click = function()
          require('telescope.builtin').git_branches()
        end
      },
    },
    lualine_c = {
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
  extensions = {},
  refresh = {
    winbar = 500
  }
}
