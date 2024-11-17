local dev_icons = require 'nvim-web-devicons'
local u = require 'utils'
local su = require 'statusline.utils'
local icons = require 'statusline.icons'

return function(full_title)
  local filetype_overrides = {
    fugitive = { 'Git', icons.git },
    qf = { 'Quickfix', icons.list },
    ['copilot-chat'] = { 'Copilot', icons.copilot_enabled },
  }
  local buftype_overrides = {
    terminal = { 'Terminal', icons.terminal },
  }
  local ft = vim.bo.filetype
  local bt = vim.bo.buftype
  ---@type string, string?, string?
  local title, icon, icon_hi = u.eval(function()
    local ft_override = filetype_overrides[ft]
    if ft and ft_override then
      return ft_override[1], ft_override[2]
    end
    local bt_override = buftype_overrides[bt]
    if bt and bt_override then
      return bt_override[1], bt_override[2]
    end
    -- If there isn't a buftype or filetype override, use the bufname as the title
    local maybe_title = full_title and vim.fn.expand '%:.' or vim.fn.expand '%:p'
    if u.is_defined(maybe_title) then
      local icon, icon_hi = dev_icons.get_icon_by_filetype(ft)
      return maybe_title, icon, icon_hi
    end
    return ft
  end)
  return icon and (su.highlight_with_icon(icon_hi or 'Winbar', icon) .. ' ' .. title) or title
end


