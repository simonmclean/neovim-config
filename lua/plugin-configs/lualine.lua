local utils = require 'utils'

local function metals_status()
  local status = vim.g.metals_status
  if (type(status) == 'string') then
    return status
  else
    return ''
  end
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

local diagnostics = { 'diagnostics', icons_enabled = false, color = winbar_color }

local spacer = { '%=', color = winbar_color }

local winbar = {
  lualine_a = {
    spacer
  },
  lualine_b = {
    spacer,
    filetype_icon,
    filename,
    diagnostics,
    spacer,
  },
  lualine_c = {
    {
      'location',
      color = winbar_color,
      fmt   = function(str)
        local rows_and_cols = utils.split_string(str, ':')
        local total_lines_count = vim.api.nvim_buf_line_count(0)
        return rows_and_cols[1] .. '/' .. total_lines_count .. ':' .. rows_and_cols[2]
      end
    }
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
    lualine_z = {}
  },
  tabline = {},
  extensions = {},
  refresh = {
    winbar = 500
  }
}
