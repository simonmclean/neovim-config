local function metals_status()
  local status = vim.g.metals_status
  if (status == '' or status == nil) then
    return ''
  else
    return status
  end
end

-- diagnostic_type can be one of ERROR, WARN, INFO, HINT
local function lsp_diagnostics_count(diagnostic_type)
  return function()
    local count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity[diagnostic_type] })
    if (count > 0) then
      return count
    end
    return ''
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
      { 'branch', icons_enabled = false }
    },
    lualine_c = {
      {
        'filename',
        path = 1, -- relative path
      },
      -- TODO: The color option on these lsp_diagnostics_count components doesn't work
      {
        lsp_diagnostics_count("INFO"),
        { color = { bg = "#4287f5" } }
      },
      {
        lsp_diagnostics_count("HINT"),
        { color = { bg = "#4287f5" } }
      },
      {
        lsp_diagnostics_count("WARN"),
        { color = { bg = "#4287f5" } }
      },
      {
        lsp_diagnostics_count("ERROR"),
        { color = 'DiagnosticError' }
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
