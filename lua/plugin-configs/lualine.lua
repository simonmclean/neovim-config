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
  color = winbar_color,
  on_click = function()
    require('telescope.builtin').find_files()
  end,
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
  on_click = function()
    require 'telescope.builtin'.diagnostics()
  end
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
      on_click = function()
        require 'telescope.builtin'.lsp_document_symbols()
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
    lualine_z = { date_component() }
  },
  tabline = {},
  extensions = {},
  refresh = {
    winbar = 500
  }
}
