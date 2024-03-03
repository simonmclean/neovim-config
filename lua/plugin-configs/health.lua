--[[
-- This health check isn't specific to my plugin configs, but to my nvim config as a whole.
-- I only put it in this directoy because of the fussy way that nvim will try to find these health files
--]]

local check_version = function()
  if not vim.version.cmp then
    vim.health.error(string.format("Neovim out of date: '%s'. Upgrade to latest stable or nightly", tostring(vim.version())))
    return
  end

  if vim.version.cmp(vim.version(), { 0, 9, 5 }) >= 0 then
    vim.health.ok(string.format("Neovim version is: '%s'", tostring(vim.version())))
  else
    vim.health.error(string.format("Neovim out of date: '%s'. Upgrade to latest stable or nightly", tostring(vim.version())))
  end
end

local check_external_reqs = function()
  -- Basic utils: `git`, `make`, `unzip`
  for _, exe in ipairs { 'git', 'make', 'unzip', 'rg' } do
    local is_executable = vim.fn.executable(exe) == 1
    if is_executable then
      vim.health.ok(string.format("Found executable: '%s'", exe))
    else
      vim.health.warn(string.format("Could not find executable: '%s'", exe))
    end
  end

  return true
end

return {
  check = function()
    vim.health.start 'nvim_user_config'

    local uv = vim.uv or vim.loop
    vim.health.info('System Information: ' .. vim.inspect(uv.os_uname()))

    check_version()
    check_external_reqs()
  end,
}
