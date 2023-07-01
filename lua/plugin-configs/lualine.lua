local utils = require 'utils'
local scala_icon = require 'nvim-web-devicons'.get_icon("scala")

local function metals_status()
  local status = vim.g.metals_status
  if (type(status) == 'string' and utils.trim_string(status) ~= "") then
    return scala_icon .. " " .. status
  else
    return ''
  end
end

local function project_directory_component(basename_only)
  local function component()
    local path = vim.fn.getcwd()
    if basename_only then
      return vim.fs.basename(path)
    end
    return path
  end

  return {
    component,
    icon = '  ',
    color = 'StatusLine',
  }
end

local function date_component()
  return {
    function()
      return vim.fn.strftime('%a %d %b %H:%M')
    end,
    color = 'StatusLine'
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
  color = winbar_color,
  -- file_status = false
}

-- TODO: Maybe raise an issue about the jankiness of this?
-- local diff = {
--   'diff',
--   color = winbar_color
-- }

local diagnostics = {
  'diagnostics',
  icons_enabled = false,
  color = winbar_color,
}

local spacer = { '%=', color = winbar_color }

local winbar = {
  lualine_a = {
    spacer
  },
  lualine_b = {
    spacer,
    filetype_icon,
    filename,
    -- diff,
    diagnostics,
    spacer,
  },
  lualine_c = {
    {
      'location',
      color    = winbar_color,
      fmt      = function(str)
        local rows_and_cols = utils.split_string(str, ':')
        local total_lines_count = vim.api.nvim_buf_line_count(0)
        return rows_and_cols[1] .. '/' .. total_lines_count .. ':' .. rows_and_cols[2]
      end,
    }
  }
}

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'tokyonight',
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
      project_directory_component(true),
      {
        'branch',
        icon = ' ',
        color = 'StatusLine',
      },
    },
    lualine_c = {
      metals_status
    },
    lualine_x = {},
    lualine_y = {},
    lualine_z = { date_component() }
  },
  tabline = {},
  extensions = {},
  refresh = {
    winbar = 500
  }
}
