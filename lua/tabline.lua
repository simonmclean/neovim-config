local _ = require 'utils'
local api = vim.api
local devicon_installed, devicons = pcall(require, 'nvim-web-devicons')

local function with_padding(str)
  return ' ' .. str .. ' '
end

local function with_highlight_group(group_name, str)
  return '%#' .. group_name .. '#' .. str
end

local function with_click_handler(tab_id, str)
  return '%' .. tab_id .. '@v:lua.my_custom_tabline_switch_tab@' .. str .. '%T'
end

_G.my_custom_tabline_switch_tab = function(id)
  api.nvim_set_current_tabpage(id)
end

_G.my_custom_tabline = function()
  local tabs = api.nvim_list_tabpages()
  local current_tab = api.nvim_get_current_tabpage()
  -- For each tab check if it's the currently focused one
  local with_is_active = _.list_map(tabs, function(tab_id)
    return {
      tab_id = tab_id,
      is_active = tab_id == current_tab
    }
  end)
  -- For each tab get the focused window
  local with_win_id = _.list_map(with_is_active, function(tab)
    tab['win_id'] = api.nvim_tabpage_get_win(tab.tab_id)
    return tab
  end)
  -- For each window get buffer info
  local with_buf_data = _.list_map(with_win_id, function(tab)
    local buf_id = api.nvim_win_get_buf(tab.win_id)
    tab['buf_id'] = buf_id
    tab['buf_name'] = api.nvim_buf_get_name(buf_id)
    tab['buf_filetype'] = api.nvim_buf_get_option(buf_id, 'filetype')
    return tab
  end)
  -- For each tab set the title
  local with_tab_titles = _.list_map(with_buf_data, function(tab)
    local filename = _.last(_.split_string(tab.buf_name, '/'))
    -- If nvim-web-devicons is installed, get the filetype icon from that
    local icon = _.eval(function()
      if (devicon_installed and tab.buf_filetype) then
        local icon = devicons.get_icon_by_filetype(tab.buf_filetype)
        if (icon) then
          return icon .. ' '
        end
      end
      return ''
    end)
    -- Set tab title to filename, or filetype, or fallback
    if (filename == "") then
      if (tab.buf_filetype == "") then
        tab['title'] = '[empty tab]'
      else
        tab['title'] = icon .. tab.buf_filetype
      end
    else
      tab['title'] = icon .. filename
    end
    return tab
  end)
  -- Create the tabline strings, including highlight groups
  local tabline_strings = _.list_map(with_tab_titles, function(tab)
    local highlight_group = _.eval(function()
      if (tab.is_active) then
        return 'TabLineSel'
      end
      return 'TabLine'
    end)
    return with_highlight_group(highlight_group, with_padding(with_click_handler(tab.tab_id, tab.title)))
  end)
  local tabline = _.list_join(tabline_strings) .. '%#TabLineFill#%='
  return tabline
end

vim.o.tabline = '%!v:lua.my_custom_tabline()'
