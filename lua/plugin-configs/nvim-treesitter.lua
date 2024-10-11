return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  dependencies = {},
  config = function()
    require('nvim-treesitter.configs').setup {
      indent = {
        enable = true, -- without this JSX auto-indentation doesn't work as expected
      },
      highlight = {
        enable = true,
        custom_captures = {
          -- Highlight the @foo.bar capture group with the "Identifier" highlight group.
          -- ["foo.bar"] = "Identifier",
        },
      },
      auto_install = true,
    }

    vim.treesitter.language.register('terraform', 'terraform-vars')
  end,
}
