local icons = require 'icons'

return function()
  local git = vim.g.git

  if git.state == 'INITIALISING' or git.state == 'NO_REPO' then
    return
  end

  local repo = git.repo

  if not repo.branch_remote then
    return '(no remote)'
  end

  if repo.status.local_commits_not_in_remote then
    return string.format(
      '%s %s %s %s',
      icons.up_arrow,
      repo.status.local_commits_not_in_remote,
      icons.down_arrow,
      repo.status.remote_commits_not_in_local
    )
  else
    return string.format('%s - %s -', icons.up_arrow, icons.down_arrow)
  end
end
