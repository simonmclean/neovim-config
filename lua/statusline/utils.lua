local M = {}

-- Cache to store highlight groups so we don't recreate them unnecessarily
local hl_cache = {}

--- Get either the foreground (fg) or background (bg) color of a highlight group.
--- @param hl_name string
--- @param part ('fg' | 'bg')
--- @return string|nil - Hex color if found
local function get_hl_color(hl_name, part)
  local hl = vim.api.nvim_get_hl(0, { name = hl_name, link = false })

  -- Convert to hex strings
  if part == 'fg' then
    return hl.fg and string.format('#%06x', hl.fg)
  elseif part == 'bg' then
    return hl.bg and string.format('#%06x', hl.bg)
  end
end

--- Get or create a highlight group by combining the foreground of the icon highlight with the background of the winbar.
--- If the group has already been created, return it from the cache.
--- @param icon_hl string
--- @param bg_hl string
--- @return string
local function get_or_create_hl(icon_hl, bg_hl)
  local cache_key = icon_hl .. '_' .. bg_hl

  if hl_cache[cache_key] then
    return hl_cache[cache_key]
  end

  -- If not cached, retrieve the foreground color of the icon and background color of the winbar
  local icon_fg = get_hl_color(icon_hl, 'fg')
  local winbar_bg = get_hl_color(bg_hl, 'bg')
  local hl_group = cache_key

  vim.api.nvim_set_hl(0, hl_group, { fg = icon_fg, bg = winbar_bg })

  hl_cache[cache_key] = hl_group

  return hl_group
end

--- Return the properly highlighted string for the winbar with the icon.
--- Ensures the icon has the correct foreground (e.g., from DevIcon) and the correct background (from WinBar).
--- @param icon_hl string
--- @param icon_str string
--- @return string
 function M.highlight_with_icon(icon_hl, icon_str)
  local hl_group = get_or_create_hl(icon_hl, 'WinBar')
  return '%#' .. hl_group .. '#' .. icon_str .. '%#WinBar#'
end

function M.highlight(hi_group_name, str)
  return '%#' .. hi_group_name .. '#' .. str .. '%#%Winbar#'
end

return M
