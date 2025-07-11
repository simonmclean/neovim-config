-- Pretty markdown files

return {
  'OXY2DEV/markview.nvim',
  lazy = false,
  priority = 49, -- Ensures markview is loaded before treesitter
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
  opts = {
    markdown = {
      list_items = {
        shift_width = 2,
      },
    },
  },
}
