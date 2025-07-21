local function check_for_update()
  -- Get current version from Neovim's version output.
  local version_output = vim.fn.system 'nvim --version | head -n 1'
  local current_version = version_output:match 'NVIM%s+(v[%d%.]+)'

  -- Fetch latest release info from GitHub API.
  local response = vim.fn.system 'curl -s https://api.github.com/repos/neovim/neovim/releases/latest'

  if not response or response == "" then
    vim.notify 'Unable to fetch the latest Neovim version.'
    return
  end

  local json = vim.fn.json_decode(response)
  local latest_version = json and json.tag_name or nil

  -- Handle potential null or missing latest_version.
  if not latest_version or latest_version == 'null' then
    vim.notify 'Unable to fetch the latest Neovim version.'
    return
  end

  if current_version ~= latest_version then
    vim.notify(string.format('Neovim update available: %s -> %s', current_version, latest_version))
  end
end

-- Delayed to avoid the noise of startup
vim.defer_fn(check_for_update, 5000)
