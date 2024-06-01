return {
  'folke/tokyonight.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    require('tokyonight').setup {
      style = 'moon', -- The theme comes in three styles, `storm`, `moon`, a darker variant `night`
    }
    vim.cmd.colorscheme 'tokyonight'
  end,
}
