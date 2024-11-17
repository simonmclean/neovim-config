local u = require 'utils'
local dev_icons = require 'nvim-web-devicons'

return function()
  local status = vim.g.metals_status
  if u.is_defined(u.trim_string(status)) then
    local scala_icon, scala_icon_highlight = dev_icons.get_icon_by_filetype 'scala'
    local highlighted_icon = u.with_highlight_group(scala_icon_highlight, scala_icon)
    local highlight_text = u.with_highlight_group('StatusLine', status)
    return highlighted_icon .. ' ' .. highlight_text
  end
end
