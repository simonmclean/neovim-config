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

  local gstatus = { ahead = 0, behind = 0 }

  local function update_gstatus()
    local Job = require("plenary.job")
    Job:new({
      command = "git",
      args = { "rev-list", "--left-right", "--count", "HEAD...@{upstream}" },
      on_exit = function(job, _)
        local res = job:result()[1]
        if type(res) ~= "string" then
          gstatus = { ahead = 0, behind = 0 }
          return
        end
        local ok, ahead, behind = pcall(string.match, res, "(%d+)%s*(%d+)")
        if not ok then
          ahead, behind = 0, 0
        end
        gstatus = { ahead = ahead, behind = behind }
      end,
    }):start()
  end

  vim.loop.new_timer():start(0, 30 * 1000, vim.schedule_wrap(update_gstatus))

  local function gstatus_component()
    return {
      function()
        return " " .. gstatus.ahead .. "  " .. gstatus.behind
      end,
      color = 'StatusLine'
    }
  end

  local spacer = { "%=", color = winbar_color }

  local winbar = {
    lualine_a = {
      spacer,
    },
    lualine_b = {
      spacer,
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
