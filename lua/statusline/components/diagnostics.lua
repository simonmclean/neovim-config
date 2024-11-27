local u = require 'utils'
local icons = require 'icons'

return function(buffer_local)
  local diagnostics = vim.diagnostic.get(u.eval(function()
    if buffer_local then
      return 0
    end
  end))

  if not u.is_defined(diagnostics) then
    return
  end

  local counts = { errors = 0, warnings = 0, hints = 0, info = 0 }

  for _, diag in ipairs(diagnostics) do
    if diag.severity == vim.diagnostic.severity.ERROR then
      counts.errors = counts.errors + 1
    elseif diag.severity == vim.diagnostic.severity.WARN then
      counts.warnings = counts.warnings + 1
    elseif diag.severity == vim.diagnostic.severity.HINT then
      counts.hints = counts.hints + 1
    elseif diag.severity == vim.diagnostic.severity.INFO then
      counts.info = counts.info + 1
    end
  end

  local str = ''
  if counts.errors > 0 then
    str = str .. string.format(' %s %d', icons.error, counts.errors)
  end
  if counts.warnings > 0 then
    str = str .. string.format(' %s %d', icons.warn, counts.warnings)
  end
  if counts.hints > 0 then
    str = str .. string.format(' %s %d', icons.hint, counts.hints)
  end
  if counts.info > 0 then
    str = str .. string.format(' %s %d', icons.info, counts.info)
  end
  return u.trim_string(str)
end

