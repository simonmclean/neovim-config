local u = require 'utils'
local su = require 'statusline.utils'

local mode_map = {
  ['n'] = 'NORMAL',
  ['no'] = 'O-PENDING',
  ['nov'] = 'O-PENDING',
  ['noV'] = 'O-PENDING',
  ['no\22'] = 'O-PENDING',
  ['niI'] = 'NORMAL',
  ['niR'] = 'NORMAL',
  ['niV'] = 'NORMAL',
  ['nt'] = 'NORMAL',
  ['ntT'] = 'NORMAL',
  ['v'] = 'VISUAL',
  ['vs'] = 'VISUAL',
  ['V'] = 'V-LINE',
  ['Vs'] = 'V-LINE',
  ['\22'] = 'V-BLOCK',
  ['\22s'] = 'V-BLOCK',
  ['s'] = 'SELECT',
  ['S'] = 'S-LINE',
  ['\19'] = 'S-BLOCK',
  ['i'] = 'INSERT',
  ['ic'] = 'INSERT',
  ['ix'] = 'INSERT',
  ['R'] = 'REPLACE',
  ['Rc'] = 'REPLACE',
  ['Rx'] = 'REPLACE',
  ['Rv'] = 'V-REPLACE',
  ['Rvc'] = 'V-REPLACE',
  ['Rvx'] = 'V-REPLACE',
  ['c'] = 'COMMAND',
  ['cv'] = 'EX',
  ['ce'] = 'EX',
  ['r'] = 'REPLACE',
  ['rm'] = 'MORE',
  ['r?'] = 'CONFIRM',
  ['!'] = 'SHELL',
  ['t'] = 'TERMINAL',
}

local mode_to_kind = {
  ['VISUAL'] = 'visual',
  ['V-BLOCK'] = 'visual',
  ['V-LINE'] = 'visual',
  ['SELECT'] = 'visual',
  ['S-LINE'] = 'visual',
  ['S-BLOCK'] = 'visual',
  ['REPLACE'] = 'replace',
  ['V-REPLACE'] = 'replace',
  ['INSERT'] = 'insert',
  ['COMMAND'] = 'command',
  ['EX'] = 'command',
  ['MORE'] = 'command',
  ['CONFIRM'] = 'command',
  ['TERMINAL'] = 'terminal',
}

local kind_to_colors = {
  ['visual'] = { fg = '#1b1d2b', bg = '#c099ff' },
  ['replace'] = { fg = '#1b1d2b', bg = '#ff757f' },
  ['insert'] = { fg = '#1b1d2b', bg = '#c3e88d' },
  ['command'] = { fg = '#1b1d2b', bg = '#ffc777' },
  ['terminal'] = { fg = '#1b1d2b', bg = '#4fd6be' },
  ['normal'] = { fg = '#1b1d2b', bg = '#82aaff' },
}

for kind, colors in pairs(kind_to_colors) do
  vim.api.nvim_set_hl(0, 'StatusLineMode_' .. kind, colors)
end

local function get_current_mode()
  local current_mode = vim.api.nvim_get_mode().mode
  return mode_map[current_mode] or current_mode
end

local function get_mode_highlight(mode)
  local kind = mode_to_kind[mode] or 'normal'
  return 'StatusLineMode_' .. kind
end

local function mode_display_name(mode)
  local head = string.sub(mode, 1, 1)
  local tail = string.sub(mode, 2)
  return string.upper(head) .. string.lower(tail)
end

return function()
  local mode = get_current_mode()
  local hi_group_name = get_mode_highlight(mode)
  local display_name = mode_display_name(mode)
  return su.highlight(hi_group_name, u.pad_string(display_name))
end
