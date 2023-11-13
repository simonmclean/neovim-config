return function()
  local utils = require("utils")
  local scala_icon, scala_icon_highlight = require("nvim-web-devicons").get_icon_by_filetype("scala")

  local function metals_status()
    local status = vim.g.metals_status
    if type(status) == "string" and utils.trim_string(status) ~= "" then
      local highlighted_icon = utils.with_highlight_group(scala_icon_highlight, scala_icon) -- TODO: Background should match StatusLine
      local highlight_text = utils.with_highlight_group("StatusLine", status)
      return highlighted_icon .. " " .. highlight_text
    else
      return ""
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
      icon = "  ",
      color = "StatusLine",
    }
  end

  local function date_component()
    return {
      function()
        return vim.fn.strftime("%a %d %b %H:%M")
      end,
      color = "StatusLine",
    }
  end

  local winbar_color = "Normal"

  local filetype_icon = {
    "filetype",
    icon_only = true,
    color = winbar_color,
  }

  local filename = {
    "filename",
    path = 0,
    color = winbar_color,
  }

  local win_diagnostics = {
    "diagnostics",
    icons_enabled = true,
    color = winbar_color,
  }

  local function gstatus_component()
    if not utils.is_git_repo() then
      return function()
        return ""
      end
    end

    vim.loop.new_timer():start(0, 30 * 1000, vim.schedule_wrap(utils.update_git_status))

    local status = vim.g.personal_globals.git_status

    return {
      function()
        return " " .. status.ahead .. "  " .. status.behind
      end,
      color = "StatusLine",
    }
  end

  local spacer = { "%=", color = winbar_color }

  local winbar = {
    lualine_b = {
      spacer,
      {
        function()
          local lines_count = vim.api.nvim_buf_line_count(0)
          local cursor_pos = vim.api.nvim_win_get_cursor(0)
          local padding_char_count = string.len(lines_count) + string.len(cursor_pos[1]) + string.len(cursor_pos[2]) + 2
          local str = " "
          for _ = 1, padding_char_count, 1 do
            str = str .. " "
          end
          return str
        end,
        color = "winbar_color",
      },
      filetype_icon,
      filename,
      win_diagnostics,
      spacer,
    },
    lualine_c = {
      {
        "location",
        color = winbar_color,
        fmt = function(str)
          local rows_and_cols = utils.split_string(str, ":")
          local total_lines_count = vim.api.nvim_buf_line_count(0)
          return rows_and_cols[1] .. "/" .. total_lines_count .. ":" .. rows_and_cols[2]
        end,
      },
    },
  }

  require("lualine").setup({
    options = {
      icons_enabled = true,
      theme = "tokyonight",
      component_separators = { left = nil, right = nil },
      section_separators = { left = nil, right = nil },
      disabled_filetypes = {
        winbar = { "fugitive" },
      },
      always_divide_middle = true,
      globalstatus = true,
    },
    winbar = winbar,
    inactive_winbar = winbar,
    sections = {
      lualine_a = { "mode" },
      lualine_b = {
        project_directory_component(true),
        {
          "branch",
          icon = "󰊢",
          color = "StatusLine",
          on_click = function()
            require("telescope.builtin").git_branches()
          end,
        },
        gstatus_component(),
        {
          "diagnostics",
          sources = { "nvim_workspace_diagnostic" },
          diagnostics_color = {
            error = "StatusLine",
            warn = "StatusLine",
            hint = "StatusLine",
            info = "StatusLine",
          },
          on_click = function()
            require("trouble").toggle()
          end,
        },
      },
      lualine_c = {
        metals_status,
      },
      lualine_x = {},
      lualine_y = {},
      lualine_z = { date_component() },
    },
    tabline = {},
    extensions = {},
    refresh = {
      winbar = 500,
    },
  })
end
