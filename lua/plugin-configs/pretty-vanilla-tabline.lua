return {
  'simonmclean/pretty-vanilla-tabline.nvim',
  config = function()
    local get_icon = require('nvim-web-devicons').get_icon_by_filetype
    local git_icon = get_icon 'git'

    require('pretty-vanilla-tabline').setup {
      filetype_icons = {
        DiffviewFiles = git_icon,
        DiffviewFileHistory = git_icon,
      },
    }
  end,
}
