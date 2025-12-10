---@class SystemDep
---@field [1] string
---@field check_type? string
---@field install? function

local M = {}

---@param name string
---@param check_type string
---@return boolean
local is_installed = function(name, check_type)
  local args

  if check_type == 'npm' then
    args = { 'npm', 'ls', '-g', name }
  else
    args = { 'which', name }
  end

  local result = vim.system(args):wait()

  return result.code == 0
end

M.installers = {
  ---@param package string
  npm = function(package)
    return function()
      vim.system({ 'npm', 'i', '-g', package }):wait()
    end
  end,
}

---@param names string[]
local function notify_missing(names)
  vim.schedule(function()
    vim.notify(string.format('WARNING: Missing system dependancy: %s', table.concat(names, ', ')), vim.log.levels.WARN)
  end)
end

---@param name string
local function notify_installing(name)
  vim.schedule(function()
    vim.notify(string.format('Installing missing system dependancy: %s', name))
  end)
end

---@param deps (string|SystemDep)[]
M.ensure_installed = function(deps)
  local missing = {}

  for _, dep in ipairs(deps) do
    local dep_name
    local check_type

    if type(dep) == 'string' then
      dep_name = dep
      check_type = 'which'
    else
      dep_name = dep[1]
      check_type = dep.check_type or 'which'
    end

    local installed = is_installed(dep_name, check_type)

    if not installed then
      if type(dep) == 'table' and dep.install then
        notify_installing(dep_name)
        vim.schedule(dep.install)
      else
        table.insert(missing, dep_name)
      end
    end
  end

  if #missing > 0 then
    notify_missing(missing)
  end
end

return M
