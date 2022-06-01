local function metals_status()
  local status = vim.g.metals_status
  if (status == '' or status == nil) then
    return ''
  else
    return status
  end
end

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = '|',
    section_separators = { left = nil, right = nil },
    disabled_filetypes = {},
    always_divide_middle = true,
    globalstatus = true,
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = {
      { 'branch', icons_enabled = false },
      'diagnostics'
    },
    lualine_c = {
      {
        'filename',
        path = 1, -- relative path
      },
      metals_status
    },
    lualine_x = {},
    lualine_y = { 'filetype' },
    lualine_z = { 'location' }
  },
  tabline = {},
  extensions = {}
}
